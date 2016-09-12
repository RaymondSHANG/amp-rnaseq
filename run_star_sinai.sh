#! /bin/bash

# $1 = R1.fastq


module load star/2.5.1b


index='/hpc/users/xdangk01/REFERENCES/GRCh38/star/Gencode24'
prefix=`basename $1 .fastq.gz`

mkdir /hpc/users/xdangk01/AMPAD/reprocess/outputs/MSSM/star/$prefix
cd /hpc/users/xdangk01/AMPAD/reprocess/outputs/MSSM/star/$prefix

STAR --runMode alignReads --runThreadN 4 --genomeDir $index --readFilesIn $1 --outFileNamePrefix $prefix --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode GeneCounts --twopassMode Basic --readFilesCommand zcat

