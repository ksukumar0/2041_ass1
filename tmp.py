#!/usr/local/bin/python3.5 -u
import sys
import fileinput
import re

for line in fileinput.input():
	line = line.rstrip()
	line = re.sub("[aeiou]","",line)
	print("%s" %line )
