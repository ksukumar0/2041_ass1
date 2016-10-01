#!/usr/bin/perl -w
# put your demo script here

$line_count = 0;
while (1) {
    $line = <STDIN>;
    if (!$line)
    {last;}
    $line_count++;
}
print "$line_count lines\n";