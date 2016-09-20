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

$variable_print = "finally";

$t1 = "print\(,$variable_print,end=\"\"\)";
$t1 .= "\n";
push @array,$t1;

# print join('\n', @array);

@arr1 = qw(one two three four five six seven eight);
push(@arr1,@array);
@arr1 = reverse @arr1;
$i = 0;
foreach $p (@arr1)
{
	$i++;
	print "item".$i," ";
	print $p,"\n";
}
# print @arr;
# $_ = join ("\t",@arr);
# print $_;

$str = '$var3 = $var12 * $var2;';
my @var = $str =~ /\$(\w+)/g;
print @var,"\n";

$str = "hello";
$str2 = "world";
$str3 = $str." ".$str2;

print "\t"x4,$str3;