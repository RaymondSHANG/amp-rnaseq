#!/usr/bin/env bash
# Quantify transcript abundance from converted MSSM FASTQ using Sailfish
# JAE for Sage Bionetworks
# April 14, 2017

# $1 = FASTQ file (name only, assumed in current directory)

module load sailfish/0.9.0

sample=`basename $1 .fastq.gz`

# Define paths
rootdir="/sc/orga/projects/AMP_AD/reprocess"

# Reference files
index="/sc/orga/projects/PBG/REFERENCES/GRCh38/sailfish/gencodev24"

# Specify output path
outdir="${rootdir}/outputs/MSSM/sailfish/${sample}"
if [[ ! -e "$outdir" ]]; then
    mkdir -p $outdir
fi

# Quantify transcript abundance with Sailfish (and compute bootstraps)
sailfish quant \
    -p 4 \
    -i $index \
    -l U \
    -r <(zcat $1) \
    -o $outdir \
    --biasCorrect \
    --numBootstraps 100 \
    --useVBOpt
