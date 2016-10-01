#!/usr/local/bin/python3.5 -u
import sys
import fileinput
# Test script to read lines from files or STDIN

arr=[]

for line in fileinput.input():
	arr.append(line)

print(arr,end="")
