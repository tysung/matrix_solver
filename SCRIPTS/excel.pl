#!/usr/bin/perl

use strict;
use warnings;
use Excel::Writer::XLSX;
use Cwd qw(cwd getcwd);


my $qa_golden_db = "/Users/tsung/QA/DB";
my $date = `date +"%m-%d-%Y"`;
chomp($date);
my $today_excel = "${date}_db.xlsx";
my $all_db = 'all_db.pm';
write_all_excel($qa_golden_db, $today_excel, $all_db);

exit(0);


sub write_all_excel {
	my ($qa_golden_db, $today_exel, $f_all_db) = @_;	
	
	my $pwd = getcwd();

	chdir("$qa_golden_db");

	my $db_file = "${qa_golden_db}/$f_all_db";
	my $all_db = read_db($db_file); 

	# Create a new workbook and add a worksheet
	my $xlsx_out = "${qa_golden_db}/$today_exel";
	my $workbook  = Excel::Writer::XLSX->new($xlsx_out);
	my $worksheet = $workbook->add_worksheet('All Tests');
	my $fmt_wb = excel_wb_format($workbook);
	write_excel_sheet($workbook, $worksheet, $fmt_wb, $all_db);
	#
	foreach my $Y_name (@{$all_db->{'Y_name'}}) {
	    $Y_name =~ /^(.*):(.*)$/;
	    my $family = $1;
	    my $type = $2;
		#
		chdir("${family}/${type}");
		$db_file = "./db.pm";
		my $type_db = read_db($db_file); 
		$worksheet = $workbook->add_worksheet("${family}_${type}");
		write_excel_sheet($workbook, $worksheet, $fmt_wb, $type_db);
		#
		chdir("../..");
	}
	
	$workbook->close();

	chdir("$pwd");
}

sub read_db {
	my ($db_file) = @_;	

	## now, read in $db
	my $db = {};
	open(FILE, "$db_file") or die "Couldn't open file for reading $db_file  - $!. \n";
	my $sep = $/;
	undef $/;
	eval <FILE>;
	close FILE;
	$/ = $sep;
	#
	# consolidate {X,Y} elements
	#
	my $X_list = $db->{'X_date'};
	my %hash = map { $_ => 1 } @$X_list;
	$db->{'X_date'} = [sort(keys %hash)];
	#
	my $Y_list = $db->{'Y_name'};
	%hash = map { $_ => 1 } @$Y_list;
	$db->{'Y_name'} = [sort(keys %hash)];
	
	#
	return($db);
}

sub excel_wb_format {
	my ($workbook) = @_;

	my $fmt_wb = {};
	$fmt_wb->{'bold'} = $workbook->add_format( bold => 1, size => 16 );
	$fmt_wb->{'size'} = $workbook->add_format( size => 16 );
	$fmt_wb->{'center'} = $workbook->add_format( align => 'center', size => 16 );
	my $header      = $workbook->add_format( bold => 1, size => 16, align => 'center' );
	# Light red fill with dark red text.
	$fmt_wb->{'format_red'} = $workbook->add_format(
	    #bg_color => '#FFC7CE',
	    #color    => '#9C0006',
	    bold  => 1,
	    color => 'red',
	    size  => 16,
	    #merge => 1,
	    align => 'center'
	);
	return($fmt_wb);
}

sub write_excel_sheet {
	my ($workbook, $worksheet, $fmt_wb, $db) = @_;

	# Expand the first columns so that the date is visible.
	$worksheet->set_column( "A:A", 30 );
	$worksheet->set_column( "B:K", 20 );
	
	
	# Write the column headers
	$worksheet->write( 'A1', 'Device_Test', $fmt_wb->{'bold'} );
	my $hd = 'A';
	my $col = 1;
	my $cell_name = '';
	foreach my $X_date (@{$db->{'X_date'}}) {
		$hd++;
		$cell_name = $hd . "$col";
		$worksheet->write( $cell_name, $X_date, $fmt_wb->{'header'} );
	}
	
	foreach my $Y_name (@{$db->{'Y_name'}}) {
		$col++;
		$hd = 'A';
		$cell_name = $hd . "$col";
		$worksheet->write($cell_name, $Y_name, $fmt_wb->{'size'});
		foreach my $X_date (@{$db->{'X_date'}}) {
			$hd++;
			$cell_name = $hd . "$col";
			my $result = $db->{'Cells'}->{$X_date}->{$Y_name};
			if ($result ne 'Pass') {
				my $sheet = $Y_name;
				my $range = "$hd" . "2";
				$sheet =~ s/\:/_/; 
				$worksheet->write_url($cell_name, "internal:${sheet}!${range}", $fmt_wb->{'format_red'}, $db->{'Cells'}->{$X_date}->{$Y_name});
			} else {
				$worksheet->write($cell_name, $db->{'Cells'}->{$X_date}->{$Y_name}, $fmt_wb->{'center'});
			}
		}
	}
	
}

1;

