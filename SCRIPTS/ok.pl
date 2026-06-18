
#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Cwd qw(getcwd);
use Data::Dumper;
#use Email::MIME;
#use Email::Sender::Simple qw(sendmail);

# command line args used 
my $args; 
my $message;
my $DB = {};
my $QA_HOME = "/import/home/tsung/QA";
my $golden = "${QA_HOME}/Golden/Temporary/LastTest.log";
my $golden_dump = "${QA_HOME}/golden_db.pm";
my $qa_report = "${QA_HOME}/today/torc11/Build/Testing/Report.log";
my $exit_code;

BEGIN { 
   # make sure the number of command line arguments is correct 
   $args = scalar @ARGV; 
   if ($args != 0) { 
      print "Expected use $0 programName testFile\n"; 
      exit 0; 
   } 
} 


#open(OUTFILE, '>', $golden_dump) or die "Couldn't open file for writing $golden_dump - $!. \n";
read_golden($golden, $DB);
#$Data::Dumper::Indent = 1;
#$Data::Dumper::Useqq = 1;
#print OUTFILE Data::Dumper->Dump( [$DB], [qw(*DB)] );
#close(OUTFILE) or die "Couldn't close the file $golden_dump \n";

if(1==0) {
chdir($QA_HOME) or die "Couldn't change working dir to $QA_HOME - $!. \n";
system("rm -rf today");
system("mkdir today");
chdir("today");

$exit_code = system('git clone ssh://git@rcg.isi.edu/torc11.git');
if($exit_code != 0) {
	print "Git Clone failure .... \n";
	exit(1);
}
chdir("torc11");
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
	close(OUTFILE) or die "Couldn't close the file $qa_report . \n";
} else {
	system("echo \"QA passed\" > $qa_report");
}
print "Finish reading QA log \n";
#system("mail -s "qa test email" tsung@isi.edu");
#

# send the message
#sendmail($message);

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

