#!/usr/local/bin/python3.5 -u
import sys
# put your demo script here

# print "Enter x: ";
# $x = <STDIN>;
# chomp $x;
# print "Enter y: ";
# $y = <STDIN>;
# chomp $y;
# $pythagoras = sqrt $x * $x + $y * $y;
# print "The square root of $x squared + $y squared is $pythagoras\n";

	#     print " $arg";
	# 
	
# print "\n";

line_count= 0
while (1):
	line = str(sys.stdin.readline())
	if (not line):
		break
	line_count+=1
print("%s lines" %line_count )
