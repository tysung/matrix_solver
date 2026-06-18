#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Data::Dumper;
use Cwd;
use HTML::Table;
use Fcntl;

my $QA_HOME = "/import/home/tsung/IFT_QA";
my $DB = [];
my $Headers = [ map { "head_$_" } 0..15 ];
foreach my $x (0..12) {
	foreach my $y (0..15) {
		$DB->[$x]->[$y] = "$x" . "-" . "$y";
	}
};

#
my $all_table = new HTML::Table(-rows=>26,
                          -cols=>13,
                          -align=>'center',
                          -rules=>'rows',
                          -border=>5,
                          -width=>'100%',
                          -spacing=>1,
                          -padding=>15,
                          -style=>'color: red',
                          -class=>'myclass',
                          -evenrowclass=>'even',
                          -oddrowclass=>'odd',
			  -head=>$Headers,
                          -data=> $DB );
$all_table->autoGrow(1);
$all_table->setRowBGColor(1, 'blue');
$all_table->setRowBGColor(3, '#FFFF99');

my $date_fmt = `date +"%m-%d-%Y"`;

print "content-type: text/html \n\n"; #The header
open(HTML, '>', './xx.html');
print HTML "content-type: text/html \n\n"; #The header
print HTML "<html>\n";
print HTML "<head>\n";
print HTML "<title> Dail Test Result - $date_fmt </title>";
print HTML "</head>\n";
print HTML "<body>\n";
# Here we print the table
print HTML $all_table;
#$all_table->print;
#
print HTML "</body>\n";
print HTML "</html>\n";
close(HTML);

#
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

