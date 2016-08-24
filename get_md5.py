#! /usr/bin/env python
# KKD for Sage Bionetworks
# 22 Jul 2016

import synapseclient
import sys

syn = synapseclient.login(silent=True)

ent = syn.get(sys.argv[1], downloadFile = False)
print '%s\t%s\t%s' % (ent.md5, ent.name, ent.id)
