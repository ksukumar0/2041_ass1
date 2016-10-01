#!/usr/bin/perl -w
# put your demo script here

# print "Enter x: ";
# $x = <STDIN>;
# chomp $x;
# print "Enter y: ";
# $y = <STDIN>;
# chomp $y;
# $pythagoras = sqrt $x * $x + $y * $y;
# print "The square root of $x squared + $y squared is $pythagoras\n";

# foreach $arg (@ARGV) {
#     print " $arg";
# }
# print "\n";

$line_count = 0;
while (1) {
    $line = <STDIN>;
    if (!$line)
    {last;}
    $line_count++;
}
print "$line_count lines\n";