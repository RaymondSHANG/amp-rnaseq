#!/usr/bin/env bash
# Calculate transcript quant variance from Sailfish bootstraps
# KKD for Sage Bionetowkrs
# July 18, 2016

# $1 = output file prefix
# $2 = path to file to use for output headers
# $3 = directory of input files

module load R python

# Define paths
rootdir="/sc/orga/projects/AMP_AD/reprocess"
codedir="${rootdir}/code/amp-rnaseq"

# Calculate variance across bootstraps
"${codedir}/bin/calcSailfishVar.R" --oPrefix $1 --headF $2 --wd $3
