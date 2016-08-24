#! /bin/bash
# KKD for Sage Bionetworks
# 15 Jul 2016


module load python

for item in `ls /hpc/users/xdangk01/AMPAD/reprocess/outputs/ROSMAP`; do python /hpc/users/xdangk01/AMPAD/reprocess/code/salmon/scripts/ConvertBootstrapsToTSV.py /hpc/users/xdangk01/AMPAD/reprocess/outputs/ROSMAP/$item /hpc/users/xdangk01/AMPAD/reprocess/outputs/ROSMAP/$item/aux/ ; done
