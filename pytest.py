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

# y = sys.stdin.readline()
# y = y.rstrip()
# print(y,end="")

a = [1,2,3]
a = a[1:]
a.append(1)
b = sys.argv[1:]

# arr = ('a','b','c')
# print ("|".join(arr))
# arr = arr[2:]
# print (arr)

arr = "abcbdbebfgh"
arr = arr.split ('b')
print(arr)