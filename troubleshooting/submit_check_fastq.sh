#!/bin/bash
#BSUB -q alloc
#BSUB -P acc_SageAD
#BSUB -W 00:20
#BSUB -J fastqcheck
#BSUB -o fastqcheck.%J.stdout
#BSUB -e fastqcheck.%J.stderr

module load python


python ~/AMPAD/reprocess/code/amp-rnaseq/check_fastq_name_match.py $1
