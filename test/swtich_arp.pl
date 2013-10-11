#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: swtich_arp.pl
#
#        USAGE: ./swtich_arp.pl  
#
#  DESCRIPTION: arp search
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
	open SW_FILE, ">>", "$dir/arp.csv";
	foreach(<SW_LOG>)
	{
		$export_en = 1 if ($_ =~ /All\ ARP/);
		$export_en = 0 if ($_ =~ /Total\ ARP/);
#		if ($export_en == 1 && $_ =~ /^[123456789]/)
		if ($export_en == 1 && $_ =~ /^\d/)
		{
			chomp;
			my @arp = split " ";
			print SW_FILE "$logfile, $arp[5], $arp[1], $arp[2]\n";
		}
	}
	close SW_LOG;
	close SW_FILE;
}

