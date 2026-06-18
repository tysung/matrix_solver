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
	# make sure the number of command line arguments is correct 
	$ENV{'IFT_XILINX_TOOLS'}="/export/tools/xilinx/14.7/ISE_DS";
	$ENV{'PERL5LIB'}="/import/home/tsung/QA/lib/perl5";
	push @INC, '/import/home/tsung/QA/lib/perl5';
	require Excel::Writer::XLSX; 

} 

my $in_xdl = "interconnect-0.xdl";

my $ret = read_xdl($in_xdl);

print("Done!");

#
#
exit(0);


sub read_xdl {
  my ($in_xdl) = @_;

  #open(FILE, $dep_gph) or die("Could not open $in_xdl file.");
  open my $handle, '<', $in_xdl;
  my @lines = <$handle>;
  chomp(@lines);
  close $handle;
  #
  # grep the line number only and remove texts
  #my @modules = map { /^(\d+):.+$/ ? $1 : $_ } @modules1;
  #
  for(my $i=0; $i<=$#lines; $i++)  {  
     my @token = ();
     if( $lines[$i] =~ /^inst.+SLICE_X/ ) {
        #$lines[$i] =~ /^inst "(.+)" "(.+)",.+$/;
        @token = split(/\s+/, $lines[$i]);
        if( $token[1] =~ /"SLICE_X(\d+)Y(\d+)"/ ) {
           my $x = $1;
           my $y = $2;
           if($x%2 == 1) {
              $token[2] = '"SLICEX",';
              my $tmp_line = join(' ', @token);
              $lines[$i] = $tmp_line;
           }
        }
     }
  }
  open(DUMPFILE, '>', "out.xdl") or die "Couldn't open file for writing output - $!. \n";
  print DUMPFILE join("\n", @lines);
  close(DUMPFILE) or die "Couldn't close the output file! \n";

  return(1);
}

1;


