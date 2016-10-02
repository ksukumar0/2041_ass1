#!/usr/local/bin/python3.5 -u
import sys
# put your demo script here

lines=[]

for line in sys.stdin:
	
	lines.append(line)

lines.reverse()
print(lines,end="")
