#!/usr/bin/env bash
# KKD for Sage Bionetowkrs
# July 18, 2016

module load R python

rootdir="/sc/orga/projects/AMP_AD/reprocess"
codedir="${rootdir}/code/amp-rnaseq"

"${codedir}/bin/calcSailfishVar.R" --oPrefix $1 --headF $2 --wd $3
