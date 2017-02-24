#!/usr/bin/env bash

# modified from https://gist.github.com/slowkow/b11c28796508f03cdf4b

# Gene annotations in GTF from Gencode
GTF=$1

# Example BAM file generated with the same reference version as GTF
BAM=$2

# Output file suitable for Picard CollectRnaSeqMetrics.jar.
rRNA="$(basename ${1} .annotation.gtf).rRNA.interval_list"

# Sequence names and lengths from BAM header
samtools view -H $2 \
    | egrep -v "(_|\-)" \
    > $rRNA

# Intervals for rRNA transcripts
grep 'gene_type "rRNA"' $GTF \
    | awk '$3 == "transcript"' \
    | cut -f1,4,5,7,9 \
    | perl -lane '
        /transcript_id "([^"]+)"/ or die "no transcript_id on $.";
        print join "\t", (@F[0,1,2,3], $1)
    ' \
    | sort -k1V -k2n -k3n \
    >> $rRNA
