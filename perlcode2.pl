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

	print "\n",$joinstr;

# my $ctrlstmtrgx = qr/(?:^\s*[#}]*\s*(while|if|elsif|else if|else|foreach|for))/im;
# $mystr = '} elsif ($a == 0) {';

# if ( $mystr =~ /$ctrlstmtrgx/)
# {print "IN HERE";}
