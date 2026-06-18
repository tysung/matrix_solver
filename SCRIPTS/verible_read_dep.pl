#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Cwd qw(getcwd);
use Data::Dumper;
use Env;
use File::Basename;
use Cwd qw(cwd getcwd);
#use Excel::Writer::XLSX; 

# command line args used 
my $date = `date +"%m-%d-%Y"`;
chomp($date);

BEGIN { 
	# make sure the number of command line arguments is correct 
	$ENV{'IFT_XILINX_TOOLS'}="/export/tools/xilinx/14.7/ISE_DS";
	$ENV{'PERL5LIB'}="/import/home/tsung/QA/lib/perl5";
	push @INC, '/import/home/tsung/QA/lib/perl5';
	require Excel::Writer::XLSX; 

} 

my $dep_gph = "/import/home/tsung/CODE/verible/LOG.dep";

my $db = read_dep($dep_gph);
generate_tree($db);

#
#
exit(0);

sub generate_tree {
	my ($db) = @_;

	my $top_nodes = find_top($db);
	my $leaf_nodes = find_leaf($db);

	my $tree = BFS_hierarchy($db, $top_nodes, $leaf_nodes);

}


sub BFS_hierarchy {
	my ($db, $top_nodes, $leaf_nodes) = @_;

	my $tmp = {};
	my $table = {};
	my $queue = []; # insert node_id as entry
	my $pkg_hash = {};
	# Hierarchical package tree for makefile with a list of targets. 
	my $tree_pkg_root = { 'root' => undef };
	# id to node conversion
	foreach my $node (keys %{$db->{'nodes'}}) {
		$table->{$db->{'nodes'}->{$node}->{'id'}} = { 'db' => $node, 'pkg_tree' => undef };
	}
	foreach my $top (@$top_nodes) {
		$top =~ /^(.*):(.*)$/;
		my $package = $1;
		my $target = $2;
		my $cur_id = $db->{'nodes'}->{$top}->{'id'};
		$tmp = { 
			  'level' => 0, 
			  'dn_l' => [], 
			  'up_l' => undef, 
			  'targets' => [$target], 
			  'db_id' => $cur_id,
			  'pkg' => $package
		};
		$tree_pkg_root->{$package} = $tmp;
		$tree_pkg_root->{'root'} = $package;
		$pkg_hash->{$package} = 1;

		# back pointer from db_id node to tree_pkg_node
		$db->{'nodes'}->{$top}->{'pkg_tree'} = $tmp;
		$table->{$cur_id}->{'pkg_tree'} = $tmp;
		push(@$queue, $cur_id);

		# retrieve the DFS traversal nodes from queue
		while ( scalar(@$queue) > 0 ) {
			my $cur_node = $table->{shift(@$queue)}->{'db'};
			if( ! defined $db->{'nodes'}->{$cur_node}->{'dn_l'} ) {
				next;
			}
			my $edge_ls = $db->{'nodes'}->{$cur_node}->{'dn_l'};
			foreach my $edge (@$edge_ls) {
				$edge =~ /^(.*)-(.*)$/;
				my $parent = $1;
				my $child = $2;
				my $child_node = $table->{$child}->{'db'};
				# check if this is leaf nodes, then add a pkg_tree_node
				if( exists $leaf_nodes->{$child} ) {
					next;	
				} else {
					# insert into pkg_tree_root
					$child_node =~ /^(.*):(.*)$/;
					my $package = $1;
					my $target = $2;
					# get parent pkg_tree infomation to generate child pkg_tree_node
					if( exists $pkg_hash->{$package} ) {
						push(@{$tree_pkg_root->{$package}->{'target'}}, $target);
					} else {
						my $pkg_node_parent = $table->{$parent}->{'pkg_tree'};
						if( ! defined $pkg_node_parent ) {
							print("$child_node fails in DFS search. \n");
							exit(1);
						}
						$tmp = { 
			  				'level' => $pkg_node_parent->{'level'} + 1, 
			  				'dn_l' => [], 
			  				'up_l' => $pkg_node_parent, 
			  				'targets' => [$target], 
			  				'pkg' => $package, 
			  				'db_id' => $child 
						};
						#
						# remove this for readable tree hierarchy
						#
						# $tree_pkg_root->{$package} = $tmp;
						$pkg_hash->{$package} = 1;
						#
						# back pointer from db_id node to tree_pkg_node
						$db->{'nodes'}->{$top}->{'pkg_tree'} = $tmp;
						$table->{$child}->{'pkg_tree'} = $tmp;
						#
						# pkg_node_parent add the "dn_l" link children
						# If updated this pkg_node_parent could be a problem to reference later???
						#$tmp = { 
						#	'level' => $pkg_node_parent->{'level'} + 1, 
						#	'dn_l' => [], 
						#	'up_l' => $pkg_node_parent, 
						#	'targets' => [$target], 
						#	'pkg' => $package, 
						#	'db_id' => $child 
						#};
						push(@{$pkg_node_parent->{'dn_l'}}, $tmp);
						#
						push(@$queue, $child);
					}

				} 
			}
		}
	}

	$tree_pkg_root->{'hash'} = $pkg_hash;

	open(DUMPFILE, '>', "./pkg_tree_dump") or die "Couldn't open file for writing pkg_tree_dump - $!. \n";
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	print DUMPFILE Data::Dumper->Dump( [$tree_pkg_root], [qw(tree_pkg_root)] );
	close(DUMPFILE) or die "Couldn't close the file pkg_tree_dump \n";

	# print the DFS hierarchy result
	#open(FD, '>', "./pkg_tree_ls") or die "Couldn't open file for writing pkg_tree_ls - $!. \n";
	#my $root = $tree_pkg_root->{'root'};
	#print FD "
	#my $pkg_ls = $tree_pkg_root->{$root}->{'dn_l'};
	#foreach my $pkg_ch (@$pkg_ls) {
	#
	#}
	
}


sub find_top {
	my ($db) = @_;

	my @out = ();
	foreach my $node (keys %{$db->{'nodes'}}) {
		if( scalar(@{$db->{'nodes'}->{$node}->{'up_l'}}) == 0 ) {
			push(@out, $node);
		}
	}
	return([@out]);
}


sub find_leaf {
	my ($db) = @_;

	my $out = {};
	foreach my $node (keys %{$db->{'nodes'}}) {
		if( scalar(@{$db->{'nodes'}->{$node}->{'dn_l'}}) == 0 ) {
			my $id = $db->{'nodes'}->{$node}->{'id'};	
			$out->{$id} = $node;
		}
	}
	return($out);
}


sub read_dep {
	my ($dep_gph) = @_;

	my $node_hash = {};

	my $db = { 'repos' => {}, 'nodes' => {}, 'edges' => {}, 'extern_repos' => {} };
	open(FILE, $dep_gph) or die("Could not open $dep_gph file.");

	my @words = ();
	my $count = 0; 
	my $id = 0;
	my $lid = 0;
	my $f_begin = 0;
	my $part = '';
	my $family = '';
	foreach my $line (<FILE>)  {   
		#print $line;    
		$count++;
		if( $line =~ /digraph/ ) {
			next;
		} elsif( $line =~ /shape=box/ ) {
			$f_begin = 1;
			next;
		} elsif( $line =~ /\}/ ) {
			last;
		}

		#
		# here to handle edges
		#
		if(($f_begin == 1) && ($line =~ /->/)) {
			@words = split(/->/, $line);
			my $parent = $words[0];
			my $child = $words[1];
			$parent =~ s/^\s+\"|\"\s+$//g;
			$child =~ s/^\s+\"|\"\s+$//g;
			my $msg = '';
			if( ! exists $db->{'nodes'}->{$parent} ) {
				print "Parent node $parent is not found. \n";
				exit(1);
			} else {
				# insert child node and this edge, first check if exists already ?!
				if ( ! exists $db->{'nodes'}->{$child} ) {
					$msg = "Child node $child at id=${id} line=${count} ";
					$db->{'nodes'}->{$child} = {'id' => $id++, 'line' => undef, 'up_l' => [], 'dn_l' => []};
					#
					if( $child =~ /\\n/ ) {
						#print "Child node $child with leaf cell files at line=${count}\n";
						$msg = $msg . "with leaf cell files!";
						my @set1 = ();
						my $leaf_name = "leaf_${lid}";
						$lid++;
						@words = split(/\\n/, $child);
						foreach my $file (@words) {
							print "File = $file \n";
							push(@set1, $file);
						}
						$db->{'nodes'}->{$child}->{'set'} = [@set1];
						$db->{'nodes'}->{$child}->{'leaf'} = $leaf_name;
					}
				}
				my $par_id = $db->{'nodes'}->{$parent}->{'id'};
				my $chd_id = $db->{'nodes'}->{$child}->{'id'};
				my $edge_name = $par_id . "-" . $chd_id;
				if($edge_name eq "2025-97") {
					print("Debug - edge = $edge_name \n");
				}
				$db->{'edges'}->{$edge_name} = {'line' => $count};
				push(@{$db->{'nodes'}->{$parent}->{'dn_l'}}, $edge_name);
				push(@{$db->{'nodes'}->{$child}->{'up_l'}}, $edge_name);
			}
			print "$msg \n";
		} else {
		#
		# here to handle nodes
		#
			$line =~ s/^\s+\"|\"\s+$//g;
			# group of header files or .cc files 
			if( exists $db->{'nodes'}->{$line} ) {
				# if nodes exists thru edge creation, update it's line number and replace "undef"
				$db->{'nodes'}->{$line}->{'line'} = $count;
			} elsif( $line =~ /\\n/ ) {
				print "Ind node $line with leaf cell files at line=${count} lid=${lid}\n";
				my @set1 = ();
				my $leaf_name = "leaf_${lid}";
				$lid++;
				$db->{'nodes'}->{$line} = {'id' => $id++, 'line' => $count, 'up_l' => [], 'dn_l' => []};
				@words = split(/\\n/, $line);
				foreach my $file (@words) {
					print "File = $file \n";
					push(@set1, $file);
				}
				$db->{'nodes'}->{$line}->{'set'} = [@set1];
				$db->{'nodes'}->{$line}->{'leaf'} = $leaf_name;
			} else {
				if( ! exists $db->{'nodes'}->{$line} ) {
					print "Reg node $line with leaf cell files at id=${id} line=${count}\n";
					$db->{'nodes'}->{$line} = {'id' => $id++, 'line' => $count, 'up_l' => [], 'dn_l' => []};
				}

			}
			#$type = '';
		}
		#$count++;
		
	}
	close(FILE);

	open(DUMPFILE, '>', "./db_dump") or die "Couldn't open file for writing db_dump - $!. \n";
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	print DUMPFILE Data::Dumper->Dump( [$db], [qw(db)] );
	close(DUMPFILE) or die "Couldn't close the file db_dump \n";

	return($db);
}

1;


