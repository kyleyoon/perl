#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: switch_mac.pl
#
#        USAGE: ./switch_mac.pl  
#
#  DESCRIPTION: mac search
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Kyle Yoon (), kyoon@wemakeprice.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2013/09/02 10½Ã 51ºÐ 09ÃÊ
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use File::Find;

my $dir = "/Users/kyoon/Desktop/log/network";
find({wanted => \&export_arp, no_chdir => 1}, "$dir");

sub export_arp {
	my $export_en = 0;
	my $logfile = $_;

	open SW_LOG, "<", $_;
	open SW_FILE, ">>", "$dir/mac.csv";
	foreach(<SW_LOG>)
	{
		$export_en = 1 if ($_ =~ /^MAC\-Address/);
		$export_en = 0 if ($_ =~ /\#/);
#		if ($export_en == 1 && $_ =~ /^[123456789]/)
		if ($export_en == 1 && $_ =~ /^\d/)
		{
			chomp;
			my @arp = split " ";
			$arp[0] =~ s/\.//g;
			$arp[0] = uc $arp[0];
			my @mac_add = ($arp[0] =~ /(\w{2})(\w{2})(\w{2})(\w{2})(\w{2})(\w{2})/);
			print SW_FILE join ",'", ($logfile, (join ":", @mac_add), "$arp[1]\n");
		}
	}
	close SW_LOG;
	close SW_FILE;
}

