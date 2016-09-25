#!/usr/bin/perl -w

my $joinstr = ' david has the hots for Erika :)';
# my $joinstr = "\@hit = join ('|' , (\@arrrgx) ) ";

# print $joinstr,"\n";
my $joinrgx = qr/(david .* hots for (.*))( :\))/;
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
			($a,$b) = $joinstr =~ /$joinrgx/;
			$joinstr =~ s/$a/$b/g;
			print "\n",$joinstr;
	    # }
	}