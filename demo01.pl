#!/usr/bin/perl -w
# Test file to show some control statements

@input_text_array = <>;
$input_text_array = join ("", @input_text_array);
$total = 0;

@numbers = split(/\D+/, $input_text_array);
print join(",", @numbers);

foreach $number (@numbers) {
	if ($number ne '') {
		$total += $number;
		$n++;
	}
}

if (@numbers) {
	$a = $total/$n
	print "$n numbers: total $total mean is $a";
}