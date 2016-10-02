#!/usr/bin/perl -w
# Test file to Substitute Hermione with Harry
# Taken from lecture example /home/cs2041//public_html/16s2/code/perl/gender_reversal.4.pl


while ($line = <>) {
    chomp $line;
    $line =~ s/Herm[io]+ne/Zaphod/g;
    $line =~ s/Harry/Hermione/g;
    $line =~ s/Zaphod/Harry/g;
    print $line;
}