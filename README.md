# amp-rnaseq
Code for reprocessing the RNAseq data from AMP-AD.

## Retrieval of site-submitted BAMs from Synapse

(`synapse get` for all relevant Synapse IDs in each project)

## Re-aligning & counting reads with STAR

### ROSMAP

`run_star_rosmap.sh`

### MSSM

`run_star_sinai.sh`

### Mayo

#### TCX

#### CBE

## Combining gene count data

`combine_htseq_assay-level.R`

## Generating metrics with Picard

`run_picard.sh`
