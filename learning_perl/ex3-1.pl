#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: ex3-1.pl
#
#        USAGE: ./ex3-1.pl  
#
#  DESCRIPTION: learning perl example
#
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
#      VERSION: 1.0
#      CREATED: 06/05/2013 17:12:03
#===============================================================================

use 5.016;
use warnings;
use utf8;

print "Enter some lines, then press Ctrl-D:\n";
my @str_list = <STDIN>;

say "input string line will display that reverse\n", reverse @str_list;
