#!/usr/bin/perl -w 
 
use strict; 
use warnings; 
use Cwd qw(getcwd);
use Data::Dumper;
use Env;
use File::Basename;
use Cwd qw(cwd getcwd);
#use Excel::Writer::XLSX; 

# command line args used 
my $args; 
my $message;
my $QA_HOME = "/import/home/tsung/IFT_QA";
#
#my $fixed_dir = "/import/home/tsung/TEST/ift-internal/";
my $fixed_f2 = "ift.settings";
my $fixed_f1 = "environment";
#
my $batch_script = "all-slices-series7-script.py";
#
my $exit_code;
my $latest_commit='';
my $flag_updated=1;

my $date = `date +"%m-%d-%Y"`;
chomp($date);
my $qa_golden_db = "${QA_HOME}/Golden/DB";	
my $golden_dump = "${QA_HOME}/Golden/result_db.pm";
my $tests_dump = "${QA_HOME}/Golden/tests_db.pm";
my $qa_golden = "${QA_HOME}/Golden";
my $qa_result = "${QA_HOME}/today/cift-internal/RESULT";
my $build_script = "${QA_HOME}/today/cift-internal/SCRIPT";
my $qa_report = "${QA_HOME}/LastTest.log";
my $today_excel = "${qa_golden_db}/${date}_db.xlsx";

my $test_list = {
	"virtex2" => {
		"build-tests-virtex2-slices-script.py"    => {},
		"build-tests-virtex2-brams-script.py"     => {},
		"build-tests-virtex2-harness-script.py"   => {},
		"build-tests-virtex2-configmem-script.py" => {}
	},
	"virtex2p" => {
		"build-tests-virtex2p-slices-script.py"    => {},
		"build-tests-virtex2p-brams-script.py"     => {},
		"build-tests-virtex2p-harness-script.py"   => {},
		"build-tests-virtex2p-configmem-script.py" => {}
	},
	"virtex4" => {
		"build-tests-virtex4-slices-script.py" => {},
		"build-tests-virtex4-brams-script.py" => {},
		"build-tests-virtex4-harness-script.py" => {},
		"build-tests-virtex4-configmem-script.py" => {}
	},
	"series7" => {
		"build-tests-series7-slices-script.py" => {},
		"build-tests-series7-brams-script.py" => {},
		"build-tests-series7-harness-script.py" => {},
		"build-tests-series7-configmem-script.py" => {}
	}
};

BEGIN { 
	# make sure the number of command line arguments is correct 
	$args = scalar @ARGV; 
	if ($args != 0) { 
		print "Expected use $0 programName testFile\n"; 
		exit 0; 
	}

	#if( ! defined $ENV{'SSH_AUTH_SOCK'} ) {
	#	my $ssh_info = `ps -ux | grep ssh-agent | grep im-launch`;
	#	print("SSH is not setup - $ssh_info \n");
	#	my @words = split(/\s+/, $ssh_info);
	#	$ENV{'SSH_AUTH_SOCK'}='/run/user/5002/keyring/ssh';
	#	$ENV{'SSH_AGENT_PID'}=$words[2];
	#	#$ENV{'SSH_AGENT_PID'}='12368';
	#}
	#eval qx{bash -c "${QA_HOME}/ENV_DEFINE"};
	$ENV{'IFT_XILINX_TOOLS'}="/export/tools/xilinx/14.7/ISE_DS";
	$ENV{'IFT_XILINX_LEGACY_TOOLS'}="/export/tools/xilinx/10.1/ISE_DS";
	$ENV{'PYTHON'}="/usr/bin/python3.7";
	$ENV{'BOOST_PATH'}="/opt/boost/boost-1.66.0";
	$ENV{'GIT_ASKPASS'}="${HOME}/.git-askpass";
	#$ENV{'BOOST_PATH'}="/usr/local/boost/boost-1.66.0";
	$ENV{'LM_LICENSE_FILE'}='1727@dune0.ads.isi.edu:2100@dune0.ads.isi.edu:3000@dune0.ads.isi.edu:2700@dune0.ads.isi.edu:5280@dune0.ads.isi.edu';
	$ENV{'PATH'} = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin:" . $ENV{'PATH'};
	$ENV{'PERL5LIB'}="/import/home/tsung/QA/lib/perl5";
	push @INC, '/import/home/tsung/QA/lib/perl5';
	require Excel::Writer::XLSX; 

} 

if(1==0) {
	#if( -e "${QA_HOME}/today/cift-internal" ) 
	chdir("${QA_HOME}/today/cift-internal");
	$latest_commit = `echo "##"; git log -5 origin/master; echo "##\n\n"`;
	system("echo \"--- DEBUG --- \n $latest_commit \n\"");
	chomp($latest_commit);
	if( $latest_commit =~ "Already up to date" ) {
		#my $time = `date +"%m-%d-%Y"`;
		system("echo \"No Updated Code\" > $qa_report");
		#system("mail -s \"qa test [Skip] - $time \" tsung\@isi.edu < $qa_report");		
		#exit(0);
	}
}

chdir($QA_HOME) or die "Couldn't change working dir to $QA_HOME - $!. \n";

# COMMENT HERE
if(1==1) {
	system('rm -f /import/home/tsung/.local/share/ISI_IFT/config');
	system("rm -rf today");
	system("mkdir -p today");
	chdir("today");
	# simply to link to the torc11 repo

	$exit_code = system('git clone https://tsung@rcg2.isi.edu/torc/torc-internal.git');
	#$exit_code = system('git clone ssh://git@rcg.isi.edu/torc11.git');
	if ($exit_code != 0) {
		print "Git Clone failure .... \n";
		exit(1);
	}

	chdir("torc-internal");
	$exit_code = system('git pull');
	if ($exit_code != 0) {
		print "Git Pull failure .... \n";
		exit(1);
	}
	#
	chdir("..");
	#system("ln -s ../../QA/today/torc11 .");
	$exit_code = system('git clone https://tsung@rcg2.isi.edu/cift/cift-internal.git');
	#$exit_code = system('git clone ssh://git@rcg.isi.edu/ift-internal.git');

	if ($exit_code != 0) {
		print "Git Clone failure .... \n";
		exit(1);
	}
	chdir("cift-internal");
	#$exit_code = system('git checkout c26141617253b6c3fbe0b6a6dbf1f2c46af71367');
	$exit_code = system('git pull');
	if ($exit_code != 0) {
		print "Git Pull failure .... \n";
		exit(1);
	}
	#
	$latest_commit = `echo "##"; git log -5 origin/master; echo "##\n\n"`;
	system("echo \"--- DEBUG --- \n $latest_commit \n\"");
	chomp($latest_commit);
	#
	system("cp -f ${QA_HOME}/${fixed_f1}.QA ${fixed_f1}");
	system("cp -f ${QA_HOME}/${fixed_f2}.QA ${fixed_f2}");
	#
	system("ln -s ../torc-internal torc");
	#
	#exit(0);
	#
	# build Python Env
	#
	my $exit = system('./install.sh');
	if ($exit_code != 0) {
		print "install the python env failure .... \n";
		exit(1);
	}
	system('echo "QA Run Start Time "');
	system("date");
	#
	#
	#
	#

	chdir("${QA_HOME}/today/cift-internal");
	system("mkdir -p tests");
	#
	$test_list = gen_test_list();
	#
	#
	# system("python/bin/python application/ift.py --batch ${batch_script}");
	#
	# 1. collecting all the available build-tests.py file from repo
	# 2. modify to the "parallel_jobs=8 and set small region instead of full-chip
	#
	# Here run the all tests been built and store output files
	#
	system("rm -rf ${qa_result}");
	system("mkdir -p ${qa_result}");
	foreach my $family (keys %$test_list) {
		#unless ( $family eq 'virtex4' ) {
		#	next;
		#}
		print " [${family}] - Build Tests ..... \n";
		system("mkdir -p ${qa_result}/${family}");
		my $build_f = $test_list->{$family}->{'script'};
		print " [${family}/${build_f}] - Build This Test ..... \n";
		my $out_f = "${qa_result}/${family}/LOG";
		system("./ift --batch ${build_f} |& tee $out_f");
		$test_list->{$family}->{'out_f'} = $out_f;
		# check if no files were generated
		my $file_num = `dir -ag tests | wc -l`;
		if ($file_num > 3) {
			system("mv -f tests/* ${qa_result}/${family}");
		}	
		$file_num = `dir -ag temp | wc -l`;
		if ($file_num > 3) {
			system("mkdir -p ${qa_result}/${family}/temp");
			system("mv -f temp/* ${qa_result}/${family}/temp/");
		}
	}
	##
	result_move_type($test_list, $qa_result);
	#
	open(DUMPFILE, '>', $tests_dump) or die "Couldn't open file for writing $tests_dump - $!. \n";
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	print DUMPFILE Data::Dumper->Dump( [$test_list], [qw(test_list)] );
	close(DUMPFILE) or die "Couldn't close the file $tests_dump \n";

	system('echo "QA Run End Time "');
	system("date");

}

#chdir("${QA_HOME}/today/cift-internal");
## now, read in $test_list
#$test_list = {};
#open(FILE, $tests_dump) or die "Couldn't open file for reading $tests_dump - $!. \n";
#my $sep = $/;
#undef $/;
#eval <FILE>;
#close FILE;
#$/ = $sep;
##result_move_type($test_list, $qa_result);

#
# write the error message into $qa_report
#
#
open(OUTFILE, '>', $qa_report) or die "Couldn't open file for writing $qa_report - $!. \n";
#
#
my $RESULT = read_result($qa_result, $test_list);
#
#
open(DUMPFILE, '>', $golden_dump) or die "Couldn't open file for writing $golden_dump - $!. \n";
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print DUMPFILE Data::Dumper->Dump( [$RESULT], [qw(RESULT)] );
close(DUMPFILE) or die "Couldn't close the file $golden_dump \n";

if( defined $RESULT->{'pass'} ) {
	print OUTFILE "IFT_QA PASS ... \n";
}
print OUTFILE "\n\n${latest_commit}\n";
close(OUTFILE) or die "Couldn't close the file $qa_report \n";
print "Finish writing QA log \n";
my $time = `date +"%m-%d-%Y--%T"`;
system("mail -s \"CIFT test - $time \" tsung\@isi.edu  < $qa_report");
#
#
exit(0);


sub read_result {
	my ($result, $test_list) = @_;

	my $RESULT = {};
	my $error_total = 0;
	foreach my $family ( keys %$test_list ) {
		#unless ( $family eq 'virtex4' ) {
		#	next;
		#}
		my $error_family_total = 0;
		my $test_types = $test_list->{$family}->{'types'};
		foreach my $type (keys %$test_types) {

			my $DB = {};
			# first check if the "*.ift-tg" created - successful build
			# if( glob("*.ift-tg") ) - anyway, check for each file is needed!
			{
				# even, all the bitsteam files geneated, we need check file size
				my $path = dirname($test_list->{$family}->{'out_f'});
				$path = "${path}/${type}";
				# there are new test case which can fail in 1st time
				my $all_tests = $test_types->{$type}->{'tests'};
				read_type_result($path, $all_tests, $DB);
				read_type_golden($qa_golden, $type, $family, $DB);
				my $error_type_num = result_check_type($DB, $family, $type);
				$test_types->{$type}->{'pass_fail'} = $DB->{'check'}->{'pass_fail'};
				$error_family_total += $error_type_num;
				# 3 kinds of failures .bit files {'new', "none', 'neq'}
				#if( $error_type_num > 0 ) {
					$RESULT->{'family'}->{$family}->{'type'}->{$type} = {'check' => $DB->{'check'}, 'total' => $error_type_num };
					# now, loop thru the tests in this type and collect bit stream files
					#my $tests = $test_types->{$type}->{'tests'};
				#}
			}
		}
		$RESULT->{'family'}->{$family}->{'total'} = $error_family_total;
		$error_total += $error_family_total;
	}
	$RESULT->{'total'} = $error_total;
	if( $error_total <=  0 ) {
		$RESULT->{'pass'} = 1;
	}
	#
	all_db_update($test_list);
	#
	return($RESULT);
}


sub write_all_excel {
	my ($qa_golden_db, $f_all_db, $today_exel) = @_;	
	
	my $pwd = getcwd();

	chdir("$qa_golden_db");

	my $db_file = "${qa_golden_db}/$f_all_db";
	my $all_db = read_db($db_file); 

	# Create a new workbook and add a worksheet
	#my $xlsx_out = "${qa_golden_db}/$today_exel";
	my $workbook  = Excel::Writer::XLSX->new($today_exel);
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

	my $db = {
		'X_date' =>  [],
		'Y_name' => [],
		'Cells' => {} 
	};

	if( -e $db_file ) {
		## now, read in $db
		$db = {};
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
	}	
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
	$fmt_wb->{'format_blue'} = $workbook->add_format(
	    color => 'blue',
	    size  => 16,
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
	foreach my $X_date ( reverse(@{$db->{'X_date'}}) ) {
		$hd++;
		$cell_name = $hd . "$col";
		$worksheet->write( $cell_name, $X_date, $fmt_wb->{'header'} );
	}
	
	foreach my $Y_name (@{$db->{'Y_name'}}) {
		$col++;
		$hd = 'A';
		$cell_name = $hd . "$col";
		$worksheet->write($cell_name, $Y_name, $fmt_wb->{'size'});
		foreach my $X_date ( reverse(@{$db->{'X_date'}}) ) {
			$hd++;
			$cell_name = $hd . "$col";
			my $result = $db->{'Cells'}->{$X_date}->{$Y_name};
			if ( !defined $result ) {
				$worksheet->write($cell_name, 'N.A.', $fmt_wb->{'center'});
			} elsif	($result =~ 'Fail') {
				my $sheet = $Y_name;
				my $range = "$hd" . "2";
				$sheet =~ s/\:/_/; 
				$worksheet->write_url($cell_name, "internal:${sheet}!${range}", $fmt_wb->{'format_red'}, $db->{'Cells'}->{$X_date}->{$Y_name});
			} elsif ( $result =~ 'New:' ) {
				my $sheet = $Y_name;
				my $range = "$hd" . "2";
				$sheet =~ s/\:/_/; 
				$worksheet->write_url($cell_name, "internal:${sheet}!${range}", $fmt_wb->{'format_blue'}, $db->{'Cells'}->{$X_date}->{$Y_name});
			} elsif ( $result eq 'new' ) {
				$worksheet->write($cell_name, $db->{'Cells'}->{$X_date}->{$Y_name}, $fmt_wb->{'format_blue'});
			} elsif ( $result eq 'new_fl' ) {
				$worksheet->write($cell_name, $db->{'Cells'}->{$X_date}->{$Y_name}, $fmt_wb->{'format_red'});
			} elsif ( $result eq 'none' ) {
				$worksheet->write($cell_name, $db->{'Cells'}->{$X_date}->{$Y_name}, $fmt_wb->{'format_red'});
			} else {
				$worksheet->write($cell_name, $db->{'Cells'}->{$X_date}->{$Y_name}, $fmt_wb->{'center'});
			}
		}
	}
	
}





sub all_db_update {
	my ($test_list) = @_;

	#my $db_daily = "${QA_HOME}/Golden/DB/" . "all_db.pm";	
	#my $qa_golden_db = "${QA_HOME}/Golden/DB";	
	my $f_all_db = "all_db.pm";
	my $db_daily = "${qa_golden_db}/" . "$f_all_db";	

	my $db = {
		'X_date' =>  [],
		'Y_name' => [],
		'Cells' => {} 
	};

	if( -e $db_daily ) {
		$db = {};
		open(FILE, $db_daily) or die "Couldn't open file for reading $db_daily - $!. \n";
		my $sep = $/;
		undef $/;
		eval <FILE>;
		close FILE;
		$/ = $sep;
	}

	#my $date = "02-12-2012\n";
	#my $date = `date +"%m-%d-%Y"`;
	#chomp($date);
	my $X_list = [ (@{$db->{'X_date'}}, $date) ];
	my %hash = map { $_ => 1 } @$X_list; #uniquify the list
	$db->{'X_date'} = [ sort(keys %hash) ];
	my $num = scalar(@{$db->{'X_date'}});

	#
	# for Y: loop thru family and type - family:type
	#
	my $Y_list = [];
	foreach my $family (keys %$test_list) {
		my $test_types = $test_list->{$family}->{'types'};
		foreach my $type (keys %$test_types) {
			$Y_list = [@$Y_list, "${family}:${type}"];
		}
	}
	$Y_list = [ @{$db->{'Y_name'}}, @$Y_list ];
	%hash = map { $_ => 1 } @$Y_list; #uniquify the list
	$db->{'Y_name'} = [sort(keys %hash)];
	
	foreach my $Y_name (@{$db->{'Y_name'}}) {
		$Y_name =~ /^(.*):(.*)$/;
		my $family = $1;
		my $type = $2;
		my $result = $test_list->{$family}->{'types'}->{$type}->{'pass_fail'};
		my @out_str = ();
		# check if fail: number > 0
		if($result->[1] > 0) {
			#$db->{'Cells'}->{$date}->{$Y_name} = "Fail: $result->[1], Pass: $result->[0]";
			push (@out_str, "Fail: $result->[1]");
		} else {
			push (@out_str, "Pass: $result->[0]");
		}
		# check if new test 
		if($result->[2] > 0) {
			#$db->{'Cells'}->{$date}->{$Y_name} = "Pass";
			push (@out_str, "New: $result->[2]");
		}
		my $string = join ",", @out_str;
		$db->{'Cells'}->{$date}->{$Y_name} = $string;
	}

	db_trim_data($db);

	open(DUMPFILE, '>', $db_daily) or die "Couldn't open file for writing $db_daily - $!. \n";
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	print DUMPFILE Data::Dumper->Dump( [$db], [qw(db)] );
	close(DUMPFILE) or die "Couldn't close the file $db_daily \n";

	#
	# use this $db, write out .xlsx file
	#
	#my $date = `date +"%m-%d-%Y"`;
	#chomp($date);
	#my $today_excel = "${date}_db.xlsx#;
	#
	write_all_excel($qa_golden_db, $f_all_db, $today_excel);
	#

}


sub result_check_type {
	my ($DB, $family, $type) = @_;

	my @files_array = ( keys %{$DB->{golden}}, keys %{$DB->{result}} ) ;
	my %files_hash = map { $_ => 1 } @files_array; #uniquify the list
	@files_array = keys %files_hash;
	my $total_num = scalar(@files_array);
	my $error_num = 0;
	my $new_num = 0;
	$DB->{'check'}->{'all'} = [];
	foreach my $file (@files_array) {
		# now check the file_size is reasonable compare to golden
		my $bit_file = $file . '.bit';
		$DB->{'check'}->{'all'} = [ (@{$DB->{'check'}->{'all'}}, $bit_file)  ];
		if( ! exists $DB->{golden}->{$file} ) {
			print OUTFILE "New Bit Stream files {$family}.{$type}.$bit_file ... \n";
			if ( ! exists $DB->{'check'}->{'new'} ) {
				$DB->{'check'}->{'new'} = [];
			}
			$DB->{'check'}->{'new'} = [ @{$DB->{'check'}->{'new'}}, $bit_file  ];
			$new_num++;
		} elsif( ! exists $DB->{result}->{$file} ) {
			print OUTFILE "No Bit Stream files {$family}.{$type}.$bit_file was generated ... \n";
			if ( ! exists $DB->{'check'}->{'none'} ) {
				$DB->{'check'}->{'none'} = [];
			}
			$DB->{'check'}->{'none'} = [ @{$DB->{'check'}->{'none'}}, $bit_file  ];
			$error_num++;
		} else {
			my $golden_size = $DB->{golden}->{$file};
			my $result_size = $DB->{result}->{$file};
			# consider notification if file size change by %5
			if( abs(($golden_size-$result_size)/$golden_size) > 0.05 ) {
				print OUTFILE "Bit Stream file size change {$family}.{$type}.${bit_file}: [${golden_size}, ${result_size}] ... \n";
				if ( ! exists $DB->{'check'}->{'neq'} ) {
					$DB->{'check'}->{'neq'} = [];
				}
				$DB->{'check'}->{'neq'} = [ @{$DB->{'check'}->{'neq'}}, $bit_file  ];
				$error_num++;
			}
		}
	}
	# for new category 'new_fail', can't find any bit file both in "result"/"golden" bit stream files
	# $DB->{golden,result}=[ff1-0], $DB->[check}->{new,none,neq,new_fail,all}=[ff1-0.bit]
	if( exists $DB->{'no-bitgen'} ) {
		my $hash = $DB->{'no-bitgen'};
		foreach my $test (keys %$hash) {
			my $bit_file = $test . '-0';
			if( !exists $DB->{'result'}->{$bit_file} && !exists $DB->{'golden'}->{$bit_file} ) {
				if ( ! exists $DB->{'check'}->{'new_fail'} ) {
					$DB->{'check'}->{'new_fail'} = [];
				}
				$bit_file = $test . '-0.bit';
				$DB->{'check'}->{'new_fail'} = [ @{$DB->{'check'}->{'new_fail'}}, $bit_file  ];
				$DB->{'check'}->{'all'} = [ (@{$DB->{'check'}->{'all'}}, $bit_file)  ];
				$error_num++;


			}
		}
	}
	$DB->{'check'}->{'pass_fail'} = [$total_num-$error_num, $error_num, $new_num];
	#
	# read and write out {family}.{type}.test_result.pm daily result for 10 days
	# by merging today result in $DB
	test_db_update($DB, $family, $type);
	#
	return($error_num);
}


sub test_db_update {
	my ($DB, $family, $type) = @_;

	my $db_daily = "${QA_HOME}/Golden/DB/" . "$family" . "/${type}/db.pm";	
	my $path = dirname($db_daily);
	unless( -e $path ) {
		system("mkdir -p $path");
	}

	my $db = {
		'X_date' =>  [],
		'Y_name' => [],
		'Cells' => {} 
	};

	if( -e $db_daily ) {
		$db = {};
		open(FILE, $db_daily) or die "Couldn't open file for reading $db_daily - $!. \n";
		my $sep = $/;
		undef $/;
		eval <FILE>;
		close FILE;
		$/ = $sep;
	}

	#my $date = "02-12-2012\n";
	#my $date = `date +"%m-%d-%Y"`;
	#chomp($date);
	my $num = scalar(@{$db->{'X_date'}});
	$db->{'X_date'} = [ (@{$db->{'X_date'}}, $date) ];
	# uniquify the X_list
	my $X_list = $db->{'X_date'};
	my %hash = map { $_ => 1 } @$X_list; #uniquify the list
	$db->{'X_date'} = [ sort(keys %hash) ];
	#
	my $list = [ @{$db->{'Y_name'}}, @{$DB->{'check'}->{'all'}} ];
	%hash = map { $_ => 1 } @$list; #uniquify the list
	$db->{'Y_name'} = [sort(keys %hash)];
	
	foreach my $test (@{$DB->{'check'}->{'all'}}) {
		$db->{'Cells'}->{$date}->{$test} = 'pass';
	}

	foreach my $test (@{$DB->{'check'}->{'none'}}) {
		$db->{'Cells'}->{$date}->{$test} = 'none';
	}
	foreach my $test (@{$DB->{'check'}->{'neq'}}) {
		$db->{'Cells'}->{$date}->{$test} = 'neq';
	}
	foreach my $test (@{$DB->{'check'}->{'new'}}) {
		$db->{'Cells'}->{$date}->{$test} = 'new';
	}
	# new add in and start fail also
	foreach my $test (@{$DB->{'check'}->{'new_fail'}}) {
		$db->{'Cells'}->{$date}->{$test} = 'new_fl';
	}

	db_trim_data($db);

	open(DUMPFILE, '>', $db_daily) or die "Couldn't open file for writing $db_daily - $!. \n";
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	print DUMPFILE Data::Dumper->Dump( [$db], [qw(db)] );
	close(DUMPFILE) or die "Couldn't close the file $db_daily \n";

}


sub read_type_result {
	my ($result, $all_tests,  $DB) = @_;

	my $test_hash = { map { $_ => 0 } @$all_tests };
	my $current_dir = getcwd();
	chdir($result);
	$DB->{'result'} = {};
	my @lines = `/bin/ls -ltr */*.bit | sort -k 9`;
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
		
		$DB->{result}->{"${group_name}"} = $fsize;
		$test_hash->{$test_name} = 1; # mark this test successful
	}
	# now, loop thru case if any new case failure in run
	foreach my $test ( keys %$test_hash ) {
		if( $test_hash->{$test} == 0 ) {
			# give a negative number -1 for marking
			$DB->{'no-bitgen'}->{"$test"} = -1;
		}
	}	
	chdir($current_dir);
	#my $num = scalar(keys %{$DB->{result}});
	#return($num);
}

sub read_type_golden {
	my ($qa_golden, $type, $family, $DB) = @_;

	my $current_dir = getcwd();
	my $golden = "${qa_golden}/${family}/${type}";
	unless( -e ${golden} ) {
		system("mkdir -p $golden");
	}
	chdir($golden);
	$DB->{'golden'} = {};
	my @lines = `/bin/ls -ltr */*.bit | sort -k 9`;
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
		
		$DB->{golden}->{"${group_name}"} = $fsize;
	}
	chdir($current_dir);
	#my $num = scalar(keys %{$DB->{golden}});
	#return($num);
}


sub match_test_bitgen_old {
	my ($test_list) = @_;


	foreach my $family ( keys %$test_list ) {
		my $test_types = $test_list->{$family};
		foreach my $type (keys %$test_types) {
			unless ( $type eq 'configmem' or $type eq 'harness' ) {
				next;
			}
			# there are new test case which can fail in 1st time
			my $all_tests = $test_types->{$type}->{'tests'};
			if( $type eq 'configmem' ) {
				$all_tests = [map { s/-/_/g; $_ } @$all_tests];
			}
			if( $type eq 'configmem' or $type eq 'harness' ) {
				$all_tests = [map { $_ . "_test" } @$all_tests];
			}
			$test_types->{$type}->{'tests'} = $all_tests;
		}
	}
}


sub gen_test_list_old {

	$test_list = {};
	system("rm -rf $build_script");
	system("mkdir -p $build_script");
	my @build_files = glob "build-tests-*.py";
	foreach my $build_file (@build_files) {
		my @words = split("-", $build_file);

		if ($words[3] eq "interconnect") {
			next;
		}
		my $family = $words[2];
		my $type = $words[3];
		$test_list->{$family}->{$type} = { 'tests' => undef, 'part' => undef, 'out_f' => undef, 'script' => $build_file };
		#$test_list->{$family}->{$type} = $build_file;

		my @data = `cat $build_file`;
		#chomp(@data);
		my @new_data = map {/^parallel_jobs/ ? "parallel_jobs = 8\n" : $_} @data;
		unless ($words[3] eq "brams") {
			@new_data  = map {  /^region\s+=\s+None\s+#\s+(.+)/ ? "region = $1\n" : $_ } @new_data;
		}
		@new_data = map {/^(.+)test_mode=True\s?(.+)$/ ? "$1 $2\n" : $_} @new_data;
		@data = map {/^(.+)region=region(.+)$/ ? "$1 region=region, test_mode=True $2\n" : $_} @new_data;
		open(F, ">${build_script}/${build_file}") or die "Fail to open ${build_file} \n";
		print F @data;
		close(F);
		$test_list->{$family}->{$type}->{'script'} = "${build_script}/$build_file";
		#
		# process @new_data for "tg.add" with all the testcase for this category
		#
		my @tests = map {/^tg.add\s?\(\s?mytg\s?,\s?'(.+)',/ ? "$1" : ()} @new_data;
		$test_list->{$family}->{$type}->{'tests'} = [ @tests ];
		#
		# now, we want to know the part name
		#
		my @parts = map {/^part\s?=\s?'(.+)'/ ? "$1" : ()} @new_data;
		$test_list->{$family}->{$type}->{'part'} = $parts[0];
	}
	# in order to match "test" name with bitgen file name
	# some modification is needed.
	match_test_bitgen($test_list);
	##
	open(DUMPFILE, '>', $tests_dump) or die "Couldn't open file for writing $tests_dump - $!. \n";
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	print DUMPFILE Data::Dumper->Dump( [$test_list], [qw(test_list)] );
	close(DUMPFILE) or die "Couldn't close the file $tests_dump \n";
	#

	return($test_list);

}


sub parse_family_build_file {
	my ($build_file) = @_;

	my $db = {};
	open(FILE, $build_file) or die("Could not open $build_file file.");

	my @words = ();
	my $count = 0; 
	my $type = '';
	my $f_begin = 0;
	my $part = '';
	my $family = '';
	foreach my $line (<FILE>)  {   
		#print $line;    
		if( $line =~ /^\s?#(.*)/ ) {
			next;
		}
		if ($line =~ /^family\s?=\s?'(.+)'/) {
			$family = $1;
		}
		if ($line =~ /^part\s?=\s?'(.+)'/) {
			$part = $1;
		}
		if ($line =~ /tg.create/) {
			@words = split(/[\=\(\),\s]+/, $line);
			#$Y_name =~ /^(.*):(.*)$/;
			my $str_type = $words[2];
			$str_type =~ /^f'(.*)-\{.+\}'$/;
			$type = $1;
			$str_type = "${type}-${part}.ift-tg";
			if($type eq "all-brams") {
				$type = "brams";
			} elsif($type eq "all-slices") {
				$type = "slices";
			} elsif($type eq "configuration-memory") {
				$type = "configmem";
			}
			$db->{$type} = {'tests' => [], 'tg_name' => $str_type};
			$f_begin = 1;
		}

		if(($f_begin == 1) && ($line =~ /tg.add/)) {
			@words = split(/[\=\(\),\s]+/, $line);
			my $str_test = $words[2];
			$str_test =~ /^'(.*)'$/;
			my $test = $1;
			$db->{$type}->{'tests'} = [ @{$db->{$type}->{'tests'}}, $test ];
		}
		if(($f_begin == 1) && ($line =~ /tg.build/)) {
			$f_begin = 0;
			$type = '';
		}
		$count++;
		
	}
	close(FILE);

	return($db);
}


sub gen_test_list {

	$test_list = {};
	#system("rm -rf $build_script");
	#system("mkdir -p $build_script");
	my @build_files = glob "./test/nightly/build-scripts/build-tests-*.py";
	foreach my $build_file (@build_files) {
		my $family = '';
		my $type = '';
		#my $path = dirname($db_daily);
		my $base_f = basename($build_file);
		my @words = split(/[-\.]/, $base_f);
		$family = $words[2];
		my $db = parse_family_build_file($build_file);
		$test_list->{$family}->{'types'} = $db;
		$test_list->{$family}->{'script'} = $build_file;
		#$test_list->{$family}->{$type} = { 'tests' => undef, 'part' => undef, 'out_f' => undef, 'script' => $build_file };

	}
	# in order to match "test" name with bitgen file name
	# some modification is needed.
	match_test_bitgen($test_list);
	##
	open(DUMPFILE, '>', $tests_dump) or die "Couldn't open file for writing $tests_dump - $!. \n";
	$Data::Dumper::Indent = 1;
	$Data::Dumper::Useqq = 1;
	print DUMPFILE Data::Dumper->Dump( [$test_list], [qw(test_list)] );
	close(DUMPFILE) or die "Couldn't close the file $tests_dump \n";
	#

	return($test_list);

}

sub match_test_bitgen {
	my ($test_list) = @_;


	foreach my $family ( keys %$test_list ) {
		my $test_types = $test_list->{$family}->{'types'};
		foreach my $type (keys %$test_types) {
			unless ( $type eq 'configmem' or $type eq 'harness' ) {
				next;
			}
			# there are new test case which can fail in 1st time
			my $all_tests = $test_types->{$type}->{'tests'};
			if( $type eq 'configmem' ) {
				$all_tests = [map { s/-/_/g; $_ } @$all_tests];
			}
			if( $type eq 'configmem' or $type eq 'harness' ) {
				$all_tests = [map { $_ . "_test" } @$all_tests];
			}
			$test_types->{$type}->{'tests'} = $all_tests;
		}
	}
}


sub result_move_type {
	my ($test_list, $qa_result) = @_;

	# this function will be run in gen_test_list()
	#match_test_bitgen($test_list);

	my $pwd = getcwd();
	chdir("$qa_result");
	my $dirs_hash = {};
	foreach my $family (keys %$test_list) {
		chdir("$family");
		$dirs_hash = {};
		my @sub_dirs = grep {-d} glob("*");
		foreach my $dir (@sub_dirs) {
			if($dir =~ /^(.+)-[\S]{12}/) {
				my $t_name = $1;
				$dirs_hash->{$t_name} = $dir;
			}
		}
		my $types = $test_list->{$family}->{'types'};
		foreach my $type (keys %$types) {
			system("mkdir -p $type");
			# now find the test name for this type
			foreach my $test (@{$test_list->{$family}->{'types'}->{$type}->{'tests'}}) {
				my $t_dir = $dirs_hash->{$test};
				if( defined $t_dir && -e $t_dir ) {
					system("mv -f $t_dir $type/");
				}

			}
			my $tg_name = $test_list->{$family}->{'types'}->{$type}->{'tg_name'};
			if( -e $tg_name ) {
				system("mv -f $tg_name $type/");
			}
		}
		chdir("..");
	}
	chdir("$pwd");
}


sub db_trim_data {
	my ($db) = @_;


	my $num = scalar(@{$db->{'X_date'}});
	unless ( $num > 10 ) {
		return;
	}

	while ( $num > 10 ) {
		#
		my $first_elem = shift @{$db->{'X_date'}};
		#
		delete $db->{'Cells'}->{$first_elem};

		$num = scalar(@{$db->{'X_date'}});

	}

	return;
}


1;


