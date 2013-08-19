#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: homework1-2.pl
#
#        USAGE: ./homework1-2.pl  
#
#  DESCRIPTION: the 1st homework assigned by john.
#
#       AUTHOR: Kyle Yoon (), kyoon@wemakeprice.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2013/06/21 15시 27분 24초
#===============================================================================

use strict;
use warnings;
use utf8;
use Lingua::Translate::Bing;

my $tr = Lingua::Translate::Bing->new(
	client_id => "kyle_perl_trans", 
	client_secret => "vbzrzSwabNINPlK7igEcgfBhBAsLd8ZnC/0dpurWWRE");

print $tr->trnaslate("안녕", "en");
