#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Cwd qw(getcwd);
use Data::Dumper;
use Env;
use File::Basename;
use Cwd qw(cwd getcwd);
#use Excel::Writer::XLSX; 

BEGIN {

   $ENV{'IFT_XILINX_TOOLS'}="/export/tools/xilinx/14.7/ISE_DS";
   $ENV{'IFT_XILINX_LEGACY_TOOLS'}="/export/tools/xilinx/10.1/ISE_DS";
   $ENV{'PYTHON'}="/usr/bin/python3.7";
   $ENV{'BOOST_PATH'}="/opt/boost/boost-1.66.0";
   $ENV{'GIT_ASKPASS'}="${HOME}/.git-askpass";
   #$ENV{'BOOST_PATH'}="/usr/local/boost/boost-1.66.0";
   $ENV{'LM_LICENSE_FILE'}='1727@rcg-lic.ads.isi.edu:2100@rcg-lic.ads.isi.edu:3000@rcg-lic.ads.isi.edu:2700@rcg-lic.ads.isi.edu:5280@rcg-lic.ads.isi.edu';
   $ENV{'PATH'} = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin:" . $ENV{'PATH'};
   $ENV{'PERL5LIB'}="/nas/home/tsung/QA/lib/perl5";
   push @INC, '/nas/home/tsung/QA/lib/perl5';
   require Excel::Writer::XLSX;
}
#
# start run job from this dir.
# have to run PartGen: environemnt has to source ISE env
#
my $S7_HOME = "/nas/home/tsung/IFT_QA/PARTGEN_PKG/S7_CHECK";
#
#my $s_families = ["virtex7", "spartan7"];
my $s_families = ["virtex7", "qvirtex7", "kintex7", "kintex7l", "qkintex7", "qkintex7l", "artix7", "artix7l", "aartix7", "qartix7", "zynq", "qzynq", "azynq", "spartan7", "aspartan7"]; 
my $ise_part = "LOG.ise";
my $vivado_part = "Vivado_all";
my $QA_HOME = '';
#
chdir("${S7_HOME}");
## now, read in $test_list
my $vivado_db = {};
open(FILE, $vivado_part) or die "Couldn't open file for reading $vivado_part - $!. \n";
my $sep = $/;
undef $/;
$vivado_db = eval <FILE>;
close FILE;
$/ = $sep;

my $ise_db={};
foreach my $family (@$s_families) {
  system("./run_1 $family | tee LOG.partgen");
  $ise_db->{$family} = read_ise("LOG.partgen");
}
#
open(DUMPFILE, '>',"s7_dump") or die "Couldn't open file for writing s7_dump - $!. \n";
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print DUMPFILE Data::Dumper->Dump( [$ise_db], [qw(ise_db)] );
close(DUMPFILE) or die "Couldn't close the file s7_dump \n";
#
# foreach my $family (sort @$s_families) 
foreach my $family (()) {
  my $ise_parts = [ sort keys %{$ise_db->{$family}} ];
  my $viv_parts = [sort @{$vivado_db->{'DeviceListMapping'}->{$family}}];
  my $ret = compare_arr($ise_parts, $viv_parts);
  my $isect = $ret->[0]; 
  my $diff = $ret->[1]; 
  if(scalar(@$diff) == 0) {
    print("-- No difference for family=$family \n");
  } else {
    print("-- There is difference for family=$family \n");
    print("  ISE    - ");
    print join(", ", map { sprintf "%s", $_ } sort @$ise_parts), "\n";
    print("  Vivado - ");
    print join(", ", map { sprintf "%s", $_ } sort @$viv_parts), "\n";
  }
  print("\n");
}
#
my $DB = {'Vivado' => {}, 'ISE' => {}};
foreach my $family (sort @$s_families) {
  $DB->{'Vivado'}->{$family} = [];
  $DB->{'ISE'}->{$family} = [];
  foreach my $viv_part (sort keys %{$vivado_db->{'Families'}->{$family}}) {
    foreach my $viv_pkg ( sort @{$vivado_db->{'Families'}->{$family}->{$viv_part}->{'pkgs'}} ) {
      my $viv_partpkg = $viv_part . $viv_pkg; 
      $DB->{'Vivado'}->{$family} = [ @{$DB->{'Vivado'}->{$family}}, $viv_partpkg ];
    }
  }
  #  
  foreach my $ise_part (sort keys %{$ise_db->{$family}}) {
    foreach my $ise_pkg (sort @{$ise_db->{$family}->{$ise_part}} ) { 
      my $ise_partpkg = $ise_part . $ise_pkg; 
      $DB->{'ISE'}->{$family} = [ @{$DB->{'ISE'}->{$family}}, $ise_partpkg ];
    }
  }
  my $ret = compare_arr($DB->{'ISE'}->{$family}, $DB->{'Vivado'}->{$family});
  my $isect = $ret->[0]; 
  my $diff = $ret->[1]; 
  if(scalar(@$diff) == 0) {
    print("-- No difference for family=$family \n");
  } else {
    print("-- There is difference for family=$family \n");
    print("  ISE    - ");
    print join(", ", map { sprintf "%s", $_ } sort @{$DB->{'ISE'}->{$family}}), "\n";
    print("  Vivado - ");
    print join(", ", map { sprintf "%s", $_ } sort @{$DB->{'Vivado'}->{$family}}), "\n";
  }
  print("\n");
  #
  open(DUMPFILE, '>',"s7_partpkg") or die "Couldn't open file for writing s7_partpkg - $!. \n";
  $Data::Dumper::Indent = 1;
  $Data::Dumper::Useqq = 1;
  print DUMPFILE Data::Dumper->Dump( [$DB], [qw(DB)] );
  close(DUMPFILE) or die "Couldn't close the file s7_partpkg \n";
}
#
my $excel_file = "series7.xlsx";
write_all_excel($DB, $excel_file);

print("Done");
exit(0);


sub write_all_excel {
	my ($DB, $exel_file) = @_;	
	
	#my $pwd = getcwd();
	#chdir("$qa_golden_db");
	#my $db_file = "${qa_golden_db}/$f_all_db";
	#my $all_db = read_db($db_file); 

	# Create a new workbook and add a worksheet
	#my $xlsx_out = "${qa_golden_db}/$today_exel";
	my $workbook  = Excel::Writer::XLSX->new($exel_file);
	my $worksheet = $workbook->add_worksheet('Series7 Families ');
	my $fmt_wb = excel_wb_format($workbook);
	write_excel_sheet($workbook, $worksheet, $fmt_wb, $DB);
	#
	$workbook->close();

	#chdir("$pwd");
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
	$fmt_wb->{'format_blue'} = $workbook->add_format(
	    color => 'blue',
	    size  => 16,
	    align => 'center'
	);
	return($fmt_wb);
}

sub write_excel_sheet {
	my ($workbook, $worksheet, $fmt_wb, $DB) = @_;

	# Expand the first columns so that the date is visible.
	$worksheet->set_column( "A:A", 30 );
	$worksheet->set_column( "B:K", 20 );
	
	
	# Write the column headers
	$worksheet->write( 'A1', 'Device_Family', $fmt_wb->{'bold'} );
	my $hd = 'A';
	my $col = 1;
	my $cell_name = '';
   my @X_vendor = ("Vivado", "ISE");
	foreach my $vendor ( @X_vendor ) {
		$hd++;
		$cell_name = $hd . "$col";
		$worksheet->write( $cell_name, $vendor, $fmt_wb->{'header'} );
	}
	
   foreach my $family (sort keys %{$DB->{'Vivado'}}) {
      # create ise_partpkgs hash to be used for checking.
      my $ise_partpkgs = $DB->{'ISE'}->{$family}; 
      my %hash = map { $_ => 1 } @$ise_partpkgs;
      my $f_init = 0;
      foreach my $viv_partpkg ( sort @{$DB->{'Vivado'}->{$family}} ) {
         #
         $col++;
         $hd = 'A';
         if ($f_init == 0) {
            $cell_name = $hd . "$col";
            $worksheet->write($cell_name, $family, $fmt_wb->{'format_blue'});
            $f_init = 1;
         }
         #
         $hd++;
         $cell_name = $hd . "$col";
         # now, check if ISE have the same part
         $worksheet->write( $cell_name, $viv_partpkg, $fmt_wb->{'center'} );
         $hd++;
         $cell_name = $hd . "$col";
         if (defined $hash{$viv_partpkg}) {
		     $worksheet->write( $cell_name, $viv_partpkg, $fmt_wb->{'center'} );
         } else {
		     $worksheet->write( $cell_name, 'N.A.', $fmt_wb->{'formet_red'} );
         } 
      }
   }

}




sub compare_arr {
  my ($ise_parts, $viv_parts) = @_;

  my @isect;
  my @diff;
  my @union;

  @isect = @diff = @union = ();
  my %count;

  foreach my $e (@$ise_parts, @$viv_parts) { $count{$e}++ }

  foreach my $e (keys %count) {
    push(@union, $e);
    push @{ $count{$e} == 2 ? \@isect : \@diff }, $e;
  }

  return([[@isect], [@diff]]);
}


sub read_ise {
	my ($log_partgen) = @_;

  my $DB={};
  #
  open my $handle, '<', $log_partgen;
  my @lines = <$handle>;
  chomp(@lines);
  close $handle;

  my @modules1 = `grep -n "SPEEDS:" $log_partgen`; 
  chomp(@modules1);
  if( $#modules1 == -1 ) {
    return($DB);
  }
  # grep the line number only and remove texts
  my @modules = map { /^(\d+):.+$/ ? $1 : $_ } @modules1;
  #
  # remove line which is not in the range between [$bgn,$end]
  #
  my $bgn = 0;
  my $end = 0;
  my @segs = ();
  my @token = ();
  my $part;
  for(my $i=1; $i <= $#modules; $i++) {
      $bgn = $modules[$i-1] - 1;
      @token = split(/\s+/, $lines[$bgn]);
      $bgn++;
      $end = $modules[$i] - 2;
      @segs = @lines[$bgn...$end];
      @segs = map { local $_ = $_; s/^\s+|\s+$//g; $_ } @segs;
      $part = $token[0];
      $DB->{$part}=[@segs];
	}
   $bgn = $modules[$#modules] -1;
   @token = split(/\s+/, $lines[$bgn]);
   $bgn++;
   $end = $#lines;
   @segs = @lines[$bgn...$end];
   @segs = map { local $_ = $_; s/^\s+|\s+$//g; $_ } @segs;
   #@segs = map { $_ =~ s/^\s+|\s+$//g } @segs;
   $part = $token[0];
   $DB->{$part}=[@segs];

	return($DB);
}



1;


