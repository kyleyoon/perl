#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: ex2-2.pl
#
#        USAGE: ./ex2-2.pl  
#
#  DESCRIPTION: learning perl example
#
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
#      VERSION: 1.0
#      CREATED: 06/03/2013 21:51:02
#===============================================================================

use 5.016;
use warnings;
use utf8;
use Encode;

my $pie = 3.141592654;
my $radius = 0;

say encode('utf-8',"반지름을 입력하세요");
$radius = <STDIN>;
chomp $radius;

printf encode('utf-8',"원주는 %.1f 입니다.\n"), 2*$pie*$radius;
