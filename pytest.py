#!/usr/local/bin/python3.5 -u

x = 1
while (x <= 50):
	if (x%2 == 1 and x<13):
		print(x)
	x = x + 1

for i in range(ord("az"), ord("bz")+1):
	print(chr(i),"  ",end="")