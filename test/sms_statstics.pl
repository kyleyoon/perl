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
#      CREATED: 2013/10/04 09시 41분 54초
#     REVISION: ---
#===============================================================================

use 5.016;
use strict;
use warnings;
use autodie;

use POSIX qw(strftime mktime);
use Number::Format;
use Data::Dumper;
use LWP::UserAgent;
use URI::QueryParam;
use URI;
use URL::Encode qw(url_encode);
use HTML::TokeParser::Simple;
 
my ($second, $minute, $hour, $day, $cur_mon, $cur_year) = localtime();
my $last_date = mktime(0, 0, 0, 1, $cur_mon-1, $cur_year);
my ($year, $mon) = split ",", strftime('%Y,%m', localtime $last_date);
my (@SMS, @LMS, @MMS, @TOTAL);
my $user_LG = '';
my $pass_LG	= '';
my $user_HI = '';
my $pass_HI = '';

## LWP::Protocol::https must be installed to use https with LWP
my $url_LG  = 'https://sms.uplus.co.kr';
my $path_LG = '/ver2/jsp/login/login_check.jsp';
my $url_HI  = 'https://www.n-forum.com';
my $path_HI = '/Member/Loginok.asp';
my $html_path_LG	= 'ver2/jsp/msgbox/SMSTotStat.jsp';
my $html_path_HI	= '/Ajax/GetStatistics01.asp';

## there were some duplicated arguments during capturing authentication packet on Wireshark.
my $hash_ref_LG = {
	checkbox => 'checkbox',
	logid_c  => $user_LG,
	logid    => $user_LG,
	logId    => $user_LG,
	pw       => $pass_LG,
	passwd   => $pass_LG,
	password => '',		 ## it was an empty on the captured packet.
	path     => url_encode('/ver2/jsp/main/index.jsp'),
	x        => 1,		 ## not sure what are the parameters of x,  y
	y        => 2,
};

my $hash_ref_HI = {
	checkbox => 'checkbox',
	loginid  => $user_HI,
	loginpass=> $pass_HI,
	path     => url_encode('/index.asp'),
};
 
my $html_params_LG	= {
		kind		=>	'month', 
		syear		=>	$year, 
		smonth		=>	"$mon", 
		eyear		=>	$year, 
		emonth		=>	"$mon", 
		subId		=>	'', 
		sendType	=>	'', 
		x			=>	21, 
		y			=>	15, 
};

my $html_params_HI	= {
		syy		=>	$year, 
		smm		=>	"$mon", 
		eyy		=>	$year, 
		emm		=>	"$mon", 
		msgtype	=>	"", 
};


auth_site($url_LG, $path_LG, $hash_ref_LG, $html_path_LG, $html_params_LG, "LG");
auth_site($url_HI, $path_HI, $hash_ref_HI, $html_path_HI, $html_params_HI, "HI");
	
my $num = new Number::Format;
my $TOTAL = $SMS[0]+$SMS[1]+$LMS[0]+$LMS[1]+$MMS[0]+$MMS[1];
open HTML, ">", "sms.html";
print HTML "
	<HEAD><STYLE>
		table{
			border-collapse:	collapse;
			border: 			1px gray solid;
			table-layout:		fixed;
		}
		table td{
			border: 			1px gray solid;
			font-size: 			10px;
			text-align:			center;
		}
	</STYLE></HEAD>
	<body>
	<H2>$year년 $mon월 문자사용료</H2>
	<table width='400' height='100'>
		<tr>
			<td>구 분</td>
			<td>SMS</td>
			<td>LMS</td>
			<td>MMS</td>
			<td>합 계(원)</td>
		</tr>
		<tr>
			<td>LGU+</td>
			<td>".$num->format_number(int($SMS[0]))."</td>
			<td>".$num->format_number(int($LMS[0]))."</td>
			<td>".$num->format_number(int($MMS[0]))."</td>
			<td>".$num->format_number(int($SMS[0]+$LMS[0]+$MMS[0]))."</td>
		</tr>
		<tr>
			<td>아이하트</td>
			<td>".$num->format_number(int($SMS[1]))."</td>
			<td>".$num->format_number(int($LMS[1]))."</td>
			<td>".$num->format_number(int($MMS[1]))."</td>
			<td>".$num->format_number(int($SMS[1]+$LMS[1]+$MMS[1]))."</td>
		</tr>
		<tr>
			<td>합 계(원)</td>
			<td>".$num->format_number(int($SMS[0]+$SMS[1]))."</td>
			<td>".$num->format_number(int($LMS[0]+$LMS[1]))."</td>
			<td>".$num->format_number(int($MMS[0]+$MMS[1]))."</td>
			<td>".$num->format_number(int($TOTAL))."</td>
		</tr>
	</table>";
close HTML;

#== sub start ==
sub auth_site {
	my ($url, $path, $hash_ref, $html_path, $html_params, $key ) = @_;
	my $uri  = URI->new($url);
	$uri->path($path);
	my $ua = LWP::UserAgent->new(
		agent      => 'Mozilla/5.0', 
		cookie_jar => {},  ## keep cookie on the memory
		ssl_opts => { verify_hostname => 0 },  ## to ignore error of uplus's certificate error}}
	);
	 
	my $res = $ua->post($uri, $hash_ref);
	if ($res->is_success) {
		## trying to download xls file if the authentication is passed successfully
		my $html_uri    = URI->new($url);

		$html_uri->path($html_path);
		$html_uri->query_form_hash($html_params);

		my $html_res	= $ua->get($html_uri);
		my $data		= $html_res->content;
		my $p			= HTML::TokeParser::Simple->new(string => $data);
		my $is_table = 0;
		my $is_td = 0;
		my $arr_cnt = 0;
		my @data_arr;

		if ($key eq "LG") {
			while (my $tag = $p->get_tag('div')) {
				my $class = $tag->get_attr('class');
				next unless defined($class) and $class eq 'bbsLstBasic sendTable';
				$is_table += 1;

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
			}
			$SMS[0] = $data_arr[5]*9.5;
			$LMS[0] = $data_arr[6]*25;
			$MMS[0] = $data_arr[7]*0;
		} 
		else {
			@data_arr = split "<COL>", $data;
			$SMS[1] = $data_arr[2]*8.8;
			$LMS[1] = $data_arr[5]*24;
			$MMS[1] = $data_arr[8]*86;
		}
	}
	else {
		die $res->status_line;
	}
}
