#!/usr/bin/perl -w

# my $joinstr = 'david has the hots for Erika :)';
my $joinstr = "\@hit = join ('|' , (1,2,3) ) ";

my $joinrgx = qr/join\s*\(\s*(.*?)\s*,\s*(?:(?:\(?\s*@?(\w+)\s*\)?)|\((.*?)\))\s*\)/;

	# ($a,$b,$c) = ($joinstr =~ /$joinrgx/);
	# if (defined $c)
	# {
		# print "\nB is not defined";
		# print $a ," ",$c;
		if ($joinstr =~ /$joinrgx/)
		{
			if (defined $3)
			{$joinstr =~ s/$joinrgx/\($1\)\.join\($3\)/g;}
			else
			{$joinstr =~ s/$joinrgx/\($1\)\.join\($2\)/g;}
		}
	# }
	# elsif (defined $b)
	# {
		# print "\nC is not defined";
		# print $a ," ",$b;
		# $joinstr =~ s/$joinrgx/$1\.join\($2\)/g;		
	# }

	print "\n",$joinstr,"\n";

my %operators = (
    "\\|\\|" => "or",
    "&&" => "and",
    "gt" => ">",
    "lt" => "<",
    "le" => "<=",
    "ge" => ">=",
    "eq" => "==",
    "ne" => "!=",
    );
$j = "a > b";
$regex = join ('|', values (%operators));
if ( $j =~ /$regex/ )
{
	print "Accepted\n";
}
else
{
	print "Not accepted\n";
}

$splitword = "abcdeefbcgh";
split("bc",$splitword);
print join ( '|',split("bc",$splitword),"\n");
