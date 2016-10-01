#!/usr/local/bin/python3.5 -u
import sys
import fileinput
# Test file to show some control statements

input_text_array = fileinput.input()
input_text_array=("").join(input_text_array)
total= 0

numbers= input_text_array.split('\D+')
print ((",").join(numbers))

for number in numbers :
	if (number != ''):
		total += number
		n+=1

if (numbers):
	a= total/n
	print("%s numbers: total %s mean is %s" %(n,total,a),end="")
