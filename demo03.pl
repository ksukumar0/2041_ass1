#!/usr/bin/perl -w
# Demo script to print the total number of lines entered in STDIN or file input

$line_count = 0;
while ($line = <>) {
    if (!$line)
    {last;}
    $line_count++;
}
print "$line_count lines\n";