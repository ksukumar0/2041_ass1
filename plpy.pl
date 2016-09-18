#!/usr/bin/perl -w

# written by ksukumar@student.cse.unsw.edu.au September 2016
# Assignment 1 for COMP2041/9041
# http://cgi.cse.unsw.edu.au/~cs2041/assignments/plpy/
# Task to translate PERL Code to PYTHON Code

# Variable and Regex definitions

# $comment_code_regex = qr/(.*\"[^"]*\#[^"]*\"\;)(#.*)/;
# $commentline_regex = qr/(.*)([^"']*#[^"']*)/;
$comment_regex = qr/(?:^\s*#.*|^\s*$)/;
$print_regex = qr/^\s*print\s*"(.*)(\\n)+"[\s;]*$/;
sub handle_shebang
{
    my ($trans) = @_;
    if ($line =~ /^#!/ && $. == 1) 
    {
        # translate #! line   
        print "#!/usr/local/bin/python3.5 -u\n";
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
        # print "TRY 1 ";
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
    if ($trans =~ /$print_regex/)
    {
        if (! defined $2)
        {print "print\(\"$1\",end=\"\"\)","\n";}
        else
        {print "print\(\"$1\"\) " ,"\n";}
        return 0;
    }
    return 1;
}

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
   
    # } elsif ($line =~ /^\s*print\s*"(.*)\\n"[\s;]*$/) {
    #     # Python's print adds a new-line character by default
    #     # so we need to delete it from the Perl print statement
        
    #     print "print(\"$1\")\n";
    # } else {
    #     # Lines we can't translate are turned into comments
        
    #     print "#$line\n";
    # }
}
