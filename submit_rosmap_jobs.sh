#!/bin/bash


bsub -q alloc -P acc_AMP_AD -J sailfish -W 10:00 -o %J.stdout -e %J.stderr -n 4 -R span[ptile=4] -R rusage[mem=4000] -L /bin/bash /hpc/users/xdangk01/AMPAD/reprocess/code/run_sailfish_rosmap.sh $1
