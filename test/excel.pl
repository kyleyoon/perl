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
#      CREATED: 2013/09/05 09½Ã 22ºÐ 08ÃÊ
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Encode;
use Spreadsheet::ParseExcel;
use File::Find;
 
my $value;
my @date_arr;
my $dir = "/Users/kyoon/2013";
find({wanted => \&export_excel, no_chdir => 1}, "$dir");

sub export_excel {
	if ( $_ =~ /xls$/ ) 
	{
		my $parser   = Spreadsheet::ParseExcel->new();
		my $workbook = $parser->parse($_);
		 
		if ( !defined $workbook ) { die $parser->error(), ".\n"; }
		
		print "$_,";

		for my $worksheet ( $workbook->worksheets() ) {
		 
			my ( $row_min, $row_max ) = $worksheet->row_range();
			my ( $col_min, $col_max ) = $worksheet->col_range();
		 
			for my $row ( $row_min .. $row_max ) {
				for my $col ( $col_min .. $col_max ) {
		 
					my $cell = $worksheet->get_cell( $row, $col );
					next unless $cell;
					$value = $cell->value();			 
					$value =~ s/\,//g;
					if ($row == 1 && $col == 3)
					{
						$value =~ s/ //g;
						@date_arr = split /\./, $value;	
						print encode('utf-8', join "-", @date_arr),"," 
					}
					print encode('utf-8', $value),"," if ($row == 5 && $col == 2);
					if ($row == 6 && $col == 3)
					{
						$value =~ s/\D.*//g;
						print encode('utf-8', $value),"\n" 
					}
				}
			}
		}
	}
}
