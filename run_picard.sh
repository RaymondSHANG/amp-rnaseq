#!/usr/bin/env bash

sample="$(basename $1 .bam)"
if [ ! -e "data/${sample}" ]; then
    mkdir -p "data/${sample}"
fi

FASTA=data/GRCh38.chr.genome.fa
REFFLAT=data/gencode.v23.refFlat.txt
RIBOINTS=data/gencode.v23.rRNA.interval_list

PICARD="/Users/jaeddy/anaconda/envs/picardtest/share/picard-2.7.1-2/picard.jar"

# CollectAlignmentSummaryMetrics (after sorting)
java -Xmx8G -jar $PICARD SortSam \
    INPUT=data/$1 \
    OUTPUT=/dev/stdout \
    SORT_ORDER=coordinate \
    QUIET=true \
    VALIDATION_STRINGENCY=SILENT \
    COMPRESSION_LEVEL=0 \
    | java -Xmx8G -jar $PICARD CollectAlignmentSummaryMetrics \
        VALIDATION_STRINGENCY=LENIENT \
        MAX_RECORDS_IN_RAM=4000000 \
        ASSUME_SORTED=true \
        ADAPTER_SEQUENCE= \
        IS_BISULFITE_SEQUENCED=false \
        MAX_INSERT_SIZE=100000 \
        R=$FASTA \
        INPUT=/dev/stdin \
        OUTPUT="data/${sample}/picard.analysis.CollectAlignmentSummaryMetrics"

# CollectRnaSeqMetrics (after sorting)
java -Xmx8G -jar $PICARD SortSam \
    INPUT=data/$1 \
    OUTPUT=/dev/stdout \
    SORT_ORDER=coordinate \
    QUIET=true \
    VALIDATION_STRINGENCY=SILENT \
    COMPRESSION_LEVEL=0 \
    | java -Xmx8G -jar $PICARD CollectRnaSeqMetrics \
        VALIDATION_STRINGENCY=LENIENT \
        MAX_RECORDS_IN_RAM=4000000 \
        STRAND_SPECIFICITY=NONE MINIMUM_LENGTH=500 \
        RRNA_FRAGMENT_PERCENTAGE=0.8 \
        METRIC_ACCUMULATION_LEVEL=ALL_READS \
        R=$FASTA \
        REF_FLAT=$REFFLAT \
        RIBOSOMAL_INTERVALS=$RIBOINTS \
        INPUT=/dev/stdin \
        OUTPUT="data/${sample}/picard.analysis.CollectRnaSeqMetrics"

# MarkDuplicates (after sorting)
java -Xmx8G -jar $PICARD SortSam \
    INPUT=data/$1 \
    OUTPUT=/dev/stdout \
    SORT_ORDER=coordinate \
    QUIET=true \
    VALIDATION_STRINGENCY=SILENT \
    COMPRESSION_LEVEL=0 \
    | java -Xmx8G -jar $PICARD MarkDuplicates \
        VALIDATION_STRINGENCY=LENIENT \
        MAX_RECORDS_IN_RAM=4000000 \
        ASSUME_SORTED=true \
        REMOVE_DUPLICATES=true \
        OPTICAL_DUPLICATE_PIXEL_DISTANCE=100 \
        INPUT=/dev/stdin \
        OUTPUT=/dev/null \
        METRICS_FILE="data/${sample}/picard.analysis.MarkDuplicates"
