#!/usr/bin/perl -w

$variable = 42;
# $var = 42;

# Prints the variables
print "$variable\n";

# $factor0 = 6;
# $factor1 = 7;

# $str = "print \$factor0 * \$factor1, \"\\n\"\;";
# print $str;
$str = "print \$karthik * \$karthik";

@arr = $str =~ /\$(\w*\b)/g;

if ($str =~ /\$(\w*\b)/)
{print "Yes\n";}

@array = qw(one two three four five six seven eight);
@array = reverse @array;

foreach $p (@array)
{
	print $p,"\n";
}

# print @arr;
$_ = join ("\t",@arr);
print $_;
