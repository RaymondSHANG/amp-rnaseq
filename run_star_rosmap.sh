#! /bin/bash

# $1 = bamfile (name only, path is hardcoded)

module load star/2.5.1b picard

sample=`basename $1 .bam`

rootdir="/sc/orga/projects/AMP_AD/reprocess"
indir="${rootdir}/inputs/ROSMAP/BAM-from-synapse-2"
fastqdir="${rootdir}/inputs/ROSMAP/ROSMAP-fastq-2"

java -Xmx8G -jar $PICARD SortSam \
    INPUT="${indir}/${1}" \
    OUTPUT=/dev/stdout \
    SORT_ORDER=queryname \
    QUIET=true \
    VALIDATION_STRINGENCY=SILENT \
    COMPRESSION_LEVEL=0 \
    | java -Xmx4G -jar $PICARD \
        SamToFastq \
        INPUT=/dev/stdin \
        FASTQ="${fastqdir}/${sample}.r1.fastq" \
        SECOND_END_FASTQ="${fastqdir}/${sample}.r2.fastq" \
        VALIDATION_STRINGENCY=SILENT

gzip "${fastqdir}/${sample}.r1.fastq"
gzip "${fastqdir}/${sample}.r2.fastq"

index="/sc/orga/projects/PBG/REFERENCES/GRCh38/star/Gencode24"

outdir="${rootdir}/outputs/ROSMAP/star_from_syn4164376/${sample}"
if [[ ! -e "$outdir" ]]; then
    mkdir -p $outdir
fi
cd $outdir

STAR \
    --runMode alignReads \
    --runThreadN 4 \
    --genomeDir $index \
    --readFilesIn "${fastqdir}/${sample}.r1.fastq.gz" "${fastqdir}/${sample}.r2.fastq.gz" \
    --outFileNamePrefix $sample \
    --outSAMtype BAM Unsorted \
    --outSAMunmapped Within \
    --quantMode GeneCounts \
    --twopassMode Basic \
    --readFilesCommand zcat

