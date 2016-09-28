#!/usr/bin/perl -w
# written by andrewt@cse.unsw.edu.au as a COMP2041 lecture example
# Print lines read from stdin in reverse order.

sub handle_pop
{
    my ($trans) = @_;
    my $poprgx = qr/pop\s*\(?\s*@(\w+)\s*\)?/;

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
    my $pushrgx = qr/push\s*\(?\s*@?(\w+)\s*,\s*[@\$]?(\w+)\s*\)?/;

    if ( $trans =~ /$pushrgx/g)
    {
        $trans =~ s/$pushrgx/$1\.extend\($2\)/g;

        $trans = "$1\.extend\($2\)";
    }
    return $trans;
}



my $globvar;
my $i;
my @temp;
my $k = 0;
my $poprgx = qr/pop\s*\(?\s*@(\w+)\s*\)?/;
my $pushrgx = qr/push\s*\(?\s*@?(\w+)\s*,\s*[@\$]?(\w+)\s*\)?/;
my @cmdarr;

my %cmds = (
	"1" => "join",
	"2" => "split",
	"3" => "push",
	"4" => "pop",
	);

my $cmd = join ('|', values (%cmds));
my @x1y1z1bg1;

##### MAN STRING #####
my $a = 'pop push ( push @arr, @var , @v1)';
##### MAIN STRING END #####

if ( $a =~ /$cmd/)
{

	@cmdarr = ($a =~ /$cmd/g);
}

foreach $i (reverse @cmdarr)
{
	if ( $a =~ /$poprgx/)
	{
		push @x1y1z1bg1, handle_pop($a);

		$glob = '@x1y1z1bg1';
		$a =~ s/$poprgx/$glob/;
	}
	elsif ( $a =~ /$pushrgx/)
	{
		push @x1y1z1bg1, handle_push($a);

		$glob = '@x1y1z1bg1';
		$a =~ s/$pushrgx/$glob/;	
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