#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: tranlation.pl
#
#        USAGE: ./tranlation.pl  
#
#  DESCRIPTION: 1st Homework
#
#       AUTHOR: Kyle Yoon (), kyoon@wemakeprice.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2013/06/20 19시 22분 35초
#===============================================================================

use strict;
use warnings;
use feature 'say';
use Data::Dumper;
use File::Basename;
use File::Spec;

our @content;
our $name;
our $path;
our $suffix;
our $new_filepath;

if( ! $ARGV[0]){
    say "Write filepath. for example, arrange-translate.pl /my/path/my/filename";
    exit;
}

open (MYFILE, $ARGV[0]);
@content = ();

our $index = 0;
while (<MYFILE>) {
    chomp;
    if($_ eq '' and $index == 0){
        $index++;
        next;
    }
    $index++;

    $_ =~ s/\<\/ /\<\//g;
    $_ =~ s/\< \/ /\<\//g;
    $_ =~ s/\[\/ /\[\//g;
    $_ =~ s/（/(/g;
    $_ =~ s/）/)/g;
    $_ =~ s/！/!/g;
    $_ =~ s/@ /@/g;
    $_ =~ s/＃/#/g;
    $_ =~ s/ \/ /\//g;
    $_ =~ s/ \+ /\+/g;
    $_ =~ s/ \= /\=/g;
    $_ =~ s/"/'/g;
    $_ =~ s/ '/' /g;
    $_ =~ s/ \^ \= /\^\=/g;
    $_ =~ s/ / /g;
    $_ =~ s/：/: /g;
    $_ =~ s/:  /: /g;
    $_ =~ s/ __/__/g;
    $_ =~ s/。/./g;
    $_ =~ s/ - /--/g;
    $_ =~ s/^\*/\* /g;
    $_ =~ s/】/\]/g;
    $_ =~ s/http :\/ \/ /http:\/\//g;
    $_ =~ s/`([a-zA-Z\-\_ \:\@]*)'/`$1`/g;
    $_ =~ s/'([a-zA-Z\-\_ \:\@]*)`/`$1`/g;

    # pre 안의 코드
    if( index($_, '    ') == 0 ||  index($_, '/\t/') == 0 ){
        $_ =~ s/、/, /g;
        $_ =~ s/。/./g;
        $_ =~ s/([a-z]) \[/$1\[/g;
    }

    push (@content, $_);
}
close (MYFILE);

# 새 파일 이름을 만들기 위해 
($name,$path,$suffix) = fileparse($ARGV[0], qr/\.[^.]*/);

$new_filepath = $path . $name . '-arranged' . $suffix;

say "Arranged file is ", $new_filepath;

open (FILE_TO_WRITE, '>' . $new_filepath);
for (@content) {
    say FILE_TO_WRITE $_;
}
close (FILE_TO_WRITE);
