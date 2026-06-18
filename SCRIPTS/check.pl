#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Data::Dumper;
use Cwd;

my $QA_HOME = "/import/home/tsung/IFT_QA";
my $DB = {};
#
my $golden_dump = "${QA_HOME}/Golden/result_db.pm";
my $qa_golden = "${QA_HOME}/Golden";
my $qa_result = "${QA_HOME}/today/ift-internal/tests";
my $golden_number = read_golden($qa_golden, $DB);
my $result_number = read_result($qa_result, $DB);
#
#
open(OUTFILE, '>', $golden_dump) or die "Couldn't open file for writing $golden_dump - $!. \n";
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print OUTFILE Data::Dumper->Dump( [$DB], [qw(*DB)] );
close(OUTFILE) or die "Couldn't close the file $golden_dump \n";
#
#
my @files_array = ( keys %{$DB->{golden}}, keys %{$DB->{result}} ) ;
my %files_hash = map { $_ => 1 } @files_array; #uniquify the list
@files_array = keys %files_hash;
my $error_num = 0;
foreach my $file (@files_array) {
	# now check the file_size is reasonable compare to golden
	if( ! exists $DB->{golden}->{$file} ) { 
		my $bit_file = $DB->{result}->{$file};
		print "New Bit Stream files $bit_file ... \n";	
		$error_num++;
	} elsif( ! exists $DB->{result}->{$file} ) { 
		my $bit_file = $DB->{golden}->{$file};
		print "Missing Bit Stream files $bit_file ... \n";	
		$error_num++;
	} else {
		my $golden_size = $DB->{golden}->{$file};
		my $result_size = $DB->{result}->{$file};
		# consider notification if file size change by %5
		if( abs(($golden_size-$result_size)/$golden_size) > 0.05 ) {
			print "Bit Stream file size change: [${golden_size}, ${result_size}] ... \n";
			$error_num++;
		}
	}
}
if( $error_num == 0 ) {
	print "IFT_QA found no significant change ... \n";
}
#
#
exit(0);

sub read_golden {
	my ($golden, $DB) = @_;

	chdir($golden);
	$DB->{golden} = {};
	my @lines = `ls -ltr */*.bit | sort -k 9`;
	foreach my $line (@lines) {
		chomp($line);
		my @words = split(/\s+/, $line);
		if(scalar(@words) < 8) {
			next;
		}
		my $fsize = $words[4];
		my $fname = $words[8];

		$fname =~ /^(.*)-(.*)\/(.*)\.bit$/;
		my $test_name = $1;
		my $group_name = $3;
		
		$DB->{golden}->{"${test_name}--${group_name}"} = $fsize;
	}
	my $num = scalar(keys %{$DB->{golden}});
	return($num);
}

sub read_result {
	my ($result, $DB) = @_;

	chdir($result);
	$DB->{result} = {};
	my @lines = `ls -ltr */*.bit | sort -k 9`;
	foreach my $line (@lines) {
		chomp($line);
		my @words = split(/\s+/, $line);
		if(scalar(@words) < 8) {
			next;
		}
		my $fsize = $words[4];
		my $fname = $words[8];

		$fname =~ /^(.*)-(.*)\/(.*)\.bit$/;
		my $test_name = $1;
		my $group_name = $3;
		
		$DB->{result}->{"${test_name}--${group_name}"} = $fsize;
	}
	my $num = scalar(keys %{$DB->{result}});
	return($num);
}


1;

