#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: ex2-4.pl
#
#        USAGE: ./ex2-4.pl  
#
#  DESCRIPTION: learning perl example 
#
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
#      VERSION: 1.0
#      CREATED: 06/03/2013 22:08:22
#===============================================================================

use 5.016;
use warnings;
use utf8;
use Encode;

my $first = 0;
my $second = "";

say encode('utf-8',"곱셉하고자 하는 두수를 하나씩 입력하시오");
say encode('utf-8',"첫번째 숫자:");
chomp($first = <STDIN>);
say encode('utf-8',"두번째 숫자:");
chomp($second = <STDIN>);

say encode('utf-8',"입력한 두수의 곱 : "), $first * $second;
