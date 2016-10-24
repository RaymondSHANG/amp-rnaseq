#! /bin/bash

# $1 = bamfile (name only, path is hardcoded)
# $2 = unmapped fq file, unzipped


module load star/2.5.1b picard

sample=`basename $1 .bam`



java -Xmx8G -jar $PICARD SortSam INPUT=/hpc/users/xdangk01/AMPAD/reprocess/inputs/MSSM/MSSM-BAM-from-Synapse/bm36/$1 OUTPUT=/dev/stdout SORT_ORDER=queryname QUIET=true VALIDATION_STRINGENCY=SILENT COMPRESSION_LEVEL=0 | java -Xmx4G -jar $PICARD SamToFastq INPUT=/dev/stdin FASTQ=/sc/orga/projects/AMP_AD/reprocess/inputs/MSSM/MSSM-fastq-from-synBAM/$sample.fastq  VALIDATION_STRINGENCY=SILENT

cat /sc/orga/projects/AMP_AD/reprocess/inputs/MSSM/MSSM-fastq-from-synBAM/$sample.fastq /hpc/users/xdangk01/AMPAD/reprocess/inputs/MSSM/MSSM-unmapped-FASTQ-from-Synapse/bm36/$2 | gzip > /sc/orga/projects/AMP_AD/reprocess/inputs/MSSM/MSSM-fastq-from-synBAM/$sample.combined.fastq.gz
rm /sc/orga/projects/AMP_AD/reprocess/inputs/MSSM/MSSM-fastq-from-synBAM/$sample.fastq


index='/hpc/users/xdangk01/REFERENCES/GRCh38/star/Gencode24'

mkdir /hpc/users/xdangk01/AMPAD/reprocess/outputs/MSSM/star_bm36_from_syn3157743/$sample
cd /hpc/users/xdangk01/AMPAD/reprocess/outputs/MSSM/star_bm36_from_syn3157743/$sample

STAR --runMode alignReads --runThreadN 4 --genomeDir $index --readFilesIn /sc/orga/projects/AMP_AD/reprocess/inputs/MSSM/MSSM-fastq-from-synBAM/$sample.combined.fastq.gz --outFileNamePrefix $sample --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode GeneCounts --twopassMode Basic --readFilesCommand zcat

