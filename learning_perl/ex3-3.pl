#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: ex3-3.pl
#
#        USAGE: ./ex3-3.pl  
#
#  DESCRIPTION: learning perl sample
#
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
#      VERSION: 1.0
#      CREATED: 06/09/2013 21:26:48
#===============================================================================

use 5.016;
use warnings;
use utf8;

print "Enter some lines, then press Ctrl-D:\n";
chomp(my @user_list = <STDIN>);

say "=" x 20;
say join "\n",sort(@user_list);
say "=" x 20;
say join ", ",sort(@user_list);
say "=" x 20;
