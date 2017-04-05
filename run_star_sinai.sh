#! /bin/bash

# $1 = bamfile (name only, path is hardcoded)
# $2 = unmapped fq.gz file

module load star/2.5.1b picard

sample=`basename $1 .bam`
unmapped=`basename $2 .gz`

rootdir="/sc/orga/projects/AMP_AD/reprocess"
indir="${rootdir}/inputs/MSSM/MSSM-BAM-from-Synapse"
unmapdir="${rootdir}/inputs/MSSM/MSSM-unmapped-FASTQ-from-Synapse"
fastqdir="${rootdir}/inputs/MSSM/MSSM-fastq-from-synBAM"

gunzip "${unmapdir}/${2}"

java -Xmx8G -jar $PICARD \
    SamToFastq INPUT="${indir}/${1}" \
    FASTQ="${fastqdir}/${sample}.fastq" \
    VALIDATION_STRINGENCY=SILENT

# Sorting the FASTQ after addition of unmapped reads
cat "${fastqdir}/${sample}.fastq" "${unmapdir}/${unmapped}" \
    | paste - - - - \
    | sort -k1,1 -S 3G \
    | tr '\t' '\n' \
    | gzip > "${fastqdir}/${sample}.combined.fastq.gz"
rm "${fastqdir}/${sample}.fastq"
gzip "${unmapdir}/${unmapped}"

index="/sc/orga/projects/PBG/REFERENCES/GRCh38/star/Gencode24"

outdir="${rootdir}/outputs/MSSM/star_all_from_syn7416949/${sample}"}
if [[ ! -e "$outdir" ]]; then
    mkdir $outdir
fi
cd $outdir

STAR \
    --runMode alignReads \
    --runThreadN 4 \
    --genomeDir $index \
    --readFilesIn "${fastqdir}/${sample}.combined.fastq.gz" \
    --outFileNamePrefix $sample \
    --outSAMtype BAM Unsorted \
    --outSAMunmapped Within \
    --quantMode GeneCounts \
    --twopassMode Basic \
    --readFilesCommand zcat

