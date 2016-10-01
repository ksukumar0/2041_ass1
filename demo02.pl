#!/usr/bin/perl -w
# Script to take an input from STDIN and print it out

@arr = ( "how are you\n","i am fine\n" );
@arr2 = (1,2,3);
$str1 = "ascbasdnsadaaadd";

split ( /as/, $str1);
# scalar
# reverse
# join
# push
# pop

@ar1 = join ( 'as', split ( /as/ , join ( 'as', split ( /as/ , $str1) )));

print @ar1,"\n";