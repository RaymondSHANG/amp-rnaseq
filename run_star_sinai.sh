#! /bin/bash

# $1 = bamfile


module load star/2.5.1b picard

sample=`basename $1 .bam`


java -Xmx8G -jar $PICARD SortSam INPUT=$1 OUTPUT=/dev/stdout SORT_ORDER=queryname QUIET=true VALIDATION_STRINGENCY=SILENT COMPRESSION_LEVEL=0 | java -Xmx4G -jar $PICARD SamToFastq INPUT=/dev/stdin FASTQ=/sc/orga/projects/AMP_AD/reprocess/inputs/MSSM-fastq-from-mBAM/$sample.fastq  VALIDATION_STRINGENCY=SILENT


index='/hpc/users/xdangk01/REFERENCES/GRCh38/star/Gencode24'

mkdir /hpc/users/xdangk01/AMPAD/reprocess/outputs/MSSM/star_bm36_original/$sample
cd /hpc/users/xdangk01/AMPAD/reprocess/outputs/MSSM/star_bm36_original/$sample

STAR --runMode alignReads --runThreadN 4 --genomeDir $index --readFilesIn /sc/orga/projects/AMP_AD/reprocess/inputs/MSSM-fastq-from-mBAM/$sample.fastq --outFileNamePrefix $sample --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode GeneCounts --twopassMode Basic

