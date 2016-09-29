#!/usr/bin/perl -w
# written by andrewt@cse.unsw.edu.au as a COMP2041 lecture example
# Print lines read from stdin in reverse order.


my $poprgx = qr/pop\s*\(?\s*@(\w+)\s*\)?/;
my $pushrgx = qr/push\s*\(?\s*@?(\w+)\s*,\s*[@\$]?(\w+)\s*\)?/;
my $shiftrgx = qr/shift\s*\(?@(\w+)/;
my $joinrgx = qr/join\s*\(\s*(.*?)\s*,\s*(?:(?:\(?\s*@?(\w+)\s*\)?)|\((.*?)\))\s*\)/;
my $splitrgx = qr/split\s*\(?\s*\/(.*?)\/\s*,\s*[\@\$]?(\w+)\s*,?\,\s*(\d+)\s*\)/;
my $splitrgxnolimit = qr/split\s*\(?\s*\/(.*?)\/\s*,\s*[\@\$]?(\w+)\s*,?\,?\s*\)/;

sub handle_join
{
    my ($trans) = @_;
    my $transformed = 1;

##### Transforming $str = join('blah',@arr) -> str = arr.join('blah') #####

    if ($trans =~ /$joinrgx/)
    {
        if (defined $3)
        {
            $trans =~ s/$joinrgx/\($1\)\.join\($3\)/g;
            $trans = "\($1\)\.join\($3\)";
        }
        else
        {
            $trans =~ s/$joinrgx/\($1\)\.join\($2\)/g;
            $trans = "\($1\)\.join\($2\)";
        }
    }

return $trans;
}

sub handle_split
{
    my ($trans) = @_;

    ##### Transforming $str = split (/pat/ , exp, limit ) into exp.split('pat',limit) #####
    if ( $trans =~ /$splitrgx/)
    {
        my $temp = $3-1;
        # $trans =~ s/$splitrgx/$2\.split\(\'$1\',$temp\)/g;
        $trans = "$2\.split\(\'$1\',$temp\)";
    }

    if ( $trans =~ /$splitrgxnolimit/)
    {
        # $trans =~ s/$splitrgxnolimit/$2\.split\(\'$1\'\)/g;
        $trans = "$2\.split\(\'$1\'\)";
    }
return $trans;
}

sub handle_pop
{
    my ($trans) = @_;
    if ( $trans =~ /$poprgx/)
    {
        $trans =~ s/$poprgx/$1\.pop\(\)/g;

		$trans = "$1\.pop\(\)";
    }
    return ($trans);
}

sub handle_push
{
    my ($trans) = @_;
    if ( $trans =~ /$pushrgx/g)
    {
        $trans =~ s/$pushrgx/$1\.extend\($2\)/g;

        $trans = "$1\.extend\($2\)";
    }
    return $trans;
}

sub handle_shift
{
    my ($trans) = @_;

    if ( $trans =~ /$shiftrgx/g)
    {
        $trans = "$1\[0\]\n";
        $trans .= "$1 = $1\[1\:\]"
    }
    return $trans;
}

my %arraymanipulatecmds = (
    "1" => "join",
    "2" => "split",
    "3" => "push",
    "4" => "pop",
    "5" => "shift",
    "6" => "unshift",
    );

my $i;
my @cmdarr;
my $cmd = join ('|', values (%arraymanipulatecmds));
my @x1y1z1bg1;

##### MAN STRING #####
my $a = 'pop push ( push @arr, @var , @v1 )';
# $a = 'join (\'|\' , push @arr, @arr2 )';
$a = 'join (\'|\' , push ( @arr , @arr2) )';
$a = 'push( @arr , join (\'|\' , split ( /b/ ,$str , 3 )));';
# $a = 'split ( /a/ , $arr)';
# $a = '$ass   = shift @v1';
##### MAIN STRING END #####

$assignmentvar = "";

if ( $a =~ /$cmd/)
{
	@cmdarr = ($a =~ /$cmd/g);
	if ($a =~ /\$(\w+)\s*=/ )
	{
		$assignmentvar = $1;
	}
}

foreach $i (reverse @cmdarr)
{
	if ( $i eq "pop")
	{
		push @x1y1z1bg1, handle_pop($a);

		$glob = '@x1y1z1bg1';
		$a =~ s/$poprgx/$glob/;
	}
	elsif ( $i eq "push" )
	{
		push @x1y1z1bg1, handle_push($a);

		$glob = '@x1y1z1bg1';
		$a =~ s/$pushrgx/$glob/;	
	}
	elsif ( $i eq "join")
	{
		push @x1y1z1bg1, handle_join($a);

		$glob = '@x1y1z1bg1';
		$a =~ s/$joinrgx/$glob/;
	}
	elsif ( $i eq "split")
	{
		push @x1y1z1bg1, handle_split($a);

		$glob = '@x1y1z1bg1';
		$a =~ s/($splitrgx|$splitrgxnolimit)/$glob/;
	}
	elsif ( $i eq "shift")
	{
		push @x1y1z1bg1, handle_shift($a);

		$glob = '@x1y1z1bg1';
		$a =~ s/$shiftrgx/$glob/;
	}
	# print $a,"\n";
}

my $final = $x1y1z1bg1[0];

while (@x1y1z1bg1)
{
	my $temp = 	shift (@x1y1z1bg1);
	$temp =~ s/x1y1z1bg1/$final/;
	$final = $temp;
}
if ( $assignmentvar ne "")
{print $assignmentvar."=".$final;}
else
{print $final;}