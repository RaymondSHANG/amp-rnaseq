#!/bin/bash

module load sailfish/0.9.0 picard

sample=`basename $1 .bam`

rootdir="/sc/orga/projects/AMP_AD/reprocess"
fastqdir="${rootdir}/inputs/ROSMAP/ROSMAP-fastq-2"

outdir="${rootdir}/outputs/ROSMAP/sailfish/${sample}"
if [[ ! -e "$outdir" ]]; then
    mkdir -p $outdir
fi

sailfish quant \
    -p 4 \
    -i /sc/orga/projects/PBG/REFERENCES/GRCh38/sailfish/gencodev24 \
    -l IU \
    -1 "${fastqdir}/${sample}.r1.fastq" \
    -2 "${fastqdir}/${sample}.r2.fastq" \
    -o $outdir \
    --biasCorrect \
    --numBootstraps 100 \
    --useVBOpt
