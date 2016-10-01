#!/usr/bin/perl -w
# Test script to show that handling of nested joins and splits

$str1 = "ascbasdnsadaaadd";

$ar1 = join ( 'as', split ( /as/ , join ( 'as', split ( /as/ , $str1) )));
print "Original string is $str1\n";
print "Converted string is $ar1\n";