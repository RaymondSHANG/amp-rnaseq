#!/bin/bash
#BSUB -q expressalloc
#BSUB -P acc_AMP_AD
#BSUB -J sailfish
#BSUB -W 02:00
#BSUB -o %J.stdout
#BSUB -e %J.stderr
#BSUB -n 4
#BSUB -R span[ptile=4]
#BSUB -R rusage[mem=4000]
#BSUB -L /bin/bash


module load sailfish/0.9.0

sailfish quant -p 4 -i /sc/orga/projects/PBG/REFERENCES/GRCh38/sailfish/gencode24 -l U -r $1  -o /sc/orga/AMP_AD/reprocessed/$1 --biasCorrect --numBootstraps 100 --useVBOpt --fldMean arg --fldSD arg
