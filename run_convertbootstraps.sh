#!/usr/bin/env bash
# KKD for Sage Bionetworks
# July 15, 2016
# Modified by JAE for Sage Bionetworks
# April 18, 2017

module load python

rootdir="/sc/orga/projects/AMP_AD/reprocess"
codedir="${rootdir}/code/amp-rnaseq"


python "${codedir}/tools/salmon/scripts/ConvertBootstrapsToTSV.py" $1 "${1}/aux/"
