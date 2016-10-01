#!/usr/bin/perl -w
# Test file to print numbers and strings

$var = 6;
$var2 = 7;
$fltnum = 42.42;

$var3 = $var * $var2;
$str = "howdy";
print "simple demo statements without newlines";
print "simple demo statements with newlines\n";
print "\tprint\twith\ttabs";

print $var * $var2, "\n";
print $var * $var2;

print "The answer to Life is $var3 which is also $var x $var2";

print "\n$var x $var2 = $var3\n";

print "$str is how americans say hi\n";

print "$fltnum is the answer to life";