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

$thi = "This is my line";
print $thi,"\n";
$thi = handle($thi);
print $thi;

%hash = ("||" => "or", "&&" =>"and");

print "\n",%hash;
