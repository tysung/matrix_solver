#!/usr/bin/perl -w 
use strict; 
use warnings; 
use Data::Dumper;
use Bit::Manip qw(:all);
use Cwd;
use Fcntl;

#
# [Cout, O[4-1]] = driver_u(7..4)+driver_u(3..0)+driver_u(9)[Cin]
my $O1 = [];
my $O2 = [];
my $O3 = [];
my $O4 = [];
my $Cout = [];
my $RESULT = { 
   'name' => ['O1', 'O2', 'O3', 'O4', 'Cout'],
   'FF' => []
};
my $max = 2**9;
foreach my $driver_u (0 .. $max) {
	my $u_str = sprintf("%09b", $driver_u);
   my $C_str = substr($u_str, 0, 1); # Cin
   my $B_str = substr($u_str, 1, 4); # B4-B3-B2-B1
   my $A_str = substr($u_str, 5, 8); # A4-A3-A2-A1

   my $A = sprintf('%d', oct("0b$A_str"));
   my $B = sprintf('%d', oct("0b$B_str"));
   my $C = sprintf('%d', oct("0b$C_str"));

   my $sum = $A + $B + $C;

   my $sum_str = sprintf("%05b", $sum);
   $RESULT->{'FF'}->[0]->[$driver_u] = substr($sum_str, 4, 1);
   $RESULT->{'FF'}->[1]->[$driver_u] = substr($sum_str, 3, 1);
   $RESULT->{'FF'}->[2]->[$driver_u] = substr($sum_str, 2, 1);
   $RESULT->{'FF'}->[3]->[$driver_u] = substr($sum_str, 1, 1);
   $RESULT->{'FF'}->[4]->[$driver_u] = substr($sum_str, 0, 1);

}

foreach my $idx (0..4) {

   my $pin = $RESULT->{'name'}->[$idx];
   my $table = $RESULT->{'FF'}->[$idx];

   my $hex_str = '0X';
   for(my $j=3; $j<$max; $j+=4) {
      my @list = @$table[($j-3)..$j];
      my $str = join('', @list);
      $hex_str .= sprintf('%X', oct("0b$str"));
   }
   print("i=$idx, pin=$pin, FF=$hex_str \n");

}


exit(0);






