#! /bin/bash
# KKD for Sage Bionetworks
# 15 Jul 2016

module load python

rootdir="/sc/orga/projects/AMP_AD/reprocess"
codedir="${rootdir}/code/amp-rnaseq"


python "${codedir}/tools/salmon/scripts/ConvertBootstrapsToTSV.py" $1 "${1}/aux/"
