#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Cwd qw(getcwd);
use Data::Dumper;
use Env;
use File::Basename;
use Cwd qw(cwd getcwd);

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
}
#
# start run job from this dir.
# have to run PartGen: environemnt has to source ISE env
#
my $DEVICE_HOME = "/nas/home/tsung/CODE/torc-internal/devices/build";
#
#my $s_families = ["virtex7", "spartan7"];
my $s_families_build = {
    "aartix7" => 1,
    "artix7" => 0,
    "aspartan3a" => 1,
    "aspartan3adsp" => 1,
    "aspartan3" => 1,
    "aspartan3e" => 1,
    "aspartan6" => 1,
    "azynq" => 1,
    "kintex7" => 0,
    "kintex7l" => 0,
    "qartix7" => 1,
    "qkintex7" => 1,
    "qkintex7l" => 1,
    "qrvirtex4" => 1,
    "qspartan6" => 1,
    "qspartan6l" => 1,
    "qvirtex4" => 1,
    "qvirtex5" => 1,
    "qvirtex6" => 1,
    "qvirtex7" => 1,
    "qzynq" => 1,
    "spartan3a" => 0,
    "spartan3adsp" => 0,
    "spartan3" => 0,
    "spartan3e" => 0,
    "spartan6" => 0,
    "spartan6l" => 0,
    "virtex4" => 0,
    "virtex5" => 0,
    "virtex6" => 0,
    "virtex6l" => 0,
    "virtex7" => 0,
    "zynq" => 0
};

my $s_families = [$ARGV[0]];
my $ise_part = "LOG.ise";
#
my $cur_dir = getcwd();
chdir("${DEVICE_HOME}");

my $ise_db={};
my $pkg_list=[];
#
open(FILE, "xilinx_arch.pm") or die "Couldn't open file for reading xilinx_arch.pm - $!. \n";
my $sep = $/;
undef $/;
$ise_db = eval <FILE>;
close FILE;
$/ = $sep;
#
#foreach my $family (keys %$s_families) {
#  system("./run_1  $family > LOG.partgen");
#  $ise_db->{$family} = read_ise("LOG.partgen");
#}
if($ARGV[1] eq 'pkg') {
    @::PKG_LIST = gen_pkg_list($ise_db, $s_families);
    print join(" ", @::PKG_LIST);
} elsif($ARGV[1] eq 'dev') {
    my $dev_list = [keys %{$ise_db->{$ARGV[0]}}];
    print join(" ", @$dev_list);
}  elsif($ARGV[1] eq 'create_pkg') {
    my $dev_list = [keys %{$ise_db->{$ARGV[0]}}];
    if( $s_families_build->{$ARGV[0]} == 1 ) {
        my $txt = join(",", @$dev_list);
        $txt = "custom:" . $ARGV[0] . ":" . $txt;
        print $txt;
    } elsif( $s_families_build->{$ARGV[0]} == 0 ) {
        print $ARGV[0];
    }
}

#
#open(DUMPFILE, '>',"xilinx_arch.pm") or die "Couldn't open file for writing s7_dump - $!. \n";
#$Data::Dumper::Indent = 1;
#$Data::Dumper::Useqq = 1;
#print DUMPFILE Data::Dumper->Dump( [$ise_db], [qw(ise_db)] );
#close(DUMPFILE) or die "Couldn't close the file s7_dump \n";

chdir("${cur_dir}");
#print("Done");
exit(0);

sub gen_pkg_list {
    my ($db, $families) = @_;

    my $pkg_list = [];
    foreach my $family (keys %$db) {
        if (grep {$_ eq $family} @$families) {
            my $dev_hash = $db->{$family};
            foreach my $dev (keys %$dev_hash) {
                my $pkg_arr = $dev_hash->{$dev};
                my $pkg_new = [map { $_ = $dev . $_ } @$pkg_arr];
                $pkg_list = [@$pkg_list, @$pkg_new];
            }
        }
    }
    return(@$pkg_list);
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


