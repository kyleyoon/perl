#!/usr/bin/env perl 

# nbtstat.pl - Jim Halfpenny (June 2003)
# This a port of the C version of nbtstat available for Linux.
# This port is primarily to make it more portable, since the linux
# C versions do not compile Solaris. It uses the IO::Socket
# perl module, so it should work on most perl-supported platforms.
#
# Credit goes to eSDee of Netric (http://www.netric.org) for his C version
# of this tool, on which this one was based.
#
# This program comes with no warranty of any kind. It is a copyrighted code
# that is distributed free-of-charge, under the terms of the GNU Public License
# (GPL). This is often referred to as open-source distribution - see
# http://www.gnu.org or http://www.opensource.org. The legal text of the GPL is available
# at http://www.gnu.org/copyleft/gpl.html
#
# Copyright (c) 2002 Jim Halfpenny

use IO::Socket;


$port = 137;
$host = $ARGV[0];
$proto = "udp";
$timeout = 5;
$buffsize = 512;
$request =  "\xa2\x48\x00\x00\x00\x01\x00\x00";
$request .= "\x00\x00\x00\x00\x20\x43\x4b\x41";
$request .= "\x41\x41\x41\x41\x41\x41\x41\x41";
$request .= "\x41\x41\x41\x41\x41\x41\x41\x41";
$request .= "\x41\x41\x41\x41\x41\x41\x41\x41";
$request .= "\x41\x41\x41\x41\x41\x00\x00\x21";
$request .= "\x00\x01";

# The list of NetBIOS Suffixes
%group  = ( hex("00"), "Domain Name",
	hex("01"), "Master Browser",
	hex("1C"), "Domain Controllers",
	hex("1E"), "Browser Service Elections",
);
%unique = ( hex("00"), "Workstation Service",
	hex("01"), "Messenger Service",
	hex("03"), "Messenger Service",
	hex("06"), "RAS Server Service",
	hex("1B"), "Domain Master Browser",
	hex("1D"), "Master Browser",
	hex("1F"), "NetDDE Service",
	hex("20"), "File Server Service",
	hex("21"), "RAS Client Service",
	hex("22"), "Microsoft Exchange Interchange(MSMail Connector)",
	hex("23"), "Microsoft Exchange Store",
	hex("24"), "Microsoft Exchange Directory",
	hex("30"), "Modem Sharing Server Service",
	hex("31"), "Modem Sharing Client Service",
	hex("43"), "SMS Clients Remote Control",
	hex("44"), "SMS Administrators Remote Control Tool",
	hex("45"), "SMS Clients Remote Chat",
	hex("46"), "SMS Clients Remote Transfer",
	hex("4C"), "DEC Pathworks TCPIP service on Windows NT",
	hex("42"), "mccaffee anti-virus",
	hex("52"), "DEC Pathworks TCPIP service on Windows NT",
	hex("87"), "Microsoft Exchange MTA",
	hex("6A"), "Microsoft Exchange IMC",
	hex("BE"), "Network Monitor Agent",
	hex("BF"), "Network Monitor Application",
);

$sock = new IO::Socket::INET (  PeerAddr => $host,
	PeerPort => $port,
	Proto => $proto,
	Timeout => $timeout);

if (! $sock) {
        die "Socket not opened: $!\n";
}

$sock->send($request);
$sock->recv($data,$buffsize);
$sock->close;

if ($data) {
	print "Got something back:\n";
	#$values = unpack('C',$data);
	@chars = split("", $data);
	foreach (@chars) {
		push(@hex, uc(unpack('H*',$_)));
	}
} else {
	die "Got nothing\n";
}


# print the table of response hex contents
for ($i= 0; $i <= $#hex; ) {
	for ($j = 0; $j < 16; $j++) {
		if ($hex[$i]) {
			print "$hex[$i] ";
		} else {
			print "   ";
		}

		if (! $hex[$i]) {
			$string .= " ";
		} elsif (hex($hex[$i]) < 32 || hex($hex[$i]) > 126) {
			$string .= ".";
		} else {
			$string .= $chars[$i];
		}
		$i++;
	}

	print "$string\n";
	$string = "";
}


# Decode the reply contents
# Here are some comments on the structure of the reply contents.
#
# byte 57 = number of reply fields
# byte 58 = start of first field
# Reply fields consist of a 16 bytes. The first 15 bytes are the value,
# followed by a one byte suffix indicating what the value represents.
# The hashes defined at the top of the script are lookup tables
# for these codes. A list of these codes is available at
# http://support.microsoft.com/default.aspx?scid=KB;EN-US;q163409&
# 
# The 17th bit tells us which class of reply (unique, group etc.)
# Values over 80 indicate it belongs to the group class.
#
$offset = 56;
$replies = hex($hex[$offset]);
print "Total of $replies replies\n";
$offset++;
for ($j = 0; $j < $replies; $j++){
	$name = $type = "";
	for ($i = 0; $i < 15; $i++) {
		$name .= $chars[$offset+$i];
	}
	print " $name\t";
	$type = hex($hex[$offset+15]);
	$class = hex($hex[$offset+16]);
	printf ("<0x%02X>\t<0x%02X>\t",$type,$class);
	if ($class == hex("C4")) {
		if ($name =~ /^INet~/) {
			print "GROUP\tIIS\n";
		} else {
			print "GROUP\t$group{$type}\n";
		}
	} else {
		if ($name =~ /^IS~/) {
			print "\tUNIQUE\tIIS\n";
		} else {
			print "UNIQUE\t$unique{$type}\n";
		}
	}
	$offset += 18;
}

printf("Mac address: %02X:%02X:%02X:%02X:%02X:%02X\n",
		hex($hex[$offset]), hex($hex[$offset+1]), 
hex($hex[$offset+2]),hex($hex[$offset+3]),hex($hex[$offset+4]),hex($hex[$offset+5]));

