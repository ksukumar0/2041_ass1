#!/usr/bin/perl -w

# written by ksukumar@student.cse.unsw.edu.au September 2016
# Assignment 1 for COMP2041/9041
# http://cgi.cse.unsw.edu.au/~cs2041/assignments/plpy/
# Task to translate PERL Code to PYTHON Code

# Variable and Regex definitions

$comment_code_regex = qr/(.*\"[^"]*\#[^"]*\"\;)(#.*)/;
$commentline_regex = qr/([^"']*#[^"']*)/;
$comment_inbegin_regex = qr/^\s*(#.*)/;

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
    # my (@array) =~ /$comment_code_regex/ ,$trans;
    # print join @array,"\n";
    my ($code, $comment);
    if ($trans =~ /$comment_inbegin_regex/)
    {
        print "TRY 1";
        print $1,"\n";
    }
    elsif ($trans =~ /$commentline_regex/)
    {
        print "TRY 2";
        print $1,"\n";
    }
    elsif ($trans =~ /$comment_code_regex/)
    {
        $code = $1;
        $comment = $2;
        print "TRY 3";
        print $code," ",$comment,"\n";
    }
}


while ($line = <>) 
{
    chomp $line;
    if (!handle_shebang($line))         #Handle Shebang line and move to the next line
    {next;}
    handle_comment($line);

    # elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) 
    # {
    #     # Blank & comment lines can be passed unchanged
    #     print $line;
    # } elsif ($line =~ /^\s*print\s*"(.*)\\n"[\s;]*$/) {
    #     # Python's print adds a new-line character by default
    #     # so we need to delete it from the Perl print statement
        
    #     print "print(\"$1\")\n";
    # } else {
    #     # Lines we can't translate are turned into comments
        
    #     print "#$line\n";
    # }
}
