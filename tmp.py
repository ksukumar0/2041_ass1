#!/usr/local/bin/python3.5 -u
import sys
# Test file to show some control statements
lines=[]
for line in sys.stdin:
	lines.append(line)
while (lines):
	line=lines.pop()
	print(line,end="")
