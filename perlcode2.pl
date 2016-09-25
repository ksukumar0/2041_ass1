#!/usr/bin/perl -w

my $joinstr = 'david has the hots for Erika :)';
# my $joinstr = "\@hit = join ('|' , (\@arrrgx) ) ";

my $joinrgx = qr/(david .* hots for (.*) :\))/;

# $rgx2 = $joinrgx;
$joinrgx = quotemeta $joinrgx;

$rgx1 = qr/(david .* hots for )(.*)( :\))/;

    if( $joinstr =~ /david/ ) #/(david(.*)(hots for ){1}(.*) :)/g )
    {
		# print "Whole: $1","\n","The next $2 $3 $4";
		# $a=$1;
		# $b=$2;
		# $c=$3;
	    # if (defined $3)
	    # {
	    # 	print "\n\$3 is empty";
	    # }
	    # if (defined $3)
	    # {
	  #   	print "\n\$4 is empty\n";
			# print "\$a is $a","\n","\$b is $2 \$c is $3";
			($a,$b,$c) = ($joinstr =~ /$rgx1/);
			print $a ," ",$b," ",$c;
			$joinstr =~ s/$a$b/$b/g;
			print "\n",$joinstr;
	    # }
	}
my $ctrlstmtrgx = qr/(?:^\s*[#}]*\s*(while|if|elsif|else if|else|foreach|for))/im;
$mystr = '} elsif ($a == 0) {';

if ( $mystr =~ /$ctrlstmtrgx/)
{print "IN HERE";}
