#!/bin/bash
#set -x
## This script is to add the "Intended for:" lines on fieldmap json files that have already been collected
## by KLRay, Joyce Zhang, and Megan McMahon

export WORKING_DIR=/Volumes/schnyer/Aging_DecMem
export SOURCE_DIR=$WORKING_DIR/Scan_Data/RAW
export BIDS_DIR=$WORKING_DIR/Scan_Data/BIDS


##Choose Participant
#echo -en '\n'
#echo "Which participant?"
#read PARTIC

PARTIC=$1

#FMAP_MAG_FILE="sub-"$PARTIC""_magnitude



for i in {1,2,3,4}

do
  FMAP_MAG_FILE="sub-"$PARTIC""_run-0"$i"_magnitude
  FMAP_PHASE_FILE="sub-"$PARTIC""_run-0"$i"_phasediff



if [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json" ] && [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json" ] && [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json" ]; then

  if [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/sub-"$PARTIC""_run-02_magnitude"1.json" ]; then
    if [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/sub-"$PARTIC""_run-0"$((i+1))"_magnitude"1.json" ]; then
      python3 /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/joytest2.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json" ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/sub-"$PARTIC""_run-0"$((i+1))"_magnitude"1.json"
      python3 /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/CopyMag1.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json" ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json"
      python3 /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/CopyMag1.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json" ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json"
      echo "Multiple fieldmap $i"
    else
      python3 /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/joytest2.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json" ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/sub-"$PARTIC""_run-0"$((i-1))"_magnitude"1.json"
      python3 /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/joytest2.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json" ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/sub-"$PARTIC""_run-0"$((i-1))"_magnitude"1.json"
      python3 /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/joytest2.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json" ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/sub-"$PARTIC""_run-0"$((i-1))"_magnitude"1.json"
      echo "Multiple fieldmap $i"
    fi

  else
    python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json"
    python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json"
    python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json"

    echo "Single fieldmap"
  fi



  echo "true"
fi
done



#if [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json" ] && [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json" ] && [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json" ]; then
    ##Add intendedfor to magnitude1, magnitude2, and phase

    #python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/*.*.json"

    # python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json"
    # python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json"
    #
    # python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json"
    # python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json"
    # python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json"
    #
    # python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json"
    # python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json"
    # python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json"

    #echo "true"
#fi
