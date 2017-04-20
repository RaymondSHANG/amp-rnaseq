#!/usr/bin/env bash
# JAE for Sage Bionetworks
# April 14, 2017

module load sailfish/0.9.0

sample=`basename $1 r1.fastq.gz`
region=$3

rootdir="/sc/orga/projects/AMP_AD/reprocess"

outdir="${rootdir}/outputs/Mayo_${region}/sailfish/${sample}"
if [[ ! -e "$outdir" ]]; then
    mkdir -p $outdir
fi

sailfish quant \
    -i /sc/orga/projects/PBG/REFERENCES/GRCh38/sailfish/gencodev24 \
    -l IU \
    -1 <(zcat $1) \
    -2 <(zcat $2) \
    -o $outdir \
    --biasCorrect \
    --numBootstraps 100 \
    --useVBOpt
