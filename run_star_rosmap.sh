#! /bin/bash

# $1 = bamfile (name only, path is hardcoded)


module load star/2.5.1b picard
sample=`basename $1 .bam`


java -Xmx8G -jar $PICARD SortSam INPUT=/sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP/BAM-from-synapse-2/$1 OUTPUT=/dev/stdout SORT_ORDER=queryname QUIET=true VALIDATION_STRINGENCY=SILENT COMPRESSION_LEVEL=0 | java -Xmx4G -jar $PICARD SamToFastq INPUT=/dev/stdin FASTQ=/sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP/ROSMAP-fastq-2/$sample.r1.fastq SECOND_END_FASTQ=/sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP/ROSMAP-fastq-2/$sample.r2.fastq VALIDATION_STRINGENCY=SILENT

gzip /sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP/ROSMAP-fastq-2/$sample.r1.fastq
gzip /sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP/ROSMAP-fastq-2/$sample.r2.fastq

index='/hpc/users/xdangk01/REFERENCES/GRCh38/star/Gencode24'

mkdir /hpc/users/xdangk01/AMPAD/reprocess/outputs/ROSMAP/star_from_syn4164376/$sample
cd /hpc/users/xdangk01/AMPAD/reprocess/outputs/ROSMAP/star_from_syn4164376/$sample

STAR --runMode alignReads --runThreadN 4 --genomeDir $index --readFilesIn /sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP/ROSMAP-fastq-2/$sample.r1.fastq.gz /sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP/ROSMAP-fastq-2/$sample.r2.fastq.gz --outFileNamePrefix $sample --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode GeneCounts --twopassMode Basic --readFilesCommand zcat

