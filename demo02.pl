#!/usr/bin/perl -w
# Script to take an input from STDIN and print it out

@arr = ( "how are you\n","i am fine\n" );
@arr2 = (1,2,3);

print scalar @arr;

print "\n", $arr[0];

print shift push (@arr, @arr2) ;