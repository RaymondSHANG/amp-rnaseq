#!/usr/bin/env bash
# JAE for Sage Bionetworks
# February 24, 2017

# Gene annotations in GTF from Gencode
GTF=$1

# Output file suitable for Picard CollectRnaSeqMetrics.jar.
REFFLAT="$(basename ${1} .annotation.gtf).refFlat.txt"

gtfToGenePred -genePredExt $1 refFlat.tmp.txt
paste <(cut -f 12 refFlat.tmp.txt) <(cut -f 1-10 refFlat.tmp.txt) \
    > $REFFLAT
rm refFlat.tmp.txt
