#!/bin/bash

module load samtools/1.3

sample=`basename $1 .bam`

samtools view -F 1 -c $1 > /hpc/users/xdangk01/AMPAD/reprocess/inputs/$sample.unpaired_counts