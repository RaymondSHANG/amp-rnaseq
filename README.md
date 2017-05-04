# amp-rnaseq
Code for reprocessing the RNAseq data from AMP-AD.

All of the code in this repository includes strong dependencies on the software
and filesystem organization within the MSSM Minerva scientific computing
environment. Example LSF or shell commands are provided to illustrate how we
used the scripts to reprocess the AMP-AD RNA-seq data.

## Retrieval of site-submitted BAMs from Synapse

Code not provided for this step, as we used basic `synapse get` commands for
all relevant Synapse IDs in each project (ROSMAP, MSSM, Mayo TCX, Mayo CBE).

## Re-aligning & counting reads with STAR

Each of these scripts converts aligned reads from the downloaded Synapse BAM
file into unmapped FASTQ format (for MSSM, unmapped reads not included in the
BAM file are added from a separate FASTQ file) and re-aligns the reads using
STAR while also counting reads per gene.

Running the scripts below produces a folder for each sample containing outputs
from STAR, most importantly (1) aligned reads in a file labelled
`*Aligned.out.bam`; and (2) gene counts in a file labelled
`*ReadsPerGene.out.tab`.

### Tool versions

+ **STAR:** 2.5.1b
+ **Picard:** 2.2.4

### Usage

Options used for LSF `bsub` commands may vary depending on available system
resources and file organization.

**`run_star_rosmap.sh`:** takes only one input, the BAM file obtained from
Synapse for the current sample
```
bsub \
    -q alloc -P acc_AMP_AD -J star -W 8:00 \
    -n 4 -R rusage[mem=9000] -R span[ptile=4] \
    -o %J.stdout -e %J.stderr \
    -L /bin/bash <path-to-code-folder>/amp-rnaseq/run_star_rosmap.sh \
        406_120503.bam
```

**`run_star_mssm.sh`:** takes two inputs for each sample &mdash; (1) the BAM
file obtained from Synapse; and (2) the FASTQ file (also from Synapse)
containing unmapped reads
```
bsub -q alloc -P acc_AMP_AD -J star -W 8:00 \
    -n 4 -R rusage[mem=9000] -R span[ptile=4] \
    -o %J.stdout -e %J.stderr \
    -L /bin/bash <path-to-code-folder>/run_star_sinai.sh \
        BM_10_546.accepted_hits.sort.coord.bam \
        <path-to-unmapped-fastqs-folder>/BM_10_546.unmapped.fq.gz
```

**`run_star_mayo.sh`:** takes two inputs for each sample &mdash; (1) the BAM
file obtained from Synapse; and (2) the abbreviated brain region (TCX or CBE)
```
bsub -q alloc -P acc_AMP_AD -J star -W 8:00 \
    -n 4 -R rusage[mem=9000] -R span[ptile=4] \
    -o %J.stdout -e %J.stderr \
    -L /bin/bash <path-to-code-folder>/amp-rnaseq/run_star_mayo.sh \
        6976_TCX.snap.bam \
        TCX
```

#### Combining gene count data

The **`combine_counts_study.R`** combines gene count profiles for all
individual samples into a single matrix (rows of features by columns of
samples). The example commands all assume that the current directory contains
all read count files (ending in `ReadsPerGene.out.tab`) from STAR, enumerated
using the `find` command.

The script outputs a tab-delimited matrix file labeled as
`<out_prefix>_all_counts_matrix.txt`.

**ROSMAP:**
```
<path-to-code-folder>/amp-rnaseq/bin/combine_counts_study.R \
    --out_prefix ROSMAP \
    $(find . -name "*ReadsPerGene*" -type f)
```

**MSSM:** (non-default sample suffix to strip trailing characters from BAM
    file name and keep only sample/specimen ID)
```
<path-to-code-folder>/amp-rnaseq/bin/combine_counts_study.R \
    --out_prefix MSSM \
    --sample_suffix "\.accepted_hits.*" \
    $(find . -name "*ReadsPerGene*" -type f)
```

**Mayo:** (use "Mayo_CBE" as output prefix for CBE samples)
```
<path-to-code-folder>/amp-rnaseq/bin/combine_counts_study.R \
    --out_prefix Mayo_TCX \
    $(find . -name "*ReadsPerGene*" -type f)
```

## Generating alignment metrics with Picard

Similar to the `run_star_*` scripts above, the **`run_picard.sh`** was used to
generate alignment metrics for an individual sample based on the output BAM
file from STAR. Specifically, the script computes metrics with the
`CollectAlignmentSummaryMetrics` and `CollectRnaSeqMetrics` Picard modules,
then combines metrics into a single table for the current sample. The same
script can be used for all studies.

Running the script produces a folder for each sample containing outputs
from Picard as well as the combined table (generated using the script 
`combine_metrics_sample.py` in the `bin/` folder), the latter of which is
labelled as `*_picard.CombinedMetrics.csv`.

### Tool versions:

+ **Picard:** 2.2.4

### Usage:

The commands below all assume that the current directory is a folder with
subfolders for each sample, each containing the output BAM file from STAR.

**ROSMAP:**
```
bsub -q alloc -P acc_AMP_AD -J picard -W 8:00 \
    -n 4 -R rusage[mem=8000] -R span[ptile=4] \
    -o %J.stdout -e %J.stderr \
    -L /bin/bash <path-to-code-folder>/code/amp-rnaseq/run_picard.sh \
        406_120503/406_120503Aligned.out.bam
```

**MSSM:**
```
bsub -q alloc -P acc_AMP_AD -J picard -W 8:00 \
    -n 4 -R rusage[mem=8000] -R span[ptile=4] \
    -o %J.stdout -e %J.stderr \
    -L /bin/bash <path-to-code-folder>/amp-rnaseq/run_picard.sh \
        BM_10_546.accepted_hits.sort.coord/BM_10_546.accepted_hits.sort.coordAligned.out.bam
```

**Mayo:** (example provided for TCX, but usage is the same for CBE)
```
bsub -q alloc -P acc_AMP_AD -J picard -W 8:00 \
    -n 4 -R rusage[mem=8000] -R span[ptile=4] \
    -o %J.stdout -e %J.stderr \
    -L /bin/bash <path-to-code-folder>/amp-rnaseq/run_picard.sh \
        6976_TCX/6976_TCXAligned.out.bam
```

### Combining alignment metrics data

The **`combine_metrics_study.R`** combines metrics tables for all
individual samples into a single matrix (rows of samples by columns of
metrics) per study. The example commands all assume that the current directory
contains all metrics count files (ending in `CombinedMetrics.csv`) from the
`run_picard` script, enumerated using the `find` command.

The script outputs a tab-delimited matrix file labeled as
`<out_prefix>_all_metrics_matrix.txt`.

**ROSMAP:**
```
<path-to-code-folder>/amp-rnaseq/bin/combine_metrics_study.R \
    --out_prefix ROSMAP \
    $(find . -name "*CombinedMetrics*" -type f)
```

**MSSM:**
```
<path-to-code-folder>/amp-rnaseq/bin/combine_metrics_study.R \
    --out_prefix MSSM \
    $(find . -name "*CombinedMetrics*" -type f)
```

**Mayo:** (use "Mayo_CBE" as output prefix for CBE samples)
```
<path-to-code-folder>/amp-rnaseq/bin/combine_metrics_study.R \
    --out_prefix Mayo_TCX \
    $(find . -name "*CombinedMetrics*" -type f)
```

---

The following processing steps are in progress and will be described in more
detail in a subsequent data/code release.

## Quantifying transcript abundance with sailfish

**`run_sailfish_rosmap.sh`**
**`run_sailfish_mssm.sh`**
**`run_sailfish_mayo.sh`**

### Converting bootstrap file formats

**`run_convertboostraps.sh`**

### Computing quantification variance from bootstraps

**`run_calcsailfishvar.sh`**

### Combining transcript quantification data

**`combine_quant_study.R`**
