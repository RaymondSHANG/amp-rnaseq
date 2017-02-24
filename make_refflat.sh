#!/usr/bin/env bash

# Gene annotations in GTF from Gencode
GTF=$1

# Output file suitable for Picard CollectRnaSeqMetrics.jar.
REFFLAT="$(basename ${1} .annotation.gtf).refFlat.txt"

gtfToGenePred -genePredExt $1 /dev/stdout \
    | perl -lane '
        print join "\t", (@F[11,0..9], $1)
    ' \
    > $REFFLAT
