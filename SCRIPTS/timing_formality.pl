#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Data::Dumper;
use Cwd;

#
my $simprim_vhd = $ARGV[0];
#my $simprim_vhd = "./LIB/X_LUT5.vhd";

my $golden_number = read_vhdl($simprim_vhd);

exit(0);
#

sub read_vhdl {
	my ($simprim_vhd) = @_;

	#
	my $bgn = `grep -n "VITALTIMING" $simprim_vhd`;
	if ($bgn eq '') {
		$bgn = `grep -n "VITALBehavior" $simprim_vhd`;
		if($bgn eq '') {
			return;
		}
	}
	my @end_list = `grep -n "end process" $simprim_vhd`;
	my $end = 0;
	# grep the line number only and remove texts
	chomp($bgn);
	#chomp($end);
	$bgn =~ s/:.+$//;
	@end_list = map { /^(\d+):.+$/ ? $1 : $_ } @end_list;
	foreach my $i (reverse @end_list) {
		if($i > $bgn) {
			$end = $i;
		}
	}
	#$end =~ s/:.+$//;
   #
   # use sed command to change file
    my $command = "/usr/bin/sed -i '" . $bgn . "," . $end . "d' " . $simprim_vhd;
	my $ret = `$command`;

	return;
}

1;

