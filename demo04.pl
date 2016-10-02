#!/usr/bin/perl -w
# Prints lines in reverse

my @lines;

while ( $line = <STDIN>)
{
	push @lines , $line;
}

reverse @lines;
print @lines;