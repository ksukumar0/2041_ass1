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

$thi = "Hi \"y'a||\"ll \"gonna\|\|\" || party \" hard";
print $thi,"\n";
$thi =~ s/([^"]*)(\"[^"]*\|\|[^"]*\")([^"]*)/$1$3/g;
# $thi =~ s/\|\|/or/g;
print $thi,"\n";


sub handle
{
	my ($trans) = @_;
	$trans =~ s/my/your/g;
	return $trans;
}

$string = 'for my $i (0..9)';
print "\n$string\n";
my $for_regex = qr/(?:for|foreach)(?:\s+(?:my)?\s+|\s+)\$(\w+?)\s+\((.*)\)/;

if ($string =~ /$for_regex/)
{print "\nMatched\n $1\t$2\n"}
else
{print "\nNot matched\n";}

# $this = "foreach \$i (0..9)";
# $regex = qr/(?:for|foreach)\s+\$(\w+?)\s+\((.*)\)/;
# $this =~ $regex;
# print $1," ",$2,"\n";

# $this = "foreach \$i (\@random)";
# $regex = qr/(?:for|foreach)\s+\$(\w+?)\s+\(@(.*)\)/;
# $this =~ $regex;
# print $1," ",$2;