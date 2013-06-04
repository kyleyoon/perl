#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: ex1-3.pl
#
#        USAGE: ./ex1-3.pl  
#
#  DESCRIPTION: learning perl example
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
#      VERSION: 1.0
#      CREATED: 06/03/2013 21:40:19
#===============================================================================

use 5.016;
use warnings;
use utf8;

my @lines = `perldoc -u -f say`;
foreach (@lines) {
	s/\w<([^>]+)>/\U$1/g;
	/^=/?s/^=/-/g:s/^/\t/g;
	print;
}
