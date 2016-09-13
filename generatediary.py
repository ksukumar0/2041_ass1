#!/usr/bin/python

import subprocess, sys, re, string

# Courtesy of Stack Overflow 
# git log --pretty=format:"%h%x09%an%x09%ad%x09%s"

gitcmd = "git log --pretty=format:\"%x01%an%x09%ad%x09%s\"";

# Courtesy of Stack Overflow 
# http://stackoverflow.com/questions/4256107/running-bash-commands-in-python

log = subprocess.Popen(gitcmd.split(), stdout=subprocess.PIPE)
output = log.communicate()[0]
regex = ".*Date(.*)"
diary = open ('diary.txt','w')

for line in output.splitlines():
	# if re.match(regex,line):
	line = re.sub('"','',line)
	line = re.sub('^\ +','',line)
	print line
	diary.write(line+"\n")