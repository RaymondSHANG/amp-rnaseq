#! /bin/bash
# KKD for Sage Bionetworks
# 22 Jul 2016

module load python py_packages

for item in `cut -f2 $1`; do /hpc/users/xdangk01/AMPAD/reprocess/code/amp-rnaseq/get_md5.py $item; done
