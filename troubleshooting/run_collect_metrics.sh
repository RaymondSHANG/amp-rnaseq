#! /bin/bash
# KKD for Sage Bionetworks
# 14 Jul 2016


for item in `find ../../outputs/ROSMAP/ -name meta_info.json`; do /hpc/users/xdangk01/AMPAD/reprocess/code/amp-rnaseq/collect_metrics_json.py $item; done

