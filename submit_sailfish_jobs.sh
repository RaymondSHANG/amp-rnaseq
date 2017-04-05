#!/bin/bash


#bsub -q alloc -P acc_AMP_AD -J sailfish -W 15:00 -o %J.stdout -e %J.stderr -n 4 -R span[ptile=4] -R rusage[mem=5500] -L /bin/bash /hpc/users/xdangk01/AMPAD/reprocess/code/amp-rnaseq/run_sailfish_rosmap.sh $1


bsub -q alloc -P acc_SageAD -J sailfish -W 15:00 -o %J.stdout -e %J.stderr -n 4 -R span[ptile=4] -R rusage[mem=6000] -L /bin/bash /hpc/users/xdangk01/AMPAD/reprocess/code/amp-rnaseq/run_sailfish_mayo.sh $1
