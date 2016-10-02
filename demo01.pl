#!/usr/bin/perl -w
# Test file to print in reverse modified from the lecture examples
# /home/cs2041//public_html/16s2/code/perl/reverse_lines.4.pl

my @lines;
while ($line = <STDIN>) {
    push @lines, $line;
}
while (@lines) {
    my $line = pop @lines;
    print $line;
}