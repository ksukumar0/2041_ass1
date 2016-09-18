#!/usr/bin/perl -w

print "hello";	
#prints hello
print "\n";
# while (<>)
# {
# 	print $_ if /^#/;
# }
$i = 0;
while ($line = <>)
{
	$i++;
	# print $i, " ";
	if ($i %2 == 0)
	{next;}				
	#	exit loop
print $i;
}