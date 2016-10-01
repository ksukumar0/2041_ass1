#!/usr/bin/perl -w
# Test file to print numbers and strings


while ($line = <>) {
    chomp $line;
    $line =~ s/Herm[io]+ne/Zaphod/g;
    $line =~ s/Harry/Hermione/g;
    $line =~ s/Zaphod/Harry/g;
    print $line;
}