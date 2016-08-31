# KKD for Sage Bionetworks
# 26 Aug 2016


import re
import sys	
from itertools import izip_longest

p1 = re.compile('/1')
p2 = re.compile('/2')

file2 = re.sub('r1','r2',sys.argv[1])

lineno = 1
with open(sys.argv[1],'r') as R1, open(file2,'r') as R2:
	for line1, line2 in izip_longest(R1, R2):   
		if lineno % 4 == 1:
			r1Name = re.sub(p1,'',line1.strip())
			r2Name = re.sub(p2,'',line2.strip())
			try:
				assert r1Name == r2Name
			except AssertionError:
				print '%s %s' % (r1Name, r2Name)

		lineno += 1
		
print 'lines counted: '+str(lineno)