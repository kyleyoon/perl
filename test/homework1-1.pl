#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: homework1-1.pl
#
#        USAGE: ./homework1-1.pl  
#
#  DESCRIPTION: the 1st homework assigned by john.
#
#       AUTHOR: Kyle Yoon (), kyoon@wemakeprice.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2013/06/21 14시 51분 56초
#===============================================================================

#use strict;
#use warnings;
#use utf8;

## LWP for bing translator

#use strict;
use LWP::UserAgent;
use URI::Escape;


$browser = LWP::UserAgent->new();

## 1 Prepare for POST query with your application registration details

$url = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13";
$client_id = "kyle_perl_trans"; 
$client_secret = "vbzrzSwabNINPlK7igEcgfBhBAsLd8ZnC/0dpurWWRE";
$scope = "http://api.microsofttranslator.com";       # fixed
$grant_type = "client_credentials";                  # fixed

## POST request for the 'token'
$response = $browser->post( $url,
    [
        'client_id' => $client_id,
        'client_secret' => $client_secret,
        'scope' => $scope,
        'grant_type' => $grant_type
    ],
);

## Token received is in JSON format, but I've treated it as a string
## and parsed it using pattern matching.

my $content = $response->content;
print  $content."\n";

@array = split(/,/,$content);
$var = $array[1];
$var =~ /"(.*)":"(.*)"/;
$token = uri_escape("Bearer " . $2);
print "Token is ", $token, "\n\n";

print "Sending text for translation\n";

## Text to be translated.

$text = uri_escape("hi");

## 2 Prepare the URL for the GET request, with 'to' language and other parameters.

$url2 = "http://api.microsofttranslator.com/V2/Http.svc/Translate?text=" .     $text .
        "&to=" . "de" .
        "&appId=" . $token .
        "&contentType=text/plain";

$resp2 = $browser->get ($url2, 'Authorization' => $token);

## Here you get the translated string with some tags, which you can parse as per your wish
$value = $resp2->content;
print "\nTranslated text is ", $value;
