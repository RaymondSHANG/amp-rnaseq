#!/usr/bin/env bash
# Quantify transcript abundance from converted ROSMAP FASTQ using Sailfish
# KKD for Sage Bionetworks
# May 18, 2016
# Modified by JAE for Sage Bionetworks
# April 14, 2017

# $1 = FASTQ file (name only, assumed in current directory)

module load sailfish/0.9.0

sample=`basename $1 .r1.fastq.gz`

# Define paths
rootdir="/sc/orga/projects/AMP_AD/reprocess"

# Reference files
index="/sc/orga/projects/PBG/REFERENCES/GRCh38/sailfish/gencodev24"

# Specify output path
outdir="${rootdir}/outputs/ROSMAP/sailfish/${sample}"
if [[ ! -e "$outdir" ]]; then
    mkdir -p $outdir
fi

# Quantify transcript abundance with Sailfish (and compute bootstraps)
sailfish quant \
    -i $index \
    -l ISR \
    -1 <(zcat $1) \
    -2 <(zcat $2) \
    -o $outdir \
    --biasCorrect \
    --numBootstraps 100 \
    --useVBOpt
