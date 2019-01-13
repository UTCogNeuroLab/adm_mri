#!/bin/bash
export SOURCE_DIR=/Volumes/schnyer/Aging_DecMem/Scan_Data/fmriprep_local/fmriprep
export PYNETS_DIR=~/PyNets/pynets
source ~/.bashrc

PARTIC=$1

# echo -en '\n'
# echo "Which participant?"
# read PARTIC

export REST_PREPROC_FILE="$SOURCE_DIR"/"sub-"$PARTIC""/func/"sub-"$PARTIC""_task-REST_run-01_bold_space-MNI152NLin2009cAsym_preproc.nii.gz
export BRAIN_MASK_FILE="$SOURCE_DIR"/"sub-"$PARTIC""/func/"sub-"$PARTIC""_task-REST_run-01_bold_space-MNI152NLin2009cAsym_brainmask.nii.gz
export CONFOUNDS_FILE_MOD="$SOURCE_DIR"/"sub-"$PARTIC""/func/"sub-"$PARTIC""_task-REST_run-01_desc-confounds_regressors_mod.txt

python3 "$PYNETS_DIR"/pynets_run.py -i "$REST_PREPROC_FILE" -id "$PARTIC" -m "$BRAIN_MASK_FILE" -conf "$CONFOUNDS_FILE_MOD" -min_thr 0.05 -max_thr 0.25 -step_thr 0.05 -plt -pm 3,12 -ua ~/YeoParcellations/MNI/Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm.nii.gz -mod corr -ns 6

#python3 "$PYNETS_DIR"/pynets_run.py -i "$REST_PREPROC_FILE" -id "$PARTIC" -m "$BRAIN_MASK_FILE" -conf "$CONFOUNDS_FILE_MOD" -min_thr 0.05 -max_thr 0.25 -step_thr 0.05 -plt -pm 3,12 -ua ~/YeoParcellations/MNI/Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm.nii.gz -mod corr -ns 3,6 -b 5 -ref ~/YeoParcellations/MNI/Schaefer2018_400Parcels_7Networks_order.txt
