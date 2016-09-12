#!/usr/bin/python

import subprocess, sys, re

gitcmd = "git log";

# Courtesy of Stack Overflow 
# http://stackoverflow.com/questions/4256107/running-bash-commands-in-python

log = subprocess.Popen(gitcmd.split(), stdout=subprocess.PIPE)
output = log.communicate()[0]
regex = ".*Date(.*)"

print output;

# @statarray = split /"\n"/, $status;
# # print @statarray;
# foreach	$tmp (@statarray)
# {
# 	if ($tmp =~ /$regex/)
# 	{print $tmp;}
# 	else {}
# 	# {print "$tmp";}

# }