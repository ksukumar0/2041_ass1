#!/usr/bin/perl -w
# Test File that does all possible arithmatic operations

$a = 3;
$b = 5;

##### Multiply #####
$c = $a*$b;
print "$a x $b = $c\n";

##### Add #####
$c = $a+$b;
print "$a + $b = $c\n";

##### Subtract #####
$c = $a-$b;
print "$a - $b = $c\n";

##### Divide #####
$c = $a/$b;
print "$a / $b = $c\n";

##### Binary OR #####
$c = $a|$b;
print "$a | $b = $c\n";

##### Binary AND #####
$c = $a&$b;
print "$a & $b = $c\n";

##### Binary XOR #####
$c = $a^$b;
print "$a ^ $b = $c\n";

##### Binary << #####
$c = $c << $a;
print "c << $a = $c\n";

##### Binary TOGGLE #####
$c = ~$c;
print "~c = $c\n";

##### Mod #####
$c = $a % $b;
print "$a mod $b = $c\n";

##### Exp #####
$c = $a**$b;
print "$a^$b = $c\n";

$c = 2;
print "\n\nValue of C is $c\n";
$c += 1;
print "c+=1 => $c\n";
$c *= 2;
print "c*=2 => $c\n";
$c -= 1;
print "c-=1 => $c\n";
$c /= 2;
print "c/=1 => $c\n";
$c %= 3;
print "c(mod)=3 => $c\n";

$c **= 3;
print "c**=3 => $c\n";
$c %= 3;
print "c(mod)=3 => $c\n";