#!/usr/bin/env bash
# KKD for Sage Bionetworks
# May 18, 2016
# Modified by JAE for Sage Bionetworks
# April 14, 2017

module load sailfish/0.9.0

sample=`basename $1 .r1.fastq.gz`

rootdir="/sc/orga/projects/AMP_AD/reprocess"

outdir="${rootdir}/outputs/ROSMAP/sailfish/${sample}"
if [[ ! -e "$outdir" ]]; then
    mkdir -p $outdir
fi

sailfish quant \
    -i /sc/orga/projects/PBG/REFERENCES/GRCh38/sailfish/gencodev24 \
    -l ISR \
    -1 <(zcat $1) \
    -2 <(zcat $2) \
    -o $outdir \
    --biasCorrect \
    --numBootstraps 100 \
    --useVBOpt
