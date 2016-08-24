#! /usr/bin/env python
# KKD for Sage Bionetworks
# 8 Jul 2016

import json
import sys
import os		
		
with open(sys.argv[1],'r') as metrics:
	temp = json.load(metrics)
	modString = sys.argv[1]
	for item in temp.values():
	     modString = '\t'.join([modString,str(item)])
	print modString
