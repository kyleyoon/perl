#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: ex3-2.pl
#
#        USAGE: ./ex3-2.pl  
#
#  DESCRIPTION: learning perl example
#
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
#      VERSION: 1.0
#      CREATED: 06/05/2013 18:47:10
#===============================================================================

use 5.016;
use warnings;
use utf8;

print "Enter some number from 1 to 7, one per line, then press Ctrl-D:\n";
my @user_list = qw(fred betty barney dino wilma pebbles bamm-bamm);
chomp(my @array_index = <STDIN>);

print "@{[map{$user_list[$_ - 1]}@array_index]}\n";
print "$user_list[$_ - 1] " for (@array_index); 
