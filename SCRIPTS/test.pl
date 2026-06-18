#!/usr/bin/perl -w 
 
# driver.pl 
# --------- 
# run a collection of tests on a specified program from a file of test data 
# 
# syntax is 
#    driver progname testfile 
# 
# to run the tests under "prove" use 
#    prove driver :: progname testfile 
# 
# the expected format of the test data file is as follows 
#    each test case is on a line of its own 
#    each test case consists of the following space delimited fields: 
#       the arguments to the program 
#       the comparison type to be used in the test 
#           ('is', 'isnt', 'ok', 'like', 'unlike',  
#            or a comparison operator, e.g. '==') 
#       the expected return value 
#       the expected output (cannot contain whitespace) 
#       the name of the test case 
# 
# e.g. testing "myquotient x y" which is supposed to divide x by y and  
#      print the result, or NaN, or invalid-arguments: 
#          12  4   is   0  3                  12/4=3 
#          3   0   is   1  NaN                3/0=NaN 
#          2   foo is   1  invalid-arguments  2/foo=invalid 
 
use strict; 
use warnings; 
use Switch; 
 
# command line args used 
my $args; 
my $progname; 
my $testfile; 
 
# array of test cases: 
#  each case is a list containing the function parameters, 
#     followed by the comparison type, one of: 
#       is, isnt, ok, like, unlike, or the operator for cmp_ok ('==' etc) 
#     followed by the exxpected return value, 
#     followed by the expected output, 
#     followed by the test name 
#  e.g. [ 3, 4, 'is', 12, 0, '3*4=12' ] 
my @productTestSet; 
my $numTests; 
 
# BEGIN blocks run the block as soon as compiled, we're using it here 
#    so that scalar @productTestSet will evaluate correctly 
#    in the use Test line 
BEGIN { 
 
   # make sure the number of command line arguments is correct 
   $args = scalar @ARGV; 
   if ($args != 2) { 
      print "Expected use $0 programName testFile\n"; 
      exit 0; 
   } 
 
   # get the name of the program to test and the file containing the test sets 
   $progname = $ARGV[0]; 
   $testfile = $ARGV[1]; 
 
   # =============================================================== 
   # read all the test cases from a file, storing in @productTestSet 
 
   # open the file or give up 
   open (my $fptr, "<", "$testfile") 
      or die "unable to open data file $testfile\n"; 
 
   # process the test cases one at a time 
   while (my $line = <$fptr>) { 
      # drop the newline 
      chomp $line; 
 
      # split the line into words (assumes space delimited), 
      #    creating an array for this one test case 
      my @tcase = split(/\s+/, $line); 
 
      # add the test case to the end of the array of test cases 
      push (@productTestSet, \@tcase); 
   } 
   close($fptr); 
   # =============================================================== 
 
   # compute the total number of test cases, 
   # (two tests per case since we test the return value separately) 
   $numTests = scalar @productTestSet; 
   $numTests = 2 * $numTests; 
 
} 
 
# now include the test module with the planned number of tests 
use Test::More tests => $numTests; 
print "$numTests tests\n"; 
 
# process each test case in turn 
foreach my $testCase (@productTestSet) { 
   # remove the name 
   my $testname = pop @$testCase; 
 
   # remove the expected output 
   my $exp = pop @$testCase; 
 
   # remove the expected return value 
   my $expret = pop @$testCase; 
 
   # remove the test type 
   my $ttype = pop @$testCase; 
 
   # run the function on the rest, capture the actual output 
   my $output = `$progname @$testCase`; 
 
   # capture the actual return value and adjust it to be user-friendly 
   my $return = $?; 
   if ($return == -1) { 
      print "Diagnostic: failed to execute\n"; 
   } elsif (($return & 128) > 0) { 
      $return = $return & 127; 
      print "Diagnostic: core dumped, status $return\n"; 
   } else { 
      $return = ($return >> 8); 
   } 
 
   # strip \n (if any) off the output 
   my $outp = chomp($output); 
 
   # determine which test type to run for the output and run that test 
   switch ($ttype) { 
      case "ok"     { ok($output, $testname); } 
      case "is"     { is($output, $exp, $testname); } 
      case "isnt"   { isnt($output, $exp, $testname); } 
      case "like"   { like($output, qr/$exp/, $testname); } 
      case "unlike" { unlike($output, qr/$exp/, $testname); } 
      else          { cmp_ok($output, $ttype, $exp, $testname); } 
   } 
 
   # run an is test on the return result 
   is($return, $expret, $testname); 
}

