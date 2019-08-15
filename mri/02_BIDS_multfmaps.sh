#!/bin/bash
#set -x
##Megan McMahon

#`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING*_*_RUN1*' -print | sort -r | tail -1
#mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3".nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"1.nii.gz 2>/dev/null
###-exec mv {} /Volumes/schnyer/Megan/NetMetrics_corr_ADM \;


#Need to add intended for for all of these participants
#Check AgingDataProgress excel sheet

export WORKING_DIR=/Volumes/schnyer/Aging_DecMem
export SOURCE_DIR=$WORKING_DIR/Scan_Data/RAW
export BIDS_DIR=$WORKING_DIR/Scan_Data/BIDS


##Choose Participant
# echo -en '\n'
# echo "Which participant?"
# read PARTIC
PARTIC=$1

NMAPS=`ls -l "$SOURCE_DIR"/"$PARTIC" | grep "^d" | grep FIELD_MAPPING | wc -l`

if [ NMAPS > 2 ]; then
  echo "Multiple fieldmaps detected. Running ... "
  echo "DICOM directories must be renamed prior to conversion as FIELD_MAPPING_RUN1 FIELDMAPPING_RUN2 etc. If not renamed yet, please exit now (CTRL + c)"
  sleep 5

  rm -rf "$BIDS_DIR"/"sub-"$PARTIC""/fmap/*

  #Find initial fieldmaps
  FMAP_MAG_RAW_RUN1=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING_RUN1*' -print | sort -r | tail -1`
  FMAP_PHASE_RAW_RUN1=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING_RUN1*' -print | sort | tail -1`

  #Find rerun fieldmaps
  FMAP_MAG_RAW_RUN2=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING_RUN2*' -print | sort -r | tail -1`
  FMAP_PHASE_RAW_RUN2=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING_RUN2*' -print | sort | tail -1`

  FMAP_MAG_RAW_RUN3=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING_RUN3*' -print | sort -r | tail -1`
  FMAP_PHASE_RAW_RUN3=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING_RUN3*' -print | sort | tail -1`

  #Name initial fieldmap files for each run (up to 3)
  export FMAP_MAG_FILE_RUN1="sub-"$PARTIC""_run-01_magnitude
  export FMAP_PHASE_FILE_RUN1="sub-"$PARTIC""_run-01_phasediff
  export FMAP_MAG_FILE_RUN2="sub-"$PARTIC""_run-02_magnitude
  export FMAP_PHASE_FILE_RUN2="sub-"$PARTIC""_run-02_phasediff
  export FMAP_MAG_FILE_RUN3="sub-"$PARTIC""_run-03_magnitude
  export FMAP_PHASE_FILE_RUN3="sub-"$PARTIC""_run-03_phasediff

  if [ ! -z ""$FMAP_MAG_FILE_RUN1"" ]; then
    echo -en "\n\n\nConverting RUN 1 magnitude fieldmap for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/" -f "$FMAP_MAG_FILE_RUN1" -z y -b y -ba y -1 ""$FMAP_MAG_RAW_RUN1""

    echo -en "\n\n\nConverting RUN 1 phase fieldmap for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/" -f "$FMAP_PHASE_FILE_RUN1" -z y -b y -ba y -1 ""$FMAP_PHASE_RAW_RUN1""

    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"_e1.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"1.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"_e1.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"1.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1".nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"1.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1".json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"1.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"_e2.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"2.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"_e2.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"2.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1"_e2.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1"_e2.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".json 2>/dev/null

    ##Extract two echo times
    M1=`find ""$FMAP_MAG_FILE_RUN1"" \( -iname "*.dcm" -o -iname "*.ima" \) | sort | head -1`
    M2=`find ""$FMAP_MAG_FILE_RUN1"" \( -iname "*.dcm" -o -iname "*.ima" \) | sort | head -2 | tail -1`
    TE1=`mri_probedicom --i $M1 --t 0018 0081`
    TE2=`mri_probedicom --i $M2 --t 0018 0081`
    TE1=`bc -l <<< "${TE1}"/1000`
    TE2=`bc -l <<< "${TE2}"/1000`
    dTE=`bc -l <<< "1000*(${TE2} - ${TE1})"`
    TE1_rnd=`printf "%0.5f\n" $TE1` #is this still correct for aging study??
    TE2_rnd=`printf "%0.5f\n" $TE2` #is this still correct for aging study??
    dTE_rnd=`printf "%0.2f\n" $dTE` #is this still correct for aging study??

    ###Calculate Bandwidth per pixel phase encode
    BWpe=`mri_probedicom --i $M1 --t 0018 0095`
    ##Retrieve number of phase encoding lines
    dimpe=`mri_probedicom --i $M1 --t 0018 0089`
    ##Calculate Dwell Time/ Effective Echo Spacing
    dwell=`echo $BWpe $dimpe | awk '{print (1/($1*$2))}'`

    ##Add echo times to fieldmap json's
    #sed -i 's/\"EchoTime\"\: '${TE2_rnd}'/\"EchoTime1\"\: '${TE1_rnd}'\,\n\t"EchoTime2\"\: '${TE2_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"EchoTime\"\: '${TE2_rnd}'/\"EchoTime1\"\: '${TE1_rnd}'\,\n\t"EchoTime2\"\: '${TE2_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"EchoTime2\"\: '${TE2_rnd}'/\"EchoTime2\"\: '${TE2_rnd}'\,\n\t\"DwellTime\"\: '${dwell}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"DwellTime\"\: '${dwell}'/\"DwellTime\"\: '${dwell}'\,\n\t\"deltaEchoTime\"\: '${dTE_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    ##Add echo times to fieldmap json's
    sed -i 's/\"EchoTime\"\: '0.00765'/\"EchoTime1\"\: '0.00519'\,\n\t"EchoTime2\"\: '0.00765'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".json #is this still correct for aging study??
    sed -i 's/\"EchoTime2\"\: '0.00765'/\"EchoTime2\"\: '0.00765'\,\n\t\"DwellTime\"\: '4.57875e-05'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".json #is this still correct for aging study??
    sed -i 's/\"DwellTime\"\: '4.57875e-05'/\"DwellTime\"\: '4.57875e-05'\,\n\t\"deltaEchoTime\"\: '2.46'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".json #is this still correct for aging study??
  fi

  if [ ! -z ""$FMAP_MAG_FILE_RUN2"" ]; then
    echo -en "\n\n\nConverting RUN 2 magnitude fieldmap for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/" -f "$FMAP_MAG_FILE_RUN2" -z y -b y -ba y -1 ""$FMAP_MAG_RAW_RUN2""

    echo -en "\n\n\nConverting RUN 2 phase fieldmap for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/" -f "$FMAP_PHASE_FILE_RUN2" -z y -b y -ba y -1 ""$FMAP_PHASE_RAW_RUN2""
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"_e1.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"1.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"_e1.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"1.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2".nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"1.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2".json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"1.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"_e2.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"2.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"_e2.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"2.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2"_e2.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2"_e2.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".json 2>/dev/null

    ##Extract two echo times
    M1=`find ""$FMAP_MAG_FILE_RUN2"" \( -iname "*.dcm" -o -iname "*.ima" \) | sort | head -1`
    M2=`find ""$FMAP_MAG_FILE_RUN2"" \( -iname "*.dcm" -o -iname "*.ima" \) | sort | head -2 | tail -1`
    TE1=`mri_probedicom --i $M1 --t 0018 0081`
    TE2=`mri_probedicom --i $M2 --t 0018 0081`
    TE1=`bc -l <<< "${TE1}"/1000`
    TE2=`bc -l <<< "${TE2}"/1000`
    dTE=`bc -l <<< "1000*(${TE2} - ${TE1})"`
    TE1_rnd=`printf "%0.5f\n" $TE1` #is this still correct for aging study??
    TE2_rnd=`printf "%0.5f\n" $TE2` #is this still correct for aging study??
    dTE_rnd=`printf "%0.2f\n" $dTE` #is this still correct for aging study??

    ###Calculate Bandwidth per pixel phase encode
    BWpe=`mri_probedicom --i $M1 --t 0018 0095`
    ##Retrieve number of phase encoding lines
    dimpe=`mri_probedicom --i $M1 --t 0018 0089`
    ##Calculate Dwell Time/ Effective Echo Spacing
    dwell=`echo $BWpe $dimpe | awk '{print (1/($1*$2))}'`

    ##Add echo times to fieldmap json's
    #sed -i 's/\"EchoTime\"\: '${TE2_rnd}'/\"EchoTime1\"\: '${TE1_rnd}'\,\n\t"EchoTime2\"\: '${TE2_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"EchoTime\"\: '${TE2_rnd}'/\"EchoTime1\"\: '${TE1_rnd}'\,\n\t"EchoTime2\"\: '${TE2_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"EchoTime2\"\: '${TE2_rnd}'/\"EchoTime2\"\: '${TE2_rnd}'\,\n\t\"DwellTime\"\: '${dwell}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"DwellTime\"\: '${dwell}'/\"DwellTime\"\: '${dwell}'\,\n\t\"deltaEchoTime\"\: '${dTE_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    ##Add echo times to fieldmap json's
    sed -i 's/\"EchoTime\"\: '0.00765'/\"EchoTime1\"\: '0.00519'\,\n\t"EchoTime2\"\: '0.00765'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".json #is this still correct for aging study??
    sed -i 's/\"EchoTime2\"\: '0.00765'/\"EchoTime2\"\: '0.00765'\,\n\t\"DwellTime\"\: '4.57875e-05'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".json #is this still correct for aging study??
    sed -i 's/\"DwellTime\"\: '4.57875e-05'/\"DwellTime\"\: '4.57875e-05'\,\n\t\"deltaEchoTime\"\: '2.46'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".json #is this still correct for aging study??
  fi

  if [ ! -z ""$FMAP_MAG_FILE_RUN3"" ]; then
    echo -en "\n\n\nConverting RUN 3 magnitude fieldmap for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/" -f "$FMAP_MAG_FILE_RUN3" -z y -b y -ba y -1 ""$FMAP_MAG_RAW_RUN3""

    echo -en "\n\n\nConverting RUN 3 phase fieldmap for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/" -f "$FMAP_PHASE_FILE_RUN3" -z y -b y -ba y -1 ""$FMAP_PHASE_RAW_RUN3""
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"_e1.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"1.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"_e1.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"1.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3".nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"1.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3".json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"1.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"_e2.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"2.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"_e2.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"2.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3"_e2.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3"_e2.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".json 2>/dev/null
    ##Extract two echo times
    M1=`find ""$FMAP_MAG_FILE_RUN3"" \( -iname "*.dcm" -o -iname "*.ima" \) | sort | head -1`
    M2=`find ""$FMAP_MAG_FILE_RUN3"" \( -iname "*.dcm" -o -iname "*.ima" \) | sort | head -2 | tail -1`
    TE1=`mri_probedicom --i $M1 --t 0018 0081`
    TE2=`mri_probedicom --i $M2 --t 0018 0081`
    TE1=`bc -l <<< "${TE1}"/1000`
    TE2=`bc -l <<< "${TE2}"/1000`
    dTE=`bc -l <<< "1000*(${TE2} - ${TE1})"`
    TE1_rnd=`printf "%0.5f\n" $TE1` #is this still correct for aging study??
    TE2_rnd=`printf "%0.5f\n" $TE2` #is this still correct for aging study??
    dTE_rnd=`printf "%0.2f\n" $dTE` #is this still correct for aging study??

    ###Calculate Bandwidth per pixel phase encode
    BWpe=`mri_probedicom --i $M1 --t 0018 0095`
    ##Retrieve number of phase encoding lines
    dimpe=`mri_probedicom --i $M1 --t 0018 0089`
    ##Calculate Dwell Time/ Effective Echo Spacing
    dwell=`echo $BWpe $dimpe | awk '{print (1/($1*$2))}'`

    ##Add echo times to fieldmap json's
    #sed -i 's/\"EchoTime\"\: '${TE2_rnd}'/\"EchoTime1\"\: '${TE1_rnd}'\,\n\t"EchoTime2\"\: '${TE2_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"EchoTime\"\: '${TE2_rnd}'/\"EchoTime1\"\: '${TE1_rnd}'\,\n\t"EchoTime2\"\: '${TE2_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"EchoTime2\"\: '${TE2_rnd}'/\"EchoTime2\"\: '${TE2_rnd}'\,\n\t\"DwellTime\"\: '${dwell}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    #sed -i 's/\"DwellTime\"\: '${dwell}'/\"DwellTime\"\: '${dwell}'\,\n\t\"deltaEchoTime\"\: '${dTE_rnd}'/g' "$BIDS_DIR"/"sub-"$PARTIC""/"$VISIT_DIR"/fmap/"$FMAP_PHASE_FILE".json
    ##Add echo times to fieldmap json's
    sed -i 's/\"EchoTime\"\: '0.00765'/\"EchoTime1\"\: '0.00519'\,\n\t"EchoTime2\"\: '0.00765'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".json #is this still correct for aging study??
    sed -i 's/\"EchoTime2\"\: '0.00765'/\"EchoTime2\"\: '0.00765'\,\n\t\"DwellTime\"\: '4.57875e-05'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".json #is this still correct for aging study??
    sed -i 's/\"DwellTime\"\: '4.57875e-05'/\"DwellTime\"\: '4.57875e-05'\,\n\t\"deltaEchoTime\"\: '2.46'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".json #is this still correct for aging study??

  fi

  if [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"1.json" ]; then
      ##Add intendedfor to magnitude1, magnitude2, and phase
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"1.json"
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN1"2.json"
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN1".json"
      echo "true"
  fi

  if [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"1.json" ]; then
      ##Add intendedfor to magnitude1, magnitude2, and phase
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"1.json"
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN2"2.json"
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN2".json"
      echo "true"
  fi

  if [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"1.json" ]; then
      ##Add intendedfor to magnitude1, magnitude2, and phase
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"1.json"
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE_RUN3"2.json"
      python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE_RUN3".json"
      echo "true"
  fi
else
  echo "Single fieldmap detected. Exiting ..."

fi
