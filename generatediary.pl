#!/usr/bin/perl -w

my $status = `git log`;
my $regex = qr/"Date.*"/;
# print $status;
# open $line, "<",\$status;

# while ($var = <$line>)
# {
# 	chomp $var;
# 	print $var,"\n";
# 	$var =~ s/"Sep"/"XXXXXXX"/g;
	
# 	# if ($var =~ /".*Date.*"/)
# 	# {print $1;}
# 	# else {}
# 	# {print "$var";}
# }

@statarray = split /"\n"/, $status;
# print @statarray;
foreach	$tmp (@statarray)
{
	if ($tmp =~ /$regex/)
	{print $tmp;}
	else {}
	# {print "$tmp";}

}