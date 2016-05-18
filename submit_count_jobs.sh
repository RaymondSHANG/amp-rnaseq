#!/bin/bash


bsub -q expressalloc -P acc_AMP_AD -J count_unpaired -W 00:30 -o %J.stdout -e %J.stderr -n 1 -L /bin/bash /hpc/users/xdangk01/AMPAD/reprocess/code/count_unpaired_reads.sh $1
