#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: sms_file.pl
#
#        USAGE: ./sms_file.pl  
#
#  DESCRIPTION: sms data pase file
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Kyle Yoon (), kyoon@wemakeprice.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 10/08/13 10:34:47
#     REVISION: ---
#===============================================================================

use 5.0.16;
use utf8;
use warnings;
use autodie;
 
use Data::Dumper;
use LWP::Simple qw(getstore);
use LWP::UserAgent;
use URI::QueryParam;
use URI;
use URL::Encode qw(url_encode);
 
my $user = '';
my $pass = '';
 
## LWP::Protocol::https must be installed to use https with LWP
my $url = 'https://sms.uplus.co.kr';
my $path = '/ver2/jsp/login/login_check.jsp';
my $uri = URI->new($url);
$uri->path($path);
 
## there were some duplicated arguments during capturing authentication packet on Wireshark.
my $hash_ref = {
	checkbox => 'checkbox',
	logid 	 => $user,
	logId	 => $user,
	logid_c	 => $user,
	passwd	 => $pass,
	pw 		 => $pass,
	password => '', ## it was an empty on the captured packet.
	path	 => url_encode('/ver2/jsp/main/index.jsp'),
	x		 => 1, ## not sure what are the parameters of x, y
	y		 => 2,
};
 
my $ua = LWP::UserAgent->new(
	agent => 'Mozilla/5.0',
	cookie_jar => {}, ## keep cookie on the memory
	ssl_opts => { verify_hostname => 0 }, ## to ignore error of uplus's certificate error
);
 
my $res = $ua->post($uri, $hash_ref);

if ($res->is_success) {
## trying to download xls file if the authentication is passed successfully
	my $file = './test_20131008.xls';
	my $xls_path = '/ver2/jsp/include/downExcel.jsp';
	my $xls_params = {
		  mode    => 'SMSTotStat',
		  kind    => 'month',
		  msgtype => 'SMS',
		  sdate   => '',
		  edate   => '',
		  syear   => 2013,
		  eyear   => 2013,
		  smonth  => 10,
		  emonth  => 10,
		  subId   => '',
		  useflag => '',  
	};

	my $xls_uri = URI->new($url);
	$xls_uri->path($xls_path);
	$xls_uri->query_form_hash($xls_params);
	 
	my $http_ret = getstore($url, $file);
	die "http return code : [$http_ret]\nfrom : $xls_uri, $file\n"
	unless $http_ret =~ /^2\d\d/; ## 2xx Success
} else {
	die "http return code : [", $res->status_line, "]\nfrom : $uri\n";
}

