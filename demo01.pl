#!/usr/bin/perl -w
# Test file to show some control statements

$i = 0;

if ( $i == 0)
{

}

print "C way\n";

for ($i=4; $i < 10 ; $i++)
{
	print "$i\n";
	for ($j=10; $j < 12 ; $j++)
	{
		print "$j\n";
	}

}

print "Perl way\n";

for $i (4..9)
{
	print "$i\n";
}

print "C way\n";

for ($k=4; $k < 10 ; $k++)
{
	print "$i\n";
}

print "Using a while loop in PERL\n";
$i = 0;
while ($i < 10)
{
	print $i,"\n";
	$i++;
}