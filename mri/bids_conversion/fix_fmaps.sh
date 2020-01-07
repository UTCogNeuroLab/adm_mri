#!/bin/bash
#set -x
##BIDS conversion script for ADM neuroimaging data
##@kimray

export WORKING_DIR=/Volumes/schnyer/Aging_DecMem/Scan_Data
export SOURCE_DIR="$WORKING_DIR"/RAW
export BIDS_DIR="$WORKING_DIR"/BIDS
export PYDEFACEPATH="/Users/PSYC-mcm5324/pydeface/scripts"

##Choose Participant
echo -en '\n'
echo "Which participant?"
read PARTIC

##Find raw dicom directories
FMAP_RAW=`find $SOURCE_DIR/Adm_"$PARTIC" -maxdepth 1 \( -iname '*FIELD_MAPPING*' -o -iname '*Field_mapping*' \) -print | sort -r | tail -1`
echo "$FMAP_RAW"

##Create BIDS filenames
#FMAP_MAG_FILE="sub-"$PARTIC""_"$VISIT_DIR"_magnitude
FMAP_PHASE_FILE="sub-"$PARTIC""_phasediff

##Create BIDS formatted directories
if [ ! -d "$BIDS_DIR"/"sub-"$PARTIC""/fmap ] && [ ! -z "$FMAP_RAW" ] && [ ! -z "$FMAP_RAW" ]; then
    mkdir -p "$BIDS_DIR"/"sub-"$PARTIC""/fmap
fi

##Convert dicoms to nifti

##Convert FMAP dicoms
if [ ! -z "$FMAP_RAW" ]; then
    echo -en "\n\n\nConverting fieldmap for "$PARTIC"...\n\n\n"
    FMAP_FILE="fieldmap"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC"/fmap/ -f fieldmap -z y -b y -ba y -1 "$FMAP_RAW"
    wait

fi

#Fix naming
#Meg McMahon
#phase
a=1
for i in `ls "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_FILE"_e2_ph*.nii.gz`; do

    PH_NIFTI=$(printf "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"sub-"$PARTIC""_run-%02d_phasediff.nii.gz "$a")
    PH_JSON=$(printf "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"sub-"$PARTIC""_run-%02d_phasediff.json "$a")

    mv -i "$i" "$PH_NIFTI"
    mv -i ${i%.nii.gz}".json" "$PH_JSON"
    let a=a+1

done
wait


#magnitude 1
a=1
for i in `ls "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_FILE"_e1*.nii.gz`; do
    MAG1_NIFTI=$(printf "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"sub-"$PARTIC""_run-%02d_magnitude1.nii.gz "$a")
    MAG1_JSON=$(printf "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"sub-"$PARTIC""_run-%02d_magnitude1.json "$a")

    mv -i "$i" "$MAG1_NIFTI"
    mv -i ${i%.nii.gz}".json" "$MAG1_JSON"

    let a=a+1
done
wait

#magnitude 2
a=1
for i in `ls "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_FILE"_e2*.nii.gz`; do

    MAG2_NIFTI=$(printf "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"sub-"$PARTIC""_run-%02d_magnitude2.nii.gz "$a")
    MAG2_JSON=$(printf "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"sub-"$PARTIC""_run-%02d_magnitude2.json "$a")

    mv -i "$i" "$MAG2_NIFTI"
    mv -i ${i%.nii.gz}".json" "$MAG2_JSON"
    let a=a+1
done
wait

python3 fix_jsons.py "$PARTIC"

#zip -vr $SOURCE_DIR/Adm_"$PARTIC".zip $SOURCE_DIR/Adm_"$PARTIC"/* -x "*.DS_Store"
