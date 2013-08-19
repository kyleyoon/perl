#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: mail_alter.pl
#
#        USAGE: ./mail_alter.pl  
#
#  DESCRIPTION: inline image mail send
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Kyle Yoon (), kyoon@wemakeprice.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2013/08/08 18시 01분 41초
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use MIME::Lite;

### Create the multipart "container":
my $msg = MIME::Lite->new(
    From    =>'system@wemakeprice.com',
    To      =>'kyoon@wemakeprice.com',
#    Cc      =>'some@other.com, some@more.com',
    Subject =>'시스템 일일보고',
    Type    =>'multipart/related'
);

$msg->attach(
    Type => 'text/html',
    Data => qq{
        <body>
            Here's <i>my</i> image:
            <img src="cid:myimage.png">
        </body>
    },
);
$msg->attach(
    Type => 'image/png',
    Id   => 'myimage.png',
    Path => '/Users/kyoon/images/XCDN.png'
);
$msg->send();
