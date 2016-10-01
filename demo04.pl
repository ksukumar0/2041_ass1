#!/usr/bin/perl -w
# put your demo script here

$line_number = 0;

while ($line = <STDIN>) {
    $lines[$line_number] = $line;
    $line_number++;
}


for ($line_number = $#lines; $line_number >= 0 ; $line_number--) {
    print $lines[$line_number];
}