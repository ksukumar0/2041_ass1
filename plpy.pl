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
$ctrlstmtrgx = qr/(?:^\s*[#}]*\s*(while|if|elsif|else if|else|elif|foreach|for))/im;

# $match_perl_line_endings = qr/[;\s]*$/;

my $pytabindent = 0;    # The print tab index for python
my @pyarray;            # Global python array which needs to be printed at the end
my %import;             # Global Hash that has the imports necessary for python
my @loopexpression;     # Global variable which remembers the expression for the next iteration 
                        # of the loop when using a C style for loop
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

##### If its a comment leave it as it is #####

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

    ##### Transforming ++ to +=1 #####
    if ($trans =~ /\+\+/)
    {
        $trans =~ s/\+\+/\+=1/g;
        $trans =~ s/(\$)(.*?)/$2/g;     # replacing $var with var
        $trans =~ s/[\s;]*$//;          # remove ; from the end
        $transformed = 0;
    }
##### Transforming -- to -=1 #####
    if ( $trans =~ /\-\-/)
    {
        $trans =~ s/\-\-/\-=1/g;
        $trans =~ s/(\$)(.*?)/$2/g;     # replacing $var with var
        $trans =~ s/[\s;]*$//;          # remove ; from the end
        $transformed = 0;      
    }
    return ($transformed, $trans);
}

my $poprgx = qr/pop\s*\(?\s*@?([\w:\[\]\.]+)\s*\)?/;
my $pushrgx = qr/push\s*\(?\s*@?([\w:\[\]\.]+)\s*,\s*[@\$]?([\w:\[\]\.]+)\s*\)?/;
my $shiftrgx = qr/shift\s*\(?@?([\w:\[\]\.]+)/;
# my $joinrgx = qr/join\s*\(\s*([^(join)]*?)\s*,\s*(?:(?:\(?\s*@?(\w+)\s*\)?)|\((.*?)\))\s*\)/;
# my $joinrgx = qr/join\s*\(\s*([^(join)]*?)\s*,\s*\(?\s*@?(\w+)\s*\)/;
my $joinrgx = qr/join\s*\(\s*([^(join)]*?)\s*,\s*\(?\s*@?([\w\.\[\]:]+)\s*\)/;
my $splitrgx = qr/split\s*\(?\s*\/([^(split)]*?)\/\s*,\s*[\@\$](\w+)\s*,?\,\s*(\d+)\s*\)?/;
my $splitrgxnolimit = qr/split\s*\(?\s*\/([^(split)]*?)\/\s*,\s*[\@\$](\w+)\s*,?\,?\s*\)?/;

sub handle_join
{
    my ($trans) = @_;
    my $transformed = 1;

##### Transforming $str = join('blah',@arr) -> str = arr.join('blah') #####

    if ($trans =~ /$joinrgx/)
    {
        if (defined $3)
        {
            $trans =~ s/$joinrgx/\($1\)\.join\($3\)/g;
            $trans = "\($1\)\.join\($3\)";
        }
        else
        {
            $trans =~ s/$joinrgx/\($1\)\.join\($2\)/g;
            $trans = "\($1\)\.join\($2\)";
        }
    }

return $trans;
}

sub handle_split
{
    my ($trans) = @_;

    ##### Transforming $str = split (/pat/ , exp, limit ) into exp.split('pat',limit) #####
    if ( $trans =~ /$splitrgx/)
    {
        my $temp = $3-1;
        # $trans =~ s/$splitrgx/$2\.split\(\'$1\',$temp\)/g;
        $trans = "$2\.split\(\'$1\',$temp\)";
    }

    if ( $trans =~ /$splitrgxnolimit/)
    {
        # $trans =~ s/$splitrgxnolimit/$2\.split\(\'$1\'\)/g;
        $trans = "$2\.split\(\'$1\'\)";
    }
return $trans;
}

sub handle_pop
{
    my ($trans) = @_;
    if ( $trans =~ /$poprgx/)
    {
        $trans =~ s/$poprgx/$1\.pop\(\)/g;
        $trans = "$1\.pop\(\)";
    }
    return ($trans);
}

sub handle_push
{
    my ($trans) = @_;
    if ( $trans =~ /$pushrgx/g)
    {
        $trans =~ s/$pushrgx/$1\.extend\($2\)/g;

        $trans = "$1\.extend\($2\)";
    }
    return $trans;
}

sub handle_shift
{
    my ($trans) = @_;

    if ( $trans =~ /$shiftrgx/)
    {
        if ( $1 ne "sys\.argv\[1\:\]")
        {
            $trans = "$1\[0\]\n";
            $trans .= "$1 = $1\[1\:\]";
        }
        else
        {
            $trans = "sys.argv[0]\n";
            $trans .= "sys.argv = sys\.argv\[1\:\]"
        }
    }
    return $trans;
}

my %arraymanipulatecmds = (
    "1" => "join",
    "2" => "split",
    "3" => "pop",
    "4" => "push",
    "5" => "shift",
    "6" => "unshift",
    );

my $i;
my @cmdarr;
my $cmd = join ('|', values (%arraymanipulatecmds));
my @x1y1z1bg1;

sub handle_arrayprocess
{
    my ($a) = @_;
    $assignmentvar = "";

##### Finds all the array manipulation commands used #####
    if ( $a =~ /$cmd/)
    {
        @cmdarr = ($a =~ /$cmd/g);
        ##### getting the assignment variable if any #####
        if ($a =~ /\$(\w+)\s*=/ )
        {
            $assignmentvar = $1;
        }
    }

    foreach $i (reverse @cmdarr)
    {
        my $glob;
        if ( $i eq "pop")
        {
            push @x1y1z1bg1, handle_pop($a);

            $glob = '@x1y1z1bg1';
            $a =~ s/$poprgx/$glob/;
        }
        elsif ( $i eq "push" )
        {
            push @x1y1z1bg1, handle_push($a);

            $glob = '@x1y1z1bg1';
            $a =~ s/$pushrgx/$glob/;    
        }
        elsif ( $i eq "join")
        {
            push @x1y1z1bg1, handle_join($a);

            $glob = '@x1y1z1bg1';
            $a =~ s/$joinrgx/$glob/;
        }
        elsif ( $i eq "split")
        {
            push @x1y1z1bg1, handle_split($a);

            $glob = '@x1y1z1bg1';
            $a =~ s/($splitrgx|$splitrgxnolimit)/$glob/;
        }
        elsif ( $i eq "shift")
        {
            push @x1y1z1bg1, handle_shift($a);

            $glob = '@x1y1z1bg1';
            $a =~ s/$shiftrgx/$glob/;
        }
    }
my $final = $x1y1z1bg1[0];

while (@x1y1z1bg1)
{
    my $temp =  shift (@x1y1z1bg1);
    $temp =~ s/x1y1z1bg1/$final/;
    $final = $temp;
}
if ( $assignmentvar ne "")
{$final = $assignmentvar."=".$final;}

if ( !defined $final )
    {return "";}
else
    {return $final;}
}





##### Transforms $#array to len(array) #####

sub convert_dollar_hash
{
    my ($trans) =@_;
    if ($trans =~ /\$?\#(\w+)/)
    {
        my $tempvar = $1;
        if ( $tempvar eq ARGV)
        {$trans =~ s/\$?\#ARGV/len\(sys.argv\)/g;}
        else
        {
            $trans =~ s/\$?\#(\w+)/len\($1\)/g;     # Replaces #$array with len(array)
        }
        $import{"import sys\n"} = 1;
    }
return $trans;
}


##### Transforms @ARGV to sys.argv[1:] #####
sub convert_ARGV
{
    my ($trans) =@_;
    if ($trans =~ /@ARGV/)
    {
        $trans =~ s/\@ARGV/sys.argv[1:]/g;
        $import{"import sys\n"} = 1;
    }
return $trans;    
}

sub handle_variable
{

##### Transforms $variable to variable #####
    my ($trans) = @_;
    my $var;
    my $t1 = 1;
    my $t2 = 1;
    my $t3 = 1;
    my $t4 = 1;
    my $t5 = 1;
    my $t6 = 1;

##### Handle i++s and i--s in the expression #####
    ($t1, $trans) = handle_pp_mm($trans);

    if ( $trans =~ /STDIN/)
    {
        $trans = handle_stdin($trans);  # If <STDIN> is found changes it to sys.readline()
        $t5 = 0;
    }

##### Converting $#ARGV to len(sys.argv) #####

    if ($trans =~ /\$\#(\w+)/)
    {
        $trans = convert_dollar_hash($trans);
        $t6 = 0;
    }

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
        $t3 = 0;
    }

    my @localvar;

    if( $trans =~ /@\s*(\w+)/)          # looks for @ARGV and changes to sys.argv[1:]
    {                                   # Also gets rid of the sigil for arrays
        @localvar = $trans =~ /\s*@\s*(\w+)\s*/g;
        # print @localvar;
        $trans =~ s/(@\s*)(\w+)/$2/g;
        $trans =~ s/\s*ARGV/sys\.argv\[1:\]/g;
        $t4 = 0;
    }

    $transformed = $t1 & $t2 & $t3 & $t4 & $t5 & $t6;

    if ( $transformed == 0 )
    {
        $trans =~ s/[\s;]*$//;          # Removes ; at the end
        push (@pyarray,$trans."\n");
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

    if ($string =~ /\$?\#(\w+)/)
    {
        $string = convert_dollar_hash($string);
    }
    if ($string =~ /$for_regex/ )
    {
        my $ind = $1;
        my $arr = $2;
        $string =~ s/foreach/for/;                      # convert Foreach to for

        if ( $arr =~ /\s*(\d+)\s*\.\.\s*(.*)\s*/)
        {    
            my $startrange = $1;
            my $temp = $2;               
            if ( $temp =~ /\d+/)                            # Extract range 0..9     
            {$temp += 1;}

            $arr = "range($startrange,$temp)";
        }
                                                        # Extract Array information er @ARGV
        elsif ( $arr =~ /@?([\w\.]+)/)
        {
            $arr = $1;
            if( $arr eq "sys\.argv")
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

##### The following section of code had insights from this forum contribution #####
##### http://www.perlmonks.org/?node_id=723825 #####
        my $init;
        my $condition;
        my $exp;

        ##### Handle i++s and i--s in the expression
        ($var, $string) = handle_pp_mm($string);

        ($init,$condition,$exp) = $string =~ /\s*(?:for|foreach)\s*\(\s*(.*?)\s*;\s*(.*?)\s*;\s*(.*?)\s*\)/ ;
        
        $condition = 'while'." $condition :";

        if ($init =~ /#/)
        {
            $init =~ s/#(\w+)/len($1)/g;
        }
        $string = $init."\n".$condition."\n"."\t";
        push (@loopexpression, $exp);                   # push expressions onto an array and print before the closing braces;
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
            $trans = "for $1 in sys.stdin:"
        }
        else
        {
            # Handle other files
        }
    }
##### if of the form while ( $line = <STDIN|FH> ) #####
    elsif ( $trans =~ /(\w+)\s*=\s*<\s*(\w+)\s*>/ )
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
        if ( $trans =~ /^\s*}/)
        {
            $trans =~ s/^\s*}\s*//;
            push (@pyarray,"}\n");
        }

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

        $transformed = 0;
    }

##### Handle last statements #####

    if ( $trans =~ /last\s*;\s*}?\s*:*$/ )
    {
        $trans =~ s/last\s*;\s*:*}?\s*:*$/break/;
        $transformed = 0;
    }

##### Handle next statements #####

    if ( $trans =~ /next\s*;\s*}?\s*:*$/ )
    {
        $trans =~ s/next\s*;\s*:*}?\s*:*$/continue/;
        $transformed = 0;
    }

##### Handle exit statements #####

    if ( $trans =~ /exit\s*(\d*)\s*;\s*:*}?\s*:*$/ )
    {
        $trans =~ s/exit\s*(\d*)\s*;\s*:*}?\s*:*$/sys\.exit($1)/;
        $import{"import sys\n"} = 1;
        $transformed = 0;
    }


if ($transformed == 0)
{push (@pyarray,$trans."\n");}

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

my $tmp = "";
$lineno = 0;
while ($line = <>) 
{
    $lineno++;
    chomp $line;
    if (!handle_shebang($line))             # Handle Shebang line and move to the next line
    {next;}

    if (!handle_comment($line))             # Handles Codes with Comments
    {next;}

    $line = convert_dollar_hash($line);
    $line = convert_ARGV($line);

    $tmp = handle_arrayprocess($line);      # Handles array manipulations, checks every line
    if ( $tmp eq $line || $tmp eq "" )
    {}
    else
    {
        push (@pyarray, $tmp."\n");
        next;
    }

    if (!handle_print($line))               # Handles prints
    {next;}

    if (!handle_controlstatements($line))
    {next;}                                 # Handles control statements like while/for/foreach etc...

    if (!handle_variable($line))            # Handles variable declarations
    {next;}

    if (!handle_chomp($line))               # Handles chomps
    {next;}

    push (@pyarray , "#".$line."\n");   # else comment the code and print it out
}

my $endbrace = qr/#*\s*}\s*$/;
my $bracescount=0;
my @Cstylebraccnt;
my $indent = "\t";

my %stdinvariables;
my %arithmeticops = (
    "gt" => ">",
    "lt" => "<",
    "le" => "<=",
    "ge" => ">=",
    "eq" => "==",
    "ne" => "!=",
    );
my $allarithops = join ('|', values(%arithmeticops));

##### Assess the type of the STDIN if any at all ######

foreach $i (@pyarray)
{
    if ( $i =~ /(\w+)\s*=\s*sys\.stdin\.readlines?/ )
    {
        $stdinvariables{$1} = "str";
    }
    foreach $stdvar (sort keys %stdinvariables)
    {
        if( $i =~ /$stdvar\s*(?:$allarithops)/)
        {
            # print $i,$stdvar,"FOUND\n";
            if ( $i =~ /$stdvar\s*($allarithops)\s*\d+\.\d+/)
            {
                $stdinvariables{$stdvar} = "float";
            }
            elsif ( $i =~ /$stdvar\s*($allarithops)\s*["].*["]/)
            {
               $stdinvariables{$stdvar} = "str";
            }
            else
            {
               $stdinvariables{$stdvar} = "int";
            }
        }
    }
}

##### Assess the type of the STDIN if any at all ######

foreach $i (@pyarray)
{
    foreach my $j (sort keys %stdinvariables)
    {
        if ( $i =~ /$j\s*=\s*sys\.stdin\.readlines?/ )
        {
            $i =~ s/sys\.stdin\.readlines?\(\)/$stdinvariables{$j}\(sys\.stdin\.readline\(\)\)/;
        }
    }
}

##### Insert the import statements ######

my @firstline = shift (@pyarray);       # Del first line from pyarray
push (@firstline,keys %import);              # Add the imports into the array FIRSTLINE on top of the shebang
push (@firstline, @pyarray);            # add the remaining array on top of the FIRSTLINE with imports
@pyarray = @firstline;                  # Copy FIRSTLINE into PYARRAY

#### Print the python code #####
foreach $i (@pyarray)
{
# print $i;
    if($i =~ /$endbrace/)
    {
        if($pytabindent>0)
        {$pytabindent--;}               # Decrease Indent when endbrace is found
        
        if (@Cstylebraccnt)
        {
            if ( $bracescount == ($Cstylebraccnt[$#Cstylebraccnt]) )
            {
                print "\t"x($pytabindent+1), pop (@loopexpression), "\n";
                pop(@Cstylebraccnt);
            }
        }
        $bracescount--;
    }
        # Else print other statements
    else
    {
        $i =~ s/^\t*\ *//;
        my $tabspacing = "$indent"x($pytabindent);
        $i =~ s/^/$tabspacing/mg;

        if ($i =~ /^.*[{]\s*$/)
        {}                          # Dont print the '{'
        else
        {print $i;}
    }

##### Logic to differentiate the C Style for loops #####

    if ($i =~ /\n\t*while/ )            # Logic to print C style For loop in perl
    {                                   # This involves changing the For(;;) into while loop
        $bracescount++;
        $pytabindent++;
        push(@Cstylebraccnt,$bracescount);
    }

##### If there is a control statement increment the tab indent for the next line by 1 #####

    elsif ($i =~ /$ctrlstmtrgx/ )
    {
        $bracescount++;
        $pytabindent++;
    }
}