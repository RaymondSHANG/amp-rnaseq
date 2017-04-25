#!/usr/bin/env bash
# Convert Sailfish bootstrap transcript quant estimates into tabular format
# KKD for Sage Bionetworks
# July 15, 2016
# Modified by JAE for Sage Bionetworks
# April 18, 2017

# $1 = path to Sailfish output folder for selected sample

module load python

# Define paths
rootdir="/sc/orga/projects/AMP_AD/reprocess"
codedir="${rootdir}/code/amp-rnaseq"

# Run Salmon-provided 'ConvertBootstrapsToTSV' script
python "${codedir}/tools/salmon/scripts/ConvertBootstrapsToTSV.py" $1 "${1}/aux/"
