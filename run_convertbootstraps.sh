#! /bin/bash
# KKD for Sage Bionetworks
# 15 Jul 2016

module load python

rootdir="/sc/orga/projects/AMP_AD/reprocess"
codedir="${rootdir}/code/amp-rnaseq"

for item in `ls ${rootdir}/outputs/ROSMAP`; do
    "${codedir}/tools/salmon/scripts/ConvertBootstrapsToTSV.py" \
        "${rootdir}/outputs/ROSMAP/${item}" \
        "${rootdir}/outputs/ROSMAP/${item}/aux/"
done
