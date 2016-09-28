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
my %cmds = (
	"1" => "join",
	"2" => "split",
	"3" => "push",
	"4" => "pop",
	);
my $cmd = join ('|', values (%cmds));
my @cmdarr;
$i = q/join ('|', split( \/a\/, @var2) ); push/;

if ( $i =~ /$cmd/)
{

	@cmdarr = ($i =~ /$cmd/g);
}
# print join("\n",@cmdarr);
while ( @cmdarr)
{
	print pop(@cmdarr),"\n";
}

sub handle_pop
{
    my ($trans) = @_;
    my $poprgx = qr/pop\s*\(?\s*@(\w+)\s*\)?/;

    if ( $trans =~ /$poprgx/)
    {
        $trans =~ s/$poprgx/$1\.pop\(\)/g;

		$trans = "$1\.pop\(\)";
        # print $trans;
    }
    return ($trans);
}

my $globvar;

$a = 'pop pop pop pop @arr;';
if ( $a =~ /$cmd/)
{

	@cmdarr = ($a =~ /$cmd/g);
}

my @temp;
my $k = 0;
my $poprgx = qr/pop @(\w+)/;
my @x1y1z1bg1;

foreach $i (reverse @cmdarr)
{
	if ( $a =~ /$poprgx/)
	{
		push @x1y1z1bg1, handle_pop($a);

		$glob = '@x1y1z1bg1';
		$a =~ s/$poprgx/$glob/;

		# print $a;
		# print "\n",$k;
		# print eval @temp;
		# $k++;
	}
}

my $final = $x1y1z1bg1[0];

while (@x1y1z1bg1)
{
	my $temp = 	shift (@x1y1z1bg1);
	$temp =~ s/x1y1z1bg1/$final/;
	$final = $temp;
}

print $final; 
# print $a;
# print eval $;

# $j = "a > b";
# $regex = join ('|', values (%operators));
# if ( $j =~ /$regex/ )
# {
# 	print "Accepted\n";
# }
# else
# {
# 	print "Not accepted\n";
# }

# $splitword = "abcdeefbcgh";
# split("bc",$splitword);
# print join ( '|',split("bc",$splitword),"\n");
