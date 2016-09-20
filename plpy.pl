#!/usr/bin/perl -w

# written by ksukumar@student.cse.unsw.edu.au September 2016
# Assignment 1 for COMP2041/9041
# http://cgi.cse.unsw.edu.au/~cs2041/assignments/plpy/
# Task to translate PERL Code to PYTHON Code

# Variable and Regex definitions

# $comment_code_regex = qr/(.*\"[^"]*\#[^"]*\"\;)(#.*)/;
# $commentline_regex = qr/(.*)([^"']*#[^"']*)/;

$comment_regex = qr/(?:(^\s*#.*)|(^\s*$))/;
$print_regex = qr/^\s*print\s*"(.*)\\n"[\s;]*$/;
$print_without_nl_regex = qr/^\s*print\s*"(.*)"[\s;]*$/;

$print_only_var_without_nl_regex = qr/^\s*print\s*([^"]*)[\s;]*$/;
$print_only_var_regex = qr/^\s*print\s*([^"]*)\s*,\s*".*\\n"[\s;]*$/;

# $match_perl_line_endings = qr/[;\s]*$/;

my $pytabindent = 0;
my @pyarray; # Global python array which needs to be printed at the end
my %vartype;
sub handle_shebang
{
    my ($trans) = @_;
    if ($line =~ /^#!/ && $. == 1) 
    {
        # translate #! line  
        push (@pyarray, "#!/usr/local/bin/python3.5 -u\n");
        return 0;
    }
    return 1;
}

sub handle_comment
{
    my ($trans) = @_;
    # my ($code, $comment);
    if ($trans =~ /$comment_regex/)
    {
        $trans .="\n"; 
        push(@pyarray, $trans);
        return 0;
    }
    return 1;
    # elsif ($trans =~ /$commentline_regex/)
    # {
    #     print "TRY 2";
    #     print "Code:", $1, "Comment:",$2,"\n";
    # }
    # elsif ($trans =~ /$comment_code_regex/g)
    # {
    #     $code = $1;
    #     $comment = $2;
    #     print "TRY 3";
    #     print $code," ",$comment,"\n";
    # }
}
sub handle_print
{
    my ($trans) = @_;
    my $variable_print;
    my $tmp;
    my $variable_in_print_regex = qr/\$(\w*\b)/;
    my $r;
    my $loc;

#print simple variables if the line only has variables without newline
    if ($trans =~ /$print_only_var_without_nl_regex/)
    {
        # print "TRY 1";
        my $temp;
        $variable_print = $1;
        # @variables = $trans =~ /\$(\w*\b)/g;      
        $variable_print =~ s/(\$)(\w*\b)/$2/g;
        $variable_print =~ s/[;\s]*$//g;
        $temp = "print\($variable_print,end=\"\"\)\n";

        push (@pyarray,$temp);

        return 0;
    }
#print simple variables if the line only has variables without newline
    elsif ($trans =~ /$print_only_var_regex/)
    {
        # print "TRY 2";
        $variable_print = $1;
        $variable_print =~ s/(\$)(\w*\b)/$2/g;
        $variable_print =~ s/[;\s]*$//g;

        $temp = "print\( $variable_print \)\n";
        push (@pyarray,$temp);
        return 0;
    }

#print plain strings below which have a newline in them
    if ($trans =~ /$print_regex/)
    {
        # print "TRY 3";
        $variable_print = "print\(\"$1\"\) ";
        @variables = $trans =~ /\$(\w*\b)/g;

        if ($variable_print =~ /$variable_in_print_regex/)
        {
            # print "TRY 4";
            $variable_print =~ s/$variable_in_print_regex/$vartype{$1}/ge;
            $variable_print =~ s/\)[;\s]*$//;

            if(scalar @variables == 1)
            {
                # print "TRY 5";
                $temp = "$variable_print \%@variables \)\n";
            }
            else
            {
            # print "TRY 6";
                $r = join (",",@variables);
                $temp = "$variable_print \%\($r\) \)\n";
            }
            push (@pyarray, $temp);
        }
        else
        {
            # print "TRY 7";
            $temp = $variable_print."\n";
            push(@pyarray,$temp);
        }
        return 0;
    }
#print plain strings below which have no newline in them
    elsif ($trans =~ /$print_without_nl_regex/)
    {
        $variable_print = "print\(\"$1\"";           # print(BLAH, end="") 
        @variables = $trans =~ /\$(\w*\b)/g;

        if ($variable_print =~ /$variable_in_print_regex/)
        {
            # $tmp = $1;
            $variable_print =~ s/$variable_in_print_regex/$vartype{$1}/ge;
            $variable_print =~ s/\)[;\s]*$//;

            if(scalar @variables == 1)
            {
                # print "TRY 5";
                $temp = "$variable_print \%@variables \)\n";
            }
            else
            {
            # print "TRY 6";
                $r = join (",",@variables);
                $temp = "$variable_print \%\($r\) \)\n";
            }

            # $temp = "$variable_print \%$tmp,end=\"\"\)\n";
            push(@pyarray,$temp);
        }
        else
        {
            $temp = "$variable_print,end=\"\"\)\n";
            push(@pyarray,$temp);
        }
        return 0;
    }
return 1;
}

sub handle_variable
{

##### Transforms $variable to variable #####
    my ($trans) = @_;
    my $var;
    if ($trans =~ /^\s*\$(.*)/)
    {
        @var = $trans =~ /\$(\w+)/g;    # Extracting variable names
        $trans =~ s/(\$)(.*?)/$2/g;     # replacing $var with var

        foreach $i (@var)               # this loop determines the variable type and places them in a hash
        {
            if ($trans =~ /$i.+\./)
                {$vartype{$i} = '%f';}
            elsif ($trans =~ /$i.+\".*\"/)
                {$vartype{$i} = '%s';}
            else
                {$vartype{$i} = '%d';}
        }
        $trans =~ s/[\s;]*$//;
        push (@pyarray,$trans."\n");
        return 0;
    }
return 1;
}

# sub handle_controlstatements
# {
# ##### Transforms $variable to variable #####
#     my ($trans) = @_;

    
# }

$lineno = 0;
while ($line = <>) 
{
    $lineno++;
    chomp $line;
    if (!handle_shebang($line))         # Handle Shebang line and move to the next line
    {next;}

    # print $lineno, " ";

    if (!handle_comment($line))         # Handles Codes with Comments
    {next;}

    if (!handle_print($line))           # Handles prints
    {next;}

    if (!handle_variable($line))        # Handles variable declarations
    {next;}

    # if (!handle_controlstatements($line))
    # {next;}

    push (@pyarray , "#".$line."\n");   # else comment the code and print it out
}

##### Print the python code #####
foreach $i (@pyarray)
{
    print "\t"x$pytabindent;
    print $i;
    if ($i =~ /(?:^\s*[#](while|if|foreach|for))/ )
    {$pytabindent++;}
    elsif($i =~ /[#]}\s*$/)
    {if($pytabindent>0) {$pytabindent--;}}
}

