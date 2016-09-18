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
$print_only_var_regex = qr/^\s*print\s*([^"].*)[\s;]*$/;
$print_without_nl_regex = qr/^\s*print\s*"(.*)"[\s;]*$/;


sub handle_shebang
{
    my ($trans) = @_;
    if ($line =~ /^#!/ && $. == 1) 
    {
        # translate #! line   
        return print "#!/usr/local/bin/python3.5 -u\n";
        # return 0;
    }
    return 1;
}

sub handle_comment
{
    my ($trans) = @_;
    # my ($code, $comment);
    if ($trans =~ /$comment_regex/)
    {
        print $trans,"\n";
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

#print simple variables if the line only has variables
    # if ($variable_print =~ 
    
    #print plain strings below which have a newline in them
    if ($trans =~ /$print_regex/)
    {
        $variable_print = "print\(\"$1\"\) ";
        
        if ($variable_print =~ /$variable_in_print_regex/)
        {
            $tmp = $1;
            $variable_print =~ s/$variable_in_print_regex/\%d/g;
            $variable_print =~ s/\)[;\s]*$//;
            print $variable_print,"\%",$tmp,"\n";
        }
        else
        {print $variable_print,"\n";}
        return 0;
    }

    #print plain strings below which have no newline in them
    elsif ($trans =~ /$print_without_nl_regex/)
    {
        $variable_print = "print\(\"$1\"";           # print(BLAH, end="") 
        if ($variable_print =~ /$variable_in_print_regex/)
        {
            $tmp = $1;
            $variable_print =~ s/$variable_in_print_regex/\%d/g;
            $variable_print =~ s/\)[;\s]*$//;
            print $variable_print,"\%",$tmp,",end=\"\"\)\n";
        }
        else
        {print $variable_print,",end=\"\"\)","\n";}
        return 0;
    }

return 1;
}

sub handle_variable
{
    my ($trans) = @_;
    if ($trans =~ /^\s*\$(.*)/)
    {
        $trans =~ s/(\$)(.*?)/$2/g;
        $trans =~ s/[\s;]*$//;
        print $trans,"\n";
    }
return 0;
}

$lineno = 0;
while ($line = <>) 
{
    $lineno++;
    chomp $line;
    
    if (!handle_shebang($line))         # Handle Shebang line and move to the next line
    {next;}

    # print $lineno, " ";

    if (!handle_print($line))           # Handles prints
    {next;}

    if (!handle_comment($line))         # Handles Codes with Comments
    {next;}

    if (!handle_variable($line))        # Handles variable declarations
    {next;}
}
