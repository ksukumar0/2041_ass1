#!/usr/bin/perl -w
# Test script to read lines from files or STDIN

my @arr;

while ($line = <>)
{
	push @arr, $line;
}

print @arr;