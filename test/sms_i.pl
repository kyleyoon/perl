#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: sms.pl
#
#        USAGE: ./sms.pl  
#
#  DESCRIPTION: sms monthly statistics
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Kyle Yoon (), kyoon@wemakeprice.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2013/10/04 09½Ã 41ºĞ 54ÃÊ
#     REVISION: ---
#===============================================================================

use 5.016;
use strict;
use utf8;
use warnings;
use autodie;

use Data::Dumper;
use LWP::UserAgent;
use URI::QueryParam;
use URI;
use URL::Encode qw(url_encode);
use HTML::TokeParser::Simple;
 
my $user = '';
my $pass = '';
 
## LWP::Protocol::https must be installed to use https with LWP
my $url  = 'https://www.n-forum.com';
my $path = '/Member/Loginok.asp';
my $uri  = URI->new($url);
$uri->path($path);

## there were some duplicated arguments during capturing authentication packet on Wireshark.
my $hash_ref = {
	checkbox => 'checkbox',
	loginid  => $user,
	loginpass=> $pass,
	path     => url_encode('/index.asp'),
};
 
my $ua = LWP::UserAgent->new(
    agent      => 'Mozilla/5.0', 
	cookie_jar => {},  ## keep cookie on the memory
	ssl_opts => { verify_hostname => 0 },  ## to ignore error of uplus's certificate error}}
);

my $res = $ua->post($uri, $hash_ref);

if ($res->is_success) {
	## trying to download xls file if the authentication is passed successfully
	my $html_uri    = URI->new($url);
	my $html_path	= '/Ajax/GetStatistics01.asp';
	my $html_params	= {
		syy		=>	2013, 
		smm		=>	"09", 
		eyy		=>	2013, 
		emm		=>	"09", 
		msgtype	=>	"", 
	};

	$html_uri->path($html_path);
	$html_uri->query_form_hash($html_params);
	my $html_res	= $ua->get($html_uri);
	my $data = $html_res->content;
	my @data_arr = split "<COL>", $data;
	
	say "SMS\t:\t$data_arr[2]";
	say "LMS\t:\t$data_arr[5]";
	say "MMS\t:\t$data_arr[8]";
}
else {
    die $res->status_line;
}
=cut
