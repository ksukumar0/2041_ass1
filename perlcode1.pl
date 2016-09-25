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

$Cstyleforloop = "i =0
while i<10 :
	i+=1";

print $Cstyleforloop;
$ctrlstmtrgx = qr/(?:^\s*[#]*(while|if|elsif|else if|else|foreach|for))/im;

    if ($Cstyleforloop =~ /$ctrlstmtrgx/ )
    {
	        # $pytabindent++;
        print "\nFound\n";
    }
    else
    {print "\nNot Found";}
$a = "line";
        $trans = "$a.rstrip()";
        print "\t$trans\n";
        print "\t"x2,$trans;

@Cstylebraccnt = (1,2,3);
$bracescount = 1;

# $bracescount = 5;
# push(@Cstylebraccnt,$bracescount+1);
pop (@Cstylebraccnt);
print "Number: $#Cstylebraccnt";

        if ( @Cstylebraccnt)
        {
            # if ($bracescount == $Cstylebraccnt[$#Cstylebraccnt]-1)
            # {
                # if ( @loopexpression )
                # {
                    # print "\t"x($pytabindent+1), pop (@loopexpression);
                    # print @loopexpression;
                # }
                if ( $bracescount == ($Cstylebraccnt[$#Cstylebraccnt]-1) )
                {
                    print "BRACE END: $Cstylebraccnt[$#Cstylebraccnt]";
                    print pop(@Cstylebraccnt);
                    print "HERE NOW";
                }
            # }
        }

print "Number: $#Cstylebraccnt";

if (@Cstylebraccnt)
{print "Does Exist";}
else
{print "IT Doesent!";}
print "\n",join(',',@Cstylebraccnt);

# my $joinstr = "join ('|' , (1,2,3,4))";
# # my $joinstr = "\@hit = join ('|' , (\@arrrgx) ) ";

# # print $joinstr,"\n";
# my $joinrgx = qr/(join\s*\(\s*(.*?)\s*,\s*(?:(?:\(?\s*@?(\w+)\s*\)?)|\((.*?)\))\s*\))/;
#     if( $joinstr =~ /$joinrgx/g )
#     {
# 		# print "Whole: $1","\n","The next $2 $3 $4";
# 		$a=$1;
# 		$b=$2;
# 		$c=$3;
# 		$d=$4;
# 	    if (defined $3)
# 	    {
# 	    	print "\n\$3 is empty";
# 	    }
# 	    if (defined $4)
# 	    {
# 	    	print "\n\$4 is empty\n";
# 			print "\$a is $a","\n","\$b is $2 \$d is $4";
# 			$joinstr =~ s/$a/$b$d/g;
# 			print "\n",$joinstr;
# 	    }
# 	}


my $joinstr = " karthik has the hots for Erika :)";
# my $joinstr = "\@hit = join ('|' , (\@arrrgx) ) ";

# print $joinstr,"\n";
my $joinrgx = qr/(karthik)(.*)(hots for )(.*)( :)/;
    if( $joinstr =~ /(karthik(.*)(hots for ){1}(.*) :)/g )
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
			$joinstr =~ s/$1/$2\.$4/g;
			print "\n",$joinstr;
	    # }
	}