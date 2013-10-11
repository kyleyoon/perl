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
my $url  = 'https://sms.uplus.co.kr';
my $path = '/ver2/jsp/login/login_check.jsp';
my $uri  = URI->new($url);
$uri->path($path);

## there were some duplicated arguments during capturing authentication packet on Wireshark.
my $hash_ref = {
	checkbox => 'checkbox',
	logid_c  => $user,
	logid    => $user,
	logId    => $user,
	pw       => $pass,
	passwd   => $pass,
	password => '',		 ## it was an empty on the captured packet.
	path     => url_encode('/ver2/jsp/main/index.jsp'),
	x        => 1,		 ## not sure what are the parameters of x,  y
	y        => 2,
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
	my $html_path	= 'ver2/jsp/msgbox/SMSTotStat.jsp';
	my $html_params	= {
		kind		=>	'month', 
		syear		=>	2013, 
		smonth		=>	'09', 
		eyear		=>	2013, 
		emonth		=>	'09', 
		subId		=>	'', 
		sendType	=>	'', 
		x			=>	21, 
		y			=>	15, 
	};

	$html_uri->path($html_path);
	$html_uri->query_form_hash($html_params);

	my $html_res	= $ua->get($html_uri);
	my $p			= HTML::TokeParser::Simple->new(string => $html_res->content);
	my $is_table = 0;
	my $is_td = 0;
	my $arr_cnt = 0;
	my @data_arr;

	while (my $tag = $p->get_tag('div')) {
		my $class = $tag->get_attr('class');
		next unless defined($class) and $class eq 'bbsLstBasic sendTable';
		$is_table += 1;

#		open FD, ">", "test.html";
		while (my $token = $p->get_token) {
			$is_td += 1 	if $token->is_start_tag('td');
			$is_td -= 1 	if $token->is_end_tag('td');
			$is_table -= 1 	if $token->is_end_tag('table');
			if ($is_td == 1 && $is_table == 1 && !$token->is_start_tag()) {
				my $data = $token->as_is;
				$data =~ s/^<\/?strong>.*//s;
				$data =~ s/,//;

				unless ($data eq "" || $data =~ /\D/) {
					$data_arr[$arr_cnt] = int($data);
					last if $arr_cnt >= 10;
					$arr_cnt++;
				}
			}
		}
#		close FD;
	}
	print "SMS\t:\t$data_arr[5]\n";
	print "LMS\t:\t$data_arr[6]\n";
	print "MMS\t:\t$data_arr[7]\n";
}
else {
    die $res->status_line;
}

