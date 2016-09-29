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
# arr = "abcbdbebfgh"
arr = [];
arr1 = ["karthik","is here",1,2];
# arr = arr.split ('b')
str1 = "abcbdbebfgh"

arr = ('|').join(str1.split('b',2))
arr1.append(arr)

arr2 = ["non sense","fighting"]
arr1.extend(arr2)

print (arr1[4])
# arr = ['a','b','c']
# arr2 = ['e','d','f']

# print (arr.extend(arr2))

# arr.extend(arr2)
# print (arr)

# print (arr.pop())

# arr = arr[1:]

# print (arr)