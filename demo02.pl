#!/usr/bin/perl -w
# Script to take an input from STDIN and print it out 

$str1 = <STDIN>;

@ar1 = split ( / /, $str1);
@ar1 = join ("\n", @ar1);
print @ar1,"\n";