#! /bin/bash
# KKD for Sage Bionetowkrs
# 18 Jul 2016

module load R python

/hpc/users/xdangk01/AMPAD/reprocess/code/amp-rnaseq/calcSailfishVar.R --oPrefix $1 --headF $2 --wd $3
