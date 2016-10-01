#!/usr/bin/perl -w
# Test file to show some nested control statements with badly formated braces

$i = 0;

if ( $i == 0)
{
	print "";
}

print "C way\n";

for ($i=4; $i < 6 ; $i++)
{
	print "$i\n";
	for ($j=10; $j < 12 ; $j++){
		print "$j\n";
		if ( $j == 15 )	{
			print "";		}
		else				{
			print "";}
	}
}

print "Perl way\n";

for $i (4..9)
{
	print "$i\n";
}

print "C way the 2nd TIME\n";

for ($i=4; $i < 6 ; $i++)
{
	print "$i\n";
	for ($j=10; $j < 12 ; $j++)
	{
		print "$j\n";
	}
}