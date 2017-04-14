#!/bin/bash

module load sailfish/0.9.0 picard

sample=`basename $1 .fastq.gz`

rootdir="/sc/orga/projects/AMP_AD/reprocess"

outdir="${rootdir}/outputs/MSSM/sailfish/${sample}"
if [[ ! -e "$outdir" ]]; then
    mkdir -p $outdir
fi

sailfish quant \
    -p 4 \
    -i /sc/orga/projects/PBG/REFERENCES/GRCh38/sailfish/gencodev24 \
    -l U \
    -r $1 \
    -o $outdir \
    --biasCorrect \
    --numBootstraps 100 \
    --useVBOpt
