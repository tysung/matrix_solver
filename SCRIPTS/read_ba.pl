#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Data::Dumper;
use Cwd;

my $DB = {};
#
my $ba_vhd = "./luts1-0.vhd";
my $dump_file = "./db.dump";
my $mod_list_file = "./mod.pm";
my $signal_name = "harness_test_region_i_SLICE_X1Y1_check_error_latch_3650";
#my $signal_name = "harness_test_region_i_expected(1)";

my $golden_number = read_ba($ba_vhd, $DB);
#
generate_mods($DB);
#
generate_connect_to($DB);
#
open(OUTFILE, '>', $dump_file) or die "Couldn't open file for writing $dump_file - $!. \n";
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print OUTFILE Data::Dumper->Dump( [$DB], [qw(*DB)] );
close(OUTFILE) or die "Couldn't close the file $dump_file \n";
#
# now, read in mod list info and it's port direction 
#
my $db_mods={};
if( -e $mod_list_file ) {
   $db_mods = {};
   open(FILE, $mod_list_file) or die "Couldn't open file for reading $mod_list_file - $!. \n";
   my $sep = $/;
   undef $/;
   eval <FILE>;
   close FILE;
   $/ = $sep;
}

#
# now, go find all the instances in SLICE_X1Y1
#
#
#
my $root_tree = ba_backtrace($DB, $db_mods, $signal_name);
#
open(OUTFILE, '>', "./result.pm") or die "Couldn't open file for writing result_file - $!. \n";
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print OUTFILE Data::Dumper->Dump( [$root_tree], [qw(*root_tree)] );
close(OUTFILE) or die "Couldn't close the file result_file \n";
#
write_result($root_tree);
#open(OUTFILE, '>', "./result_file") or die "Couldn't open file for writing result_file - $!. \n";
#print OUTFILE join("\n", @$result);
#close(OUTFILE) or die "Couldn't close the file result_file \n";
#my $list = ba_find_locinst($DB, "SLICE_X1Y1");
#my $result = ba_find_inst($DB, "harness\/tpg_i");

exit(0);

sub write_result {
	my ($root_tree) = @_; 


	open(OUTFILE, '>', "./write.pm") or die "Couldn't open file for writing result_file - $!. \n";
	my $result = write_result_node($root_tree);
	$result->[0] =~ s/^/\$root_tree \= /;
	my $size = @$result;
	$result->[$size-1] =~ s/}$/};/;
	print OUTFILE join("\n", @$result);
	close(OUTFILE) or die "Couldn't close the file result_file \n";

}

sub write_result_node {
	my ($root_tree) = @_; 

	my $level = $root_tree->{'lvl'};
	my $ident = "\t";
	#for(my $i=0; $i<$level; $i++) {
	#	$ident .= "\t";
	#}
	my $arr_cont = write_content($root_tree);
	my $arr_dn = [];
	my $dn_str;
	foreach my $conn (sort keys %{$root_tree->{'dn'}}) {
		my $chd_node = $root_tree->{'dn'}->{$conn};
		if( ref $chd_node eq "HASH" ) {
			my $arr_chd = write_result_node($chd_node);
			@$arr_chd = map { ${ident} . $_ } @$arr_chd;
			$dn_str = "${ident}\"$conn\" => ";
			$arr_chd->[0] =~ s/^/${dn_str}/;
			my $size = @$arr_chd;
			$arr_chd->[$size-1] =~ s/}$/},/;
			$arr_dn = [ (@$arr_dn, @$arr_chd) ];
		} else {
			$dn_str = "${ident}\"$conn\" => \"${chd_node}\",";
			$arr_dn = [ (@$arr_dn, $dn_str) ];
		}
	}	
	my $dn_header = "\"dn\" => {";
	my $dn_footer = "}";
	my $node_header = "{";
	my $node_footer = "}";

	my $size = scalar(@$arr_dn);
	if( $size > 1 ) {
		$arr_dn->[$size-1] =~ s/,$//;
	}
	my @all = (@$arr_cont, $dn_header, @$arr_dn, $dn_footer); 
	@all = map { ${ident} . $_ } @all;
	@all = ( $node_header, @all, $node_footer );
	return([@all]);
}

sub write_content {
	my ($root_node) = @_; 

	my $str = [];
	$str->[0] = "\"lvl\" => $root_node->{'lvl'},";
	$str->[1] = "\"o_net\" => \"$root_node->{'o_net'}\",";
	$str->[2] = "\"name\" => \"$root_node->{'name'}\",";
	$str->[3] = "\"pin\" => \"$root_node->{'pin'}\",";
	if( defined $root_node->{'init'} ) {
		$str->[4] = "\"init\" => \"$root_node->{'init'}\",";
	}
	#my $all = join("\n", @$str);
	return($str);
}

sub ba_backtrace {
	my ($DB, $db_mods, $root_net) = @_; 

	my $root_node = {};
	unless ( defined $DB->{'nets'}->{$root_net} ) {
		return($root_node);
	}
	my ($root_inst, $conn) = DFS_drv_inst($DB, $root_net);
	$root_node = DFS($DB, $db_mods, $root_inst, $root_net, $conn, 0);

	return($root_node);
}

#
# pre-order DFS search - do parent before children (so, we can levelized)
#
sub DFS {
	my ($DB, $db_mods, $r_inst, $r_net, $conn, $level) = @_; 

	$DB->{'insts'}->{$r_inst}->{'mark'} = $level;
	my $mod = $DB->{'insts'}->{$r_inst}->{'m_name'};
	$DB->{'nets'}->{$r_net}->{'mark'} = $level;
	my $crt_node = { 'name' => $r_inst, 'pin' => "${mod}/${conn}", 'lvl' => $level, 'o_net' => $r_net, 'dn' => {} };
	if($mod eq "X_LUT6" or $mod eq "X_LUT5") {
		$crt_node->{'init'} = $DB->{'insts'}->{$r_inst}->{'gmap'}->{'INIT'};	
	}
	my $adj_nets = DFS_adj_nets($DB, $db_mods, $r_inst);
	if( scalar(keys %$adj_nets) == 0 ) {
		return($crt_node);
	}

	foreach my $adj_conn (keys %$adj_nets) {
		my $net = $adj_nets->{$adj_conn};
		# don't handle "1" VCC GND and net has been traversed.
		if( $net eq "VCC" or $net eq "GND" or (exists $DB->{nets}->{$net}->{'mark'}) ) {
			$crt_node->{'dn'}->{$adj_conn} = "net=${net}"; 
			next;
		}
		my ($drv_inst, $drv_conn) = DFS_drv_inst($DB, $net);
		if ( ! defined $drv_inst ) {
			$crt_node->{'dn'}->{$adj_conn} = "net=${net}"; 
			next;
		} elsif ( exists $DB->{insts}->{$drv_inst}->{'mark'} ) {
			$crt_node->{'dn'}->{$adj_conn} = "inst=${drv_inst}"; 
			next;
		}
		# do the recursive call to DFS again
		my $chd_node = DFS($DB, $db_mods, $drv_inst, $net, $drv_conn, $level+1);
		# insert this child node into down link of parent's
		$crt_node->{'dn'}->{$adj_conn} = $chd_node; 
		#push(@{$crt_node->{'dn'}}, $chd_node); 
	}
	return($crt_node);
}

sub DFS_adj_nets {
	my ($DB, $db_mods, $r_inst) = @_;

	my $result = {};
	# iterate over 'pmap' and retrieve "I" connected nets
	my $pmap = $DB->{'insts'}->{$r_inst}->{'pmap'};
	my $mod = $DB->{'insts'}->{$r_inst}->{'m_name'};
	foreach my $conn (keys %{$pmap}) {
		if( $db_mods->{$mod}->{'pmap'}->{$conn} eq "I" ) {
			my $net = $pmap->{$conn};
			$result->{$conn} = $net;
			#push(@$result, $net);
		}
	}
	return($result);
}

sub DFS_drv_inst {
	my ($DB, $r_net) = @_; 

	# iterative to "O" connection port as starting instance to backtrace
	my $drv_inst;
	my $drv_conn;
	my $connect_to = $DB->{'nets'}->{$r_net}->{'connect_to'};
	foreach my $inst (keys %{$connect_to}) {
		my $conn = $connect_to->{$inst};
		my $mod_name = $DB->{'insts'}->{$inst}->{'m_name'};
		if($db_mods->{$mod_name}->{'pmap'}->{$conn} eq "O") {
			#if($db_mods->{$mod_name}->{'type'} eq 'comb') {
				$drv_inst = $inst;
				$drv_conn = $conn;
			#}
		}
	}
	return($drv_inst, $drv_conn);
}


sub generate_connect_to {
	my ($DB) = @_; 

	foreach my $inst (sort keys %{$DB->{'insts'}}) {
		my $pmap = $DB->{'insts'}->{$inst}->{'pmap'};
		unless (defined $pmap) { next; }
		foreach my $conn (keys %{$pmap}) {
			my $net_name = $pmap->{$conn};
			#if( $net_name eq 'pass' ) {
			#	print("Debug connect_to for $net_name \n");
			#}
			if( defined $DB->{'nets'}->{$net_name} ) {
				$DB->{'nets'}->{$net_name}->{'connect_to'}->{$inst} = $conn;
			}
		}
	}
	return();
}


sub generate_mods {
	my ($DB) = @_; 

	$DB->{'mods'} = {};
	foreach my $inst (sort keys %{$DB->{'insts'}}) {
		my $m_name = $DB->{'insts'}->{$inst}->{'m_name'};
		if( exists $DB->{'mods'}->{$m_name} ) {
			next;
		}
		my $m_mod = genmod_by_name($DB, $inst);
		$DB->{'mods'}->{$m_name} = $m_mod;
	}
	return();
}

sub genmod_by_name {
	my ($DB, $inst) = @_; 

	my $m_name = $DB->{'insts'}->{$inst}->{'m_name'};
	my $m_mod = {};
	#my $m_mod = {'name' => $m_name};
	unless ( defined $DB->{'insts'}->{$inst}->{'pmap'} ) {
		return($m_mod);
	}
	foreach my $port (keys %{$DB->{'insts'}->{$inst}->{'pmap'}}) {
		$m_mod->{'pmap'}->{$port} = "IO";
	}
	return($m_mod);
}


sub ba_find_locinst {
	my ($DB, $loc_XY) = @_; # loc_XY = "SLICE_X1Y1"

	my $result = [];
	foreach my $inst (sort keys %{$DB->{'insts'}}) {
		if( defined $DB->{'insts'}->{$inst}->{'gmap'}->{'LOC'} ) {
			if($DB->{'insts'}->{$inst}->{'gmap'}->{'LOC'} eq $loc_XY) {
				$result = [ (@{$DB->{'insts'}->{$inst}->{'data'}}, "\n", @{$result}) ];
			}
		}
	}
	return($result);

}

sub ba_find_inst {
	my ($DB, $inst_pattern) = @_;

	my $result = [];
	foreach my $inst (sort keys %{$DB->{'insts'}}) {
	
		if( defined $DB->{'insts'}->{$inst}->{'aka'} ) {
			if($DB->{'insts'}->{$inst}->{'aka'} =~ /$inst_pattern/) {
					$result = [ (@{$DB->{'insts'}->{$inst}->{'data'}}, "\n", @{$result}) ];
			}
		}
	}
	return($result);
}

sub read_ba {
	my ($ba_vhd, $DB) = @_;

	#
	my $bgn = `grep -n "^begin" $ba_vhd`; 
	my $end = `grep -n "^end STRUCTURE" $ba_vhd`; 
	# use "^ );" as seperator for each instance
	my @modules = `grep -n ");" $ba_vhd`; 
	chomp(@modules);
	# grep the line number only and remove texts
	chomp($bgn);
	chomp($end);
	$bgn =~ s/:.+$//;
	$end =~ s/:.+$//;
	@modules = map { /^(\d+):.+$/ ? $1 : $_ } @modules;
	# remove line which is not in the range between [$bgn,$end]
	@modules = grep { $_ > $bgn } @modules;
	@modules = grep { $_ < $end } @modules;
	# add $bgn+1 as first element begin:
	#@modules = ($bgn+1, @modules);
	#
	# line number and data array has 1 diff array[0..n-1]
	my @data = `cat $ba_vhd`;
	chomp(@data);


	my $r_insts = read_ba_insts(\@data, \@modules, $bgn, $end);
	$DB->{'insts'} = $r_insts;

	my $r_nets = read_ba_nets(\@data, $bgn);
	$DB->{'nets'} = $r_nets;

	return(1);
}

sub read_ba_nets {
	my ($data_p, $bgn) = @_;

	my @data = @$data_p;
	my $NETS = {};

	my $netp;
	my $typep;
	my $akap;
	my $m_net;
	# signal harness_capture_i_prop_counter : STD_LOGIC_VECTOR ( 6 downto 0 ); -- AKA:harness/capture_i/prop_counter
	foreach my $line (@data[0 .. $bgn]) {
		$m_net = {};
		#$m_net = { 'connect_to' => {} };
		undef $netp;
		undef $typep;
		undef $akap;
		if ( $line =~ /^\s+(signal.+):(.+)--(.+)$/ ) {
			$netp = $1;
			$typep = $2;
			$akap = $3;
		} elsif ( $line =~ /^\s+(signal.+):(.+)$/ ) {
			$netp = $1;
			$typep = $2;
		} else {
			next;
		}

		if(defined $netp) { 
			$netp =~ s/^\s+|\s+$//g;
			$m_net->{'name'} = parse_netp($netp);
		}
		if(defined $typep) {
			$typep =~ s/^\s+|\s+$//g;
			$m_net->{'type'} = parse_typep($typep);
 		}
		if(defined $akap) {
			$akap =~ s/^\s+|\s+$//g;
			$m_net->{'aka'} = parse_akap($akap);
 		}

		#$NETS->{$m_net->{'name'}} = $m_net;
		process_net_dim($NETS, $m_net);

	}
	return($NETS);
}

sub process_net_dim {
	my ($NETS, $m_net) = @_;

	my $name = $m_net->{'name'};
	unless ( defined $m_net->{'type'}->{'array_dim'} ) {
		print("This net has no dimension - $name \n");
	}
	if($m_net->{'type'}->{'array_dim'} == 0) {
		$m_net->{'connect_to'} = {};
		$NETS->{$name} = $m_net;
	} elsif($m_net->{'type'}->{'array_dim'} == 1) {
		#delete $m_net->{'connect_to'};
		foreach my $elem (@{$m_net->{'type'}->{'array'}}) {
			if( defined $elem ) {
				my $new_name = $name . $elem;
				my %new_net = %{$m_net};
				$NETS->{$new_name} = \%new_net;
				$NETS->{$new_name}->{'connect_to'} = {};
			}
		}
	} elsif($m_net->{'type'}->{'array_dim'} == 2) {
		foreach my $elem_x (@{$m_net->{'type'}->{'array'}}) {
			unless ( defined $elem_x ) {
				next;
			}
			foreach my $elem_y (@{$elem_x}) {
				my $new_name = $name . $elem_y;
				my %new_net = %{$m_net};
				$NETS->{$new_name} = \%new_net;
				$NETS->{$new_name}->{'connect_to'} = {};
			}
		}
	}
	delete $m_net->{'type'}->{'array'};
	return;
}


sub parse_typep {
	my ($typep) = @_;

	my $type_name = '';
	#STD_LOGIC_VECTOR2 ( 49 downto 0 , 6 downto 0 );
	#STD_LOGIC_VECTOR ( 6 downto 0 );	
	my $array = [];
	my $array_dim = 0;
	my $dim;
	if ( $typep =~ /^STD_LOGIC_VECTOR2\s?\((.+)\)\s?;$/ ) {
		$array_dim = 2;
		$type_name = 'STD_LOGIC_VECTOR2';
		$dim = $1;
		$dim =~ s/^\s+|\s+$//g;
		if($dim =~ /^(\d+)\s+downto\s+(\d+)\s?,\s?(\d+)\s+downto\s+(\d+)$/) {
			my $x2 = $1;
			my $x1 = $2;
			my $y2 = $3;
			my $y1 = $4;
			for(my $x=$x2; $x>=$x1; $x--) {
				for(my $y=$y2; $y>= $y1; $y--) {
					$array->[$x]->[$y] = "(${x}, ${y})";
				}
			}
		}
	} elsif ( $typep =~ /^STD_LOGIC_VECTOR\s?\((.+)\)\s?;$/ ) {
		$array_dim = 1;
		$type_name = 'STD_LOGIC_VECTOR';
		$dim = $1;
		$dim =~ s/^\s+|\s+$//g;
		if($dim =~ /^(\d+)\s+downto\s+(\d+)$/) {
			my $x2 = $1;
			my $x1 = $2;
			for(my $x=$x2; $x>=$x1; $x--) {
				$array->[$x] = "(${x})";
			}
		}
	} elsif ($typep =~ /^STD_LOGIC\s?;$/ ) {
		$array_dim = 0;
		$type_name = 'STD_LOGIC';
	}

	my $m_type = {'name' => $type_name, 'array_dim' => $array_dim, 'array' => $array};
	return($m_type);


}

sub parse_akap {
	my ($akap) = @_;

	my $aka_name = '';
	if( $akap =~ /^AKA:\s?(.+)$/ ) {
		$aka_name = $1;
	} 
	return($aka_name);
}

sub parse_netp {
	my ($netp) = @_;

	my $net_name = '';
	if( $netp =~ /^signal\s+(.+)$/ ) {
		$net_name = $1;
	} 
	return($net_name);
}


sub read_ba_insts {
	my ($data_p, $modules_p, $bgn, $end) = @_;

	my @data = @$data_p;
	my @modules = @$modules_p;

	my $INSTS = {};

	my $m_bgn = $bgn;
	my $m_end = $end;
	foreach my $m_module (@modules) {
		$m_end = $m_module - 1;
		# process inst name and modules
		# harness_capture_i_checker_latch : X_SFF -- AKA:harness/capture_i/checker_latch
		my $line = $data[$m_bgn];
		unless ( $line =~ /^.+:.+--.+$/ ) {
			# line too long to include the AKA name
			$line = join(" ", @data[$m_bgn .. $m_bgn+1]);
			unless($line =~ /^.+:.+--.+$/) {
				$line = $data[$m_bgn];
			}
		}
		my @token = split(":", $line);
		my $i_name = $token[0];
		$i_name =~ s/^\s+|\s+$//g;
		#if( $i_name eq "NlwBlock_top_level_VCC" ) {
		#	print("Debug instance --- ");
		#}
		my $aka = $token[2];
		if( defined $aka ) {
			$aka =~ s/^\s+|\s+$//g;
		}
		my $mod = { 'i_name' => $i_name, 'aka' => $aka };
		my $tmp = $token[1];
		@token = split('--', $tmp);
		my $mod_name = $token[0];
		$mod_name =~ s/^\s+|\s+$//g;
		$mod->{'m_name'} = $mod_name;
		my $m_data = [@data[$m_bgn .. $m_end]];
		$mod->{'data'} = $m_data;
		my $gnrc_map = read_gnrc_map($m_data);
		$mod->{'gmap'} = $gnrc_map;
		my $port_map = read_port_map($m_data);
		$mod->{'pmap'} = $port_map;
		#
		$INSTS->{$i_name} = $mod;
		# re-set the beginning pointer
		$m_bgn = $m_module;
	}
	#
	return($INSTS);
}

sub read_port_map {
	my ($inst_data) = @_;

	my $pmap = {};
	my $index=0;
	my $bgn=99999;
	my $end=0;
	# loop thru this array and id the "port map" and ");"
	foreach my $line (@$inst_data) {
		if( $line =~ /port map/ ) {
			$bgn = $index;
		}
	  	if( $line =~ /\)\s?;/ ) {
			$end = $index;
		}
		$index++;
	}
	# first, turn off the line seperator
	my $string;
	if( $bgn == $end ) {
		$string = $inst_data->[$bgn];
		if( $string =~ /port map\s?\((.+)\)/ ) {
			my $line = $1;
			$line =~ s/^\s+|\s+$//g;
			my @tmp = split(/\s+/, $line);
			@tmp = map { /=>/ ? $_ : "\"$_\"" } @tmp;
			# move ',' outside of string
			@tmp = map { /^(.+),\"/ ? $1 . '",' : $_  } @tmp;
			$line = join(' ', @tmp);
			$line = '$pmap = {' .  $line . '}';
			eval $line ;
		}
	} else {
		for($index=$bgn+1; $index<$end; $index++) {
			$string = $inst_data->[$index];
			if($string =~ /^\s+(.+)\s+=>\s+(.+),$/) {
				$pmap->{$1} = $2;
			} elsif ($string =~ /^\s+(.+)\s+=>\s+(.+)\s?$/) {
				$pmap->{$1} = $2;
			}
		}
	}

	return($pmap);
}

sub read_gnrc_map {
	my ($inst_data) = @_;

	my $gmap = {};
	# first, turn off the line seperator
	{
		my $sep = $/;
		undef $/;
		my $string = join(' ', @$inst_data);
		if( $string =~ /generic map\((.+?)\)/ ) {
			my $line = $1;
			# split the content with ','
			my @tokens = split(',', $line);
			my $num = scalar(@tokens);
			foreach my $token (@tokens) {
				my @tmp = split("=>", $token);
				$tmp[0] =~ s/^\s+|\s+$//g;
				$tmp[1] =~ s/^\s+|\s+$//g;
				$tmp[1] =~ s/^\"|\"$//g;
				$tmp[1] =~ s/^\'|\'$//g;
				$gmap->{$tmp[0]} = $tmp[1];
			}
		}
		$/ = $sep;
	}
	return($gmap);
}


1;

