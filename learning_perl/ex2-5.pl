#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: ex2-5.pl
#
#        USAGE: ./ex2-5.pl  
#
#  DESCRIPTION: learning perl sample
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR:  (|Kyle Yoon|), |kk9150@hotmail.com|
#      VERSION: 1.0
#      CREATED: 06/04/2013 11:56:00
#===============================================================================

use 5.016;
use warnings;
use utf8;
use Encode;

my $string = "";
my $integer = 0;

say encode('utf-8',"출력문자열을 입력하세요");
chomp($string = <STDIN>);
say encode('utf-8',"출력문자열을 반복할 횟수를 입력하시오");
chomp($integer = <STDIN>);

say encode('utf-8',"출력결과");
say $string x $integer;
