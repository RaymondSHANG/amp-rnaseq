#!/usr/bin/env bash
# Re-align reads from MSSM-provided BAM (and unmapped FASTQ) using STAR
# KKD for Sage Bionetworks
# September 12, 2016
# Modified by JAE for Sage Bionetworks
# April 5, 2017

# $1 = BAM file (name only, assumed in current directory)
# $2 = gzipped FASTQ file with unmapped reads (full path optional; containing
#      folder hardcoded below)

module load star/2.5.1b picard

sample=`basename $1 .bam`
unmapped=`basename $2 .gz`

# Define paths
rootdir="/sc/orga/projects/AMP_AD/reprocess"
indir="${rootdir}/inputs/MSSM/MSSM-BAM-from-Synapse"
unmapdir="${rootdir}/inputs/MSSM/MSSM-unmapped-FASTQ-from-Synapse"
fastqdir="${rootdir}/inputs/MSSM/MSSM-fastq-from-synBAM"

# Reference files
index="/sc/orga/projects/PBG/REFERENCES/GRCh38/star/Gencode24"

# Unzip unmapped FASTQ
gunzip "${unmapdir}/${2}"

# Convert aligned BAM to FASTQ
java -Xmx8G -jar $PICARD \
    SamToFastq INPUT="${indir}/${1}" \
    FASTQ="${fastqdir}/${sample}.fastq" \
    VALIDATION_STRINGENCY=SILENT

# Sort the FASTQ after addition of unmapped reads
cat "${fastqdir}/${sample}.fastq" "${unmapdir}/${unmapped}" \
    | paste - - - - \
    | sort -k1,1 -S 3G \
    | tr '\t' '\n' \
    | gzip > "${fastqdir}/${sample}.combined.fastq.gz"
rm "${fastqdir}/${sample}.fastq"

# Rezip unmapped FASTQ
gzip "${unmapdir}/${unmapped}"

# Specify output folder
outdir="${rootdir}/outputs/MSSM/star_all_from_syn7416949/${sample}"}
if [[ ! -e "$outdir" ]]; then
    mkdir $outdir
fi
cd $outdir

# Align reads with STAR
STAR \
    --runMode alignReads \
    --runThreadN 4 \
    --genomeDir $index \
    --readFilesIn "${fastqdir}/${sample}.combined.fastq.gz" \
    --outFileNamePrefix $sample \
    --outSAMtype BAM Unsorted \
    --outSAMunmapped Within \
    --quantMode GeneCounts \
    --twopassMode Basic \
    --readFilesCommand zcat
