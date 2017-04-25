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

**`run_star_rosmap.sh`**
**`run_star_mssm.sh`**
**`run_star_mayo.sh`**

### Combining gene count data

**`combine_counts_study.R`**

## Generating alignment metrics with Picard

**`run_picard.sh`**

### Combining alignment metrics data

**`combine_metrics_study.R`**

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
