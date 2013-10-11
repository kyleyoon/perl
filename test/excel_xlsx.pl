#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: excel.pl
#
#        USAGE: ./excel.pl  
#
#  DESCRIPTION: xls parse
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Kyle Yoon (), kyoon@wemakeprice.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2013/09/05 09시 22분 08초
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Encode;
use Spreadsheet::XLSX;
use File::Find;
#use Text::Iconv;
 
my $value;
my @date_arr;
#my $converter = Text::Iconv -> new ("utf-8", "windows-1251");
my $dir = "/Users/kyoon/2013";
find({wanted => \&export_excel, no_chdir => 1}, "$dir");

sub export_excel {
	if ( $_ =~ /xlsx$/ ) 
	{
#		my $excel = Spreadsheet::XLSX->new($_,$converter);
		my $excel = Spreadsheet::XLSX->new($_);
		 
		foreach my $sheet (@{$excel -> {Worksheet}}) {
			print "$_,";
			$_ =~ /(\d{4})(\d{2})(\d{2})/;
			print "$1-$2-$3,";
			print $sheet->{Name}.",";
			$sheet->{MaxRow} ||= $sheet->{MinRow};

			foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
						 
				$sheet -> {MaxCol} ||= $sheet -> {MinCol};
										   
				foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
						
					my $cell = $sheet -> {Cells} [$row] [$col];
 
					if ($cell) {
						$value = $cell->{Val};			 
						$value =~ s/\,//g;
						print "$value," if ($row == 6 && $col == 4);
						if ($row == 7 && $col == 6)
						{
							$value =~ s/\D.*//g;
							print "$value"; 
						}
					}
				}
			}
			print "\n";
		}
	}
}
