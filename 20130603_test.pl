#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: 20130603_test.pl
#
#        USAGE: ./20130603_test.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 06/03/2013 12:47:31
#     REVISION: ---
#===============================================================================

use 5.016;
use warnings;
use utf8;

for ($_ = "bedrock"; s/(.)//;)
{
	print "One character is: $1\n";
	say $_;
}

