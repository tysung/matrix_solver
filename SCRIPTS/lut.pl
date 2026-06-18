#!/usr/bin/perl -w 
use strict; 
use warnings; 
use Data::Dumper;
use Bit::Manip qw(:all);
use Cwd;
use Fcntl;

#my $INIT = "F00F 0FF0";
my $INIT = "FFFF F00F 0FF0 0000";
my $vars = ['A1', 'A2', 'A3', 'A4', 'A5', 'A6'];
my $map = {
	'A1' => 'B6',
	'A2' => 'B1',
	'A3' => 'B2',
	'A4' => 'B3',
	'A5' => 'B4',
	'A6' => 'B5'
};
#
# build $DB->{'cells'}->{'011'}->{110} = 1;
# F(y=[A6=0,A5=1,A4=1],x=[A3=1,A2=1,A1=0])=1
my $DB = {
	'Y' => 8, 
	'X' => 8, 
	'INIT' => $INIT,
	'y_index' => ['A6', 'A5', 'A4'],
	'x_index' => ['A3', 'A2', 'A1'],
	'cells' => [] 
};
#
# build maxterm for each table entry
$INIT =~ s/\s//g;
my $binary_arr = [];
foreach my $char (split('', $INIT)) {
	my $num = hex($char);
	my $bit_str = sprintf("%04b", $num);
	my @arr = split('', $bit_str);
	unshift(@$binary_arr, @arr);
	#push(@$binary_arr, $bit_str);
}
#$DB->{'INIT'} = $binary_arr;
#
#my $Headers = [ map { "head_$_" } 0..15 ];
my $y_size = $DB->{'Y'} - 1;
my $x_size = $DB->{'X'} - 1;
foreach my $y (0 .. $y_size) {
	my $y_str = sprintf("%03b", $y);
	foreach my $x (0 .. $x_size) {
		my $x_str = sprintf("%03b", $x);
		# now, derive the F(y,x) value from 'INIT" 
		my $index = $y*8+$x;
		$DB->{'cells'}->[$y]->[$x] = $binary_arr->[$index];
		#$DB->{'cells'}->{$y_str}->{$x_str} = $binary_arr->[$index];
	}
};

my $new_lut = lut_trans($DB, $map);
$DB->{'trans'} = $new_lut;
#
open(OUTFILE, '>', "./lut.pm") or die "Couldn't open file for writing result_file - $!. \n";
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print OUTFILE Data::Dumper->Dump( [$DB], [qw(*DB)] );
close(OUTFILE) or die "Couldn't close the file result_file \n";
#
#
exit(0);

sub lut_trans {
	my ($DB, $map) = @_;

	my ($trans_arr, $y_index, $x_index) = trans_map($DB, $map);
	#
	my $y_size = $DB->{'Y'} - 1;
	my $x_size = $DB->{'X'} - 1;
	my $N_DB = {
		'Y' => $DB->{'Y'}, 
		'X' => $DB->{'X'}, 
		'y_index' => $y_index,
		'x_index' => $x_index 
	};
	my $cells = [];
	my $trans_str = '';
	foreach my $y (0 .. $y_size) {
		my $y_str = sprintf("%03b", $y);
		foreach my $x (0 .. $x_size) {
			my $x_str = sprintf("%03b", $x);
			my $yx_str = $y_str . $x_str;
			my $trans_str = trans_string($trans_arr, $yx_str);
			my $y1_str = substr($trans_str, 0, 3);
			my $x1_str = substr($trans_str, 3, 3);
			# my $new_y = sprintf('%X', oct("0b$y1_str"))
			my $new_y = oct("0b$y1_str");
			my $new_x = oct("0b$x1_str");
			$cells->[$new_y]->[$new_x] = $DB->{'cells'}->[$y]->[$x];
		}
	}
	$N_DB->{'cells'} = $cells;
	# re-calculate INIT value
	my $hex_arr = [];
	for(my $y=0; $y<=$y_size; $y++) {
		my $x_arry = $N_DB->{'cells'}->[$y];
		my $x_str = join('',($x_arry->[3],$x_arry->[2],$x_arry->[1],$x_arry->[0]));
		my $hex = sprintf('%X', oct("0b$x_str"));
		unshift(@$hex_arr, $hex);
		$x_str = join('',($x_arry->[7],$x_arry->[6],$x_arry->[5],$x_arry->[4]));
		$hex = sprintf('%X', oct("0b$x_str"));
		unshift(@$hex_arr, $hex);
		if( ($y % 2) == 1 ) {
			unshift(@$hex_arr, " ");
		}
	}
	my $first = shift(@$hex_arr);
	my $INIT = join('', @$hex_arr);
	$N_DB->{'INIT'} = $INIT;
	return($N_DB);
}


#my $map = {
#	'A1' => 'B6',
#	'A2' => 'B1',
#	'A3' => 'B2',
#	'A4' => 'B3',
#	'A5' => 'B4',
#	'A6' => 'B5'
#};
# A1 will map to index "0", A6 will map to index "5"
sub trans_map {
	my ($DB, $map) = @_;

	my $size = scalar(keys %{$map});
	my $arr = [];
	foreach my $src (keys %{$map}) {
		my $dest = $map->{$src};
		my $s_num = substr($src, 1, 1);
		my $d_num = substr($dest, 1, 1);
		$arr->[$s_num-1] = $d_num-1;
	}
	# build $y_index, $x_index
	my $y_index = [];
	foreach my $idx (@{$DB->{'y_index'}}) {
		my $n_idx = $map->{$idx};
		push(@$y_index, $n_idx);
	}
	my $x_index = [];
	foreach my $idx (@{$DB->{'x_index'}}) {
		my $n_idx = $map->{$idx};
		push(@$x_index, $n_idx);
	}
	return($arr, $y_index, $x_index);	
}

sub trans_string {
	my ($trans_arr, $yx_str) = @_;

	my $trans_str = $yx_str;
	my $size = length($yx_str);
	for(my $i=0; $i<$size; $i++) {
		my $trg = $trans_arr->[$i];
		substr($trans_str, $trg, 1) = substr($yx_str, $i, 1);	
	}
	return($trans_str);
}






