#!/usr/bin/perl -w
# put your demo script here

my @lines;

while ( $line = <STDIN>)
{
	push @lines , $line;
}

reverse @lines;
print @lines;