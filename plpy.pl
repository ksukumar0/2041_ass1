#!/usr/bin/perl -w

# written by ksukumar@student.cse.unsw.edu.au September 2016
# Assignment 1 for COMP2041/9041
# http://cgi.cse.unsw.edu.au/~cs2041/assignments/plpy/
# Task to translate PERL Code to PYTHON Code

# Variable and Regex definitions

# $comment_code_regex = qr/(.*\"[^"]*\#[^"]*\"\;)(#.*)/;
# $commentline_regex = qr/(.*)([^"']*#[^"']*)/;

$comment_regex = qr/(?:(^\s*#.*)|(^\s*$))/;
$print_regex = qr/^\s*print\s*"(.*)\\n"[\s;]*$/i;
$print_without_nl_regex = qr/^\s*print\s*"(.*)"[\s;]*$/i;

$print_only_var_without_nl_regex = qr/^\s*print\s*([^"]*)[\s;]*$/i;
$print_only_var_regex = qr/^\s*print\s*([^"]*)\s*,\s*".*\\n"[\s;]*$/i;
$ctrlstmtrgx = qr/(?:^\s*[#]*(while|if|elsif|else if|else|foreach|for))/im;


# $match_perl_line_endings = qr/[;\s]*$/;

my $pytabindent = 0;    # The print tab index for python
my @pyarray;            # Global python array which needs to be printed at the end
my %import;             # Global Hash that has the imports necessary for python
my @loopexpression;

my %vartype;
sub handle_shebang
{
    my ($trans) = @_;
    if ($line =~ /^#!/ && $. == 1) 
    {
        # translate #! Shebang line  
        push (@pyarray, "#!/usr/local/bin/python3.5 -u\n");
        return 0;
    }
    return 1;
}

sub handle_comment
{
    my ($trans) = @_;
    if ($trans =~ /$comment_regex/)
    {
        $trans .="\n"; 
        push(@pyarray, $trans);
        return 0;
    }
    return 1;
}
sub handle_print
{
    my ($trans) = @_;
    my $variable_print;
    my $tmp;
    my $variable_in_print_regex = qr/\$(\w*\b)/;
    my $r;
    my $loc;

##### print simple variables if the line only has variables without newline #####
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
##### print simple variables if the line only has variables without newline #####
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
##### print plain strings below which have a newline in them #####
    if ($trans =~ /$print_regex/)
    {
        # print "TRY 3";
        $variable_print = "print\(\"$1\"\) ";
        @variables = $trans =~ /\$(\w*\b)/g;

        if ($variable_print =~ /$variable_in_print_regex/)
        {
            # print "TRY 4";
            if(!defined $vartype{$1})
            {
                $vartype{$1} = '%d';  
            }

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
            if(!defined $vartype{$1})
            {
                $vartype{$1} = '%d';  
            }
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

sub handle_pp_mm
{
    my ($trans) = @_;
    my $transformed = 1;
    my @var;

    ##### Transforming ++ to +=1 #####
    if ($trans =~ /\+\+/)
    {
        $trans =~ s/\+\+/\+=1/g;
        @var = $trans =~ /\$(\w+)/g;    # Extracting variable names
        $trans =~ s/(\$)(.*?)/$2/g;     # replacing $var with var

        $trans =~ s/[\s;]*$//;
        $transformed = 0;
    }
##### Transforming -- to -=1 #####
    if ( $trans =~ /\-\-/)
    {
        $trans =~ s/\-\-/\-=1/g;
        @var = $trans =~ /\$(\w+)/g;    # Extracting variable names
        $trans =~ s/(\$)(.*?)/$2/g;     # replacing $var with var

        $trans =~ s/[\s;]*$//;
        $transformed = 0;      
    }
    return ($transformed, $trans);
}

sub handle_variable
{

##### Transforms $variable to variable #####
    my ($trans) = @_;
    my $var;
    my $transformed = 1;

##### Handle i++s and i--s in the expression
    ($transformed, $trans) = handle_pp_mm($trans);
    if($transformed == 0)
    {push (@pyarray,$trans);}
##### converting $variable to variable and assigning type to the variable using a hash $vartype #####
    if ($trans =~ /^\s*\$(.*)/)
    {
        @var = $trans =~ /\$(\w+)/g;    # Extracting variable names
        $trans =~ s/(\$)(.*?)/$2/g;     # replacing $var with var

        foreach $i (@var)               # this loop determines the variable type and places them in a hash
        {
            if ($trans =~ /$i.+\./)
                {$vartype{$i} = '%f';}  # Float
            elsif ($trans =~ /$i.+\".*\"/)
                {$vartype{$i} = '%s';}  # String
            else
                {$vartype{$i} = '%d';}  # Default Integer
        }
        $trans =~ s/[\s;]*$//;
        $trans = handle_stdin($trans);
        push (@pyarray,$trans."\n");
        $transformed = 0;
    }

return $transformed;
}

sub handle_operators
{
##### Hash to handle different logical operators for python #####
    my %operators = (
        "\\|\\|" => "or",
        "&&" => "and",
        "gt" => ">",
        "lt" => "<",
        "le" => "<=",
        "ge" => ">=",
        "eq" => "==",
        "ne" => "!=",
        );
   my ($ctrlstmts) = @_;
   my $j;

##### Loop through the operators and perform the change

   foreach $j (keys %operators)
   {
        if ( $j eq "\\|\\|" || $j eq "&&")
        {
            $ctrlstmts =~ s/$j/$operators{$j}/ge;           # replace by the value
        }
        elsif ( $ctrlstmts =~ /\b$j\b/ )
        {
            $ctrlstmts =~ s/$j/$operators{$j}/ge;           # replace by the value
        }
   }
return $ctrlstmts;
}

sub handle_for
{
    my ($string) = @_;
    my $for_regex = qr/(?:for|foreach)(?:\s+(?:my)?\s+|\s+)(\w+?)\s+\((.*)\)/;

    if ($string =~ /$for_regex/ )
    {
        my $ind = $1;
        my $arr = $2;
        $string =~ s/foreach/for/;                      # convert Foreach to for

        if ( $arr =~ /\s*(\d+)\s*..\s*(\d+)\s*/)
        {                                               # Extract range 0..9
            my $temp = $2+1;
            $arr = "range($1,$temp)";
        }
                                                        # Extract Array information er @ARGV
        if ( $arr =~ /@(\w+)/)
        {
            $arr = $1;
            if( $arr eq "ARGV")
            {
                $import{"import sys\n"} = 1;
                $arr = "sys.argv[1:]";
                $vartype{$ind} = '%s';
            }
        }
    $string = "for $ind in $arr :";
    }

    if ( $string =~ /\s*(?:for|foreach)\s*\((.*?);(.*?);(.*?)\)/)
    {
        my $var;
        ##### Handle i++s and i--s in the expression

##### The following section of code had insights from this forum contribution #####
##### http://www.perlmonks.org/?node_id=723825 #####
        my $init;
        my $condition;
        my $exp;
        ($var, $string) = handle_pp_mm($string);

        ($init,$condition,$exp) = $string =~ /\s*(?:for|foreach)\s*\(\s*(.*?)\s*;\s*(.*?)\s*;\s*(.*?)\s*\)/ ;
        
        $condition = 'while'." $condition :";
        $string = $init."\n".$condition."\n"."\t"; #.$exp."\n";
        push (@loopexpression, $exp);                   # push expressions onto an array and print before the closing braces;
        # print $init, " ",$condition, " ", $exp;
        # print $string;
    }
return $string;
}

##### Function to handle input from stdin #####
sub handle_stdin
{
    my ($trans) = @_;
    # print $trans;

##### if of the form while ( $line = <STDIN|FH> ) #####
    if ($trans =~ /while\s*\(\s*(\w*?)\s*[=]?\s*<\s*(\w+)\s*>\s*\)/)
    {
        if ($2 eq "STDIN")
        {
            $import{"import sys\n"}=1;
            # $trans = ()
            # print $1," ",$2;
            $trans = "for $1 in sys.stdin"
        }
        else
        {
            # Handle other files
        }
    }
##### if of the form while ( $line = <STDIN|FH> ) #####
    elsif ( $trans =~ /(\w+)\s*=\s*<\s*(\w+)\s*>/)
    {
        if( $2 eq "STDIN")
        {
            $import{"import sys\n"}=1;
            $trans = "$1 = sys.stdin.readline\(\)";
        }
    }
return $trans;
}
##### This function has derived a lot of information from the following two webpages #####
##### https://www.tutorialspoint.com/perl/perl_operators.htm #####
##### http://www.tutorialspoint.com/python/python_basic_operators.htm #####

sub handle_controlstatements
{

##### Transforms $variable to variable #####
    my ($trans) = @_;
    my $transformed = 1;
    
##### Handle open braces #####
    if ( $trans =~ /{?\s*$/ )
    {$trans =~ s/\s*{?$/\:/;}
    
##### Handle control statements #####
    
    if ( $trans =~ /$ctrlstmtrgx/ )
    {
        # if any control statements are found push onto the array

        $trans =~ s/(\$)(.*?)/$2/g;         # replacing all $var with var

        ##### Handle Operators #####
        $trans = handle_operators($trans);

        if ($trans =~ /elsif/)
        {$trans =~ s/elsif/elif/g;}

        ##### Handle for loops #####
        $trans = handle_for($trans);

        ##### Handle Operators #####
        $trans = handle_stdin($trans);        

        push (@pyarray,$trans."\n");
        $transformed = 0;
    }

##### Handle last statements #####

    if ( $trans =~ /last\s*;\s*}?\s*:*$/ )
    {
        $trans =~ s/last\s*;\s*:*}?\s*:*$/break/;
        push (@pyarray,$trans."\n");
        $transformed = 0;
    }

##### Handle next statements #####

    if ( $trans =~ /next\s*;\s*}?\s*:*$/ )
    {
        $trans =~ s/next\s*;\s*:*}?\s*:*$/continue/;
        push (@pyarray,$trans."\n");
        $transformed = 0;
    }

return $transformed;
}

##### handles CHOMP #####

sub handle_chomp
{
    my ($trans) = @_;
    my $transformed = 1;

    if ( $trans =~ /chomp\s*[(]?\s*\$(\w+)\s*[)]?/ )
    {
        $import{"import sys\n"} = 1;
        $trans = "$1 = $1.rstrip()";
        push (@pyarray,$trans."\n");        
        $transformed = 0;
    }
return $transformed;
}

##### Main Code starts here... #####


$lineno = 0;
while ($line = <>) 
{
    $lineno++;
    chomp $line;
    if (!handle_shebang($line))             # Handle Shebang line and move to the next line
    {next;}

    # print $lineno, " ";

    if (!handle_comment($line))             # Handles Codes with Comments
    {next;}

    if (!handle_print($line))               # Handles prints
    {next;}

    if (!handle_controlstatements($line))
    {next;}                                 # Handles control statements like while/for/foreach etc...

    if (!handle_variable($line))            # Handles variable declarations
    {next;}

    if (!handle_chomp($line))               # Handles chomps
    {next;}

    # if (!handle_arrayprocess($line))        # Handles variable declarations
    # {next;}

    push (@pyarray , "#".$line."\n");   # else comment the code and print it out
}

my $endbrace = qr/#*}\s*$/;
my $bracescount=0;
my @Cstylebraccnt;
my $indent = "\t";

##### Insert the import statements ######

my @firstline = shift (@pyarray);       # Del first line from pyarray
push (@firstline,keys %import);              # Add the imports into the array FIRSTLINE on top of the shebang
push (@firstline, @pyarray);            # add the remaining array on top of the FIRSTLINE with imports
@pyarray = @firstline;                  # Copy FIRSTLINE into PYARRAY

#### Print the python code #####
foreach $i (@pyarray)
{
    if ($i =~ /$endbrace/)
    {     
        # $bracescount--;
    }                                  # Avoid printing closing braces
    else
    {
        $i =~ s/^\t*\ *//;
        my $tabspacing = "$indent"x$pytabindent;
        $i =~ s/^/$tabspacing/mg;
        print $i;
    }                                  # Else print other statements 

#### count open braces #####
    if ($i =~ /^.*{\s*$/)
    {
        $bracescount++;
    }
##### If there is a control statement increment the tab indent for the next line by 1 #####

    if ($i =~ /$ctrlstmtrgx/ )
    {
        $pytabindent++;
    }
    
##### Logic to differentiate the ... #####

    if ($i =~ /\n\t*while/ )            # Logic to print C style For loop in perl
    {                                   # This involves changing the For(;;) into while loop
        # $bracescount++;               # Where the condition is printing before the closing braces
        push(@Cstylebraccnt,$bracescount);
    }

    if($i =~ /$endbrace/)
    {
        if($pytabindent>0)
        {$pytabindent--;}               # Decrease Indent when endbrace is found
        if($#Cstylebraccnt == 0)
        {
            # print @Cstylebraccnt,"Is the NUMBER\n";
        }
        # elsif ($bracescount == $Cstylebraccnt[$#Cstylebraccnt])
        # {
        #     if ( @loopexpression )
        #     {
        #         # print "\t"x($pytabindent+1), shift (@loopexpression);
        #         # print @loopexpression;
        #     }
        #     pop(@Cstylebraccnt);
        # }
    }
}

# print "\n\n\nTHIS IS WHAT IT HAS", join (",",@loopexpression);
# print "\nThe places where the C style while loops are used are", join (",",@Cstylebraccnt);