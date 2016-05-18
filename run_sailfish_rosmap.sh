#!/bin/bash

module load sailfish/0.9.0 picard

sample=`basename $1 .bam`


java -Xmx4G -jar $PICARD_HOME/SortSam.jar INPUT=$1 OUTPUT=/dev/stdout SORT_ORDER=queryname QUIET=true VALIDATION_STRINGENCY=SILENT COMPRESSION_LEVEL=0 | java -Xmx4G -jar $PICARD_HOME/SamToFastq.jar INPUT=/dev/stdin FASTQ=/sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP-fastq/$sample.r1.fastq SECOND_END_FASTQ=/sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP-fastq/$sample.r2.fastq VALIDATION_STRINGENCY=SILENT

#samtools collate -O -u $1 | samtools fastq -n -t -1 /sc/orga/AMP_AD/reprocess/inputs/ROSMAP-fastq/$sample.r1.fastq -2 /sc/orga/AMP_AD/reprocess/inputs/ROSMAP-fastq/$sample.r2.fastq

sailfish quant -p 4 -i /sc/orga/projects/PBG/REFERENCES/GRCh38/sailfish/gencodev24 -l ISR -1 /sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP-fastq/$sample.r1.fastq -2 /sc/orga/projects/AMP_AD/reprocess/inputs/ROSMAP-fastq/$sample.r2.fastq  -o /sc/orga/projects/AMP_AD/reprocess/outputs/ROSMAP/$sample --biasCorrect --numBootstraps 100 --useVBOpt
