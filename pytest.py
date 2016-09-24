#!/usr/local/bin/python3.5 -u

import sys

x = 1
while (x <= 50):
	if (x%2 == 1 and x<13):
		print(x)
	x = x + 1

# for i in range(ord('a'), ord('z')+1):
# 	print(chr(i),"  ",end="")

# for line in sys.stdin :
# 	print(line)

y = sys.stdin.read()
y = y.rstrip()
print(y,end="")