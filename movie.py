import sys
import math
import re
import urllib
import urllib2
data1 = open ("moviein", "r")
source = data1.read()
#lines = source.splitlines()
data2 = open ("movieout","w")

i=1
for line in source.splitlines():

    if line.startswith("MODEL"):
        line = "MODEL " + `i`
        i = i+1
        print i
    data2.write(line)
    data2.write("\n")
data1.close()
data2.close()

