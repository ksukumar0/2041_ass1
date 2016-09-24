#!/usr/bin/perl -w
# Test file to show some control statements

my $i = 0;

print "C way\n";

for ($i=4; $i < 10 ; $i++)
{
	print "$i\n";
}

print "C way\n";

for ($i=4; $i < 10 ; $i++)
{
	print "$i\n";
}

print "Perl way\n";

for $i (4..9)
{
	print "$i\n";
}

print "C way\n";

for ($i=4; $i < 10 ; $i++)
{
	print "$i\n";
}