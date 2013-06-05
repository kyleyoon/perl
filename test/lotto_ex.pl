#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: lotto_ex.pl
#
#        USAGE: ./lotto_ex.pl  
#
#  DESCRIPTION: lotto one line
#
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
#      VERSION: 1.0
#      CREATED: 06/04/2013 15:28:22
#===============================================================================

use 5.016;
use warnings;
use utf8;
use List::Util qw(shuffle);

printf "%d ", int(rand(45) + 1) foreach(1..6); 
printf "%d %d %d %d %d %d\n",map { (1..45)[rand 45] } 1..45;
say "@{[(shuffle 1..45)[0..5]]}";

#perl -E 'printf "%d ", int(rand()*45 + 1),($i += 1)  while $i < 6;'
#perl -E 'printf "%d ", int(rand(45) + 1) foreach(1..6);' 
#perl -E 'printf "%d %d %d %d %d %d\n",map { (1..45)[rand 45] } 1..45'
#perl -MList::Util=shuffle -E 'printf "%d %d %d %d %d %d\n", shuffle 1..45'
#perl -MList::Util=shuffle -E 'say "@{[(shuffle 1..45)[0..5]]}"'
