#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Cwd qw(getcwd);
use Data::Dumper;
use Env;

# command line args used 
my $args; 
my $message;
my $DB = {};
my $QA_HOME = "/import/home/tsung/QA";
my $golden = "${QA_HOME}/Golden/Temporary/LastTest.log";
my $golden_dump = "${QA_HOME}/golden_db.pm";
my $qa_report = "${QA_HOME}/today/torc11/Build/Testing/Report.log";
my $exit_code;
my $latest_commit='';
my $flag_updated=1;

BEGIN { 
	# make sure the number of command line arguments is correct 
	$args = scalar @ARGV; 
	if ($args != 0) { 
		print "Expected use $0 programName testFile\n"; 
		exit 0; 
	}

	if( ! defined $ENV{'SSH_AUTH_SOCK'} ) {
		my $ssh_info = `ps -ux | grep ssh-agent | grep im-launch`;
		print("SSH is not setup - $ssh_info \n");
		my @words = split(/\s+/, $ssh_info);
		$ENV{'SSH_AUTH_SOCK'}='/run/user/5002/keyring/ssh';
		$ENV{'SSH_AGENT_PID'}=$words[2];
		#$ENV{'SSH_AGENT_PID'}='12368';
	}
	$ENV{'PATH'} = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin:" . $ENV{'PATH'};

} 

if( -e "${QA_HOME}/today/torc11" ) {
	chdir("${QA_HOME}/today/torc11");
	$latest_commit = `echo "##"; git pull; echo "##\n\n"; git log -n 2`;
	system("echo \"--- DEBUG --- \n $latest_commit \n\"");
	#chomp($latest_commit);
	if( $latest_commit =~ "Already up to date" ) {
		my $time = `date +"%m-%d-%Y"`;
		#system("echo \"No Updated Code\" > $qa_report");
		#system("mail -s \"qa test [Skip] - $time \" tsung\@isi.edu < $qa_report");		
		#exit(0);
	}
}


#open(OUTFILE, '>', $golden_dump) or die "Couldn't open file for writing $golden_dump - $!. \n";
read_golden($golden, $DB);
#$Data::Dumper::Indent = 1;
#$Data::Dumper::Useqq = 1;
#print OUTFILE Data::Dumper->Dump( [$DB], [qw(*DB)] );
#close(OUTFILE) or die "Couldn't close the file $golden_dump \n";

if(1==1) {
chdir($QA_HOME) or die "Couldn't change working dir to $QA_HOME - $!. \n";
system("rm -rf today/torc11");
system("mkdir today");
chdir("today");

$exit_code = system('git clone ssh://git@rcg.isi.edu/torc11.git');
if($exit_code != 0) {
	print "Git Clone failure .... \n";
	exit(1);
}
chdir("torc11");
$exit_code = system('git pull');
if($exit_code != 0) {
	print "Git Pull failure .... \n";
	exit(1);
}

system("mkdir Build");
chdir("Build");

$exit_code = system("cmake ..");
if($exit_code != 0) {
	print "Fail to generate makefile from cmake .... \n";
	exit(1);
}

$exit_code = system("make -j 4");
if($exit_code != 0) {
	print "Fail to compile in the makefile .... \n";
	exit(1);
}
#
system('echo "QA Run Start Time "');
system("date");
#
system("ln -s ../../torc11 torc");
system("make test");
#
system('echo "QA Run End Time "');
system("date");
}
#
# now read in QAresult to compare result from Golden
#
my $qa_result = "${QA_HOME}/today/torc11/Build/Testing/Temporary/LastTest.log";
my $fail_number = read_qarun($qa_result, $DB);
if( $fail_number > 0 ) {

	open(OUTFILE, '>', $qa_report) or die "Couldn't open file for writing $qa_report - $!. \n";
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	print OUTFILE "There are [ $fail_number ] failed cases: \n"; 
	print OUTFILE Data::Dumper->Dump( [$DB->{qarun}], [qw(*FAIL_CASE)] );
	print OUTFILE "\n\n${latest_commit}";
	close(OUTFILE) or die "Couldn't close the file $qa_report . \n";
} else {
	open(OUTFILE, '>', $qa_report) or die "Couldn't open file for writing $qa_report - $!. \n";
	print OUTFILE "TORC QA passed\n";
	print OUTFILE "\n\n${latest_commit}";
	close(OUTFILE) or die "Couldn't close the file $qa_report . \n";
}
print "Finish reading QA log \n";
my $time = `date +"%m-%d-%Y"`;
system("mail -s \"TORC qa test - $time \" tsung\@isi.edu < $qa_report");
#

exit(0);

sub read_golden {
	my ($golden, $DB) = @_;

	$DB->{golden} = {};
	my @lines = `grep \"has passed\" $golden`;
	foreach my $line (@lines) {
		chomp($line);
		$line =~ /^(.*?): info:(.*) has passed$/;
		my $file_line = $1;
		my $func_parm = $2;
		
		$file_line =~ s/^\s+|\s+$//g;		
		$func_parm =~ s/^\s+|\s+$//g;		

		$file_line =~ /^(.+)\((\d+)\)$/;
		my $file = $1;
		my $ln = $2;

		if( !exists $DB->{golden}->{$file} ) {
			$DB->{golden}->{$file} = {}
		}
		$DB->{golden}->{$file}->{$ln} = $func_parm;
	}
}

sub read_qarun {
	my ($qarun, $DB) = @_;

	$DB->{qarun} = undef;
	my @lines = `grep \"has failed\" $qarun`;
	foreach my $line (@lines) {
		if( !defined $DB->{qarun} ) {
			$DB->{qarun} = {};
		}
		chomp($line);
		$line =~ /^(.*?): error:(.*) has failed$/;
		my $file_line = $1;
		my $func_parm = $2;
		
		$file_line =~ s/^\s+|\s+$//g;		
		$func_parm =~ s/^\s+|\s+$//g;		

		$file_line =~ /^(.+)\((\d+)\)$/;
		my $file = $1;
		my $ln = $2;

		if( !exists $DB->{qarun}->{$file} ) {
			$DB->{qarun}->{$file} = {}
		}
		$DB->{qarun}->{$file}->{$ln} = $func_parm;
	}

	if( defined $DB->{qarun} ) {
		my $count = 0;
		foreach my $failc ( keys %{$DB->{qarun}} ) {
			my $x = scalar keys %{$DB->{qarun}->{$failc}};
			$count += $x;
		}
		return $count;
	} else {
		return 0;
	}
}



1;

