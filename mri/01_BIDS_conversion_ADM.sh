at#!/bin/bash
#set -x
##BIDS conversion script for ADM neuroimaging data
##@derek pisner - modified by KLRay

export WORKING_DIR=/Volumes/schnyer/Aging_DecMem
export SOURCE_DIR=$WORKING_DIR/Scan_Data/RAW
export BIDS_DIR=$WORKING_DIR/Scan_Data/BIDS
export DERIVATIVES_DIR=$WORKING_DIR/Scan_Data/derivatives
export PYDEFACEPATH="/Users/PSYC-mcm5324/pydeface/scripts"
#export PYDEFACEPATH="/Users/PSYC-klr3342/Applications/pydeface/scripts"
#export PYDEFACEPATH="/Users/PSYC-dap3463/pydeface/scripts"

##Choose Participant
# echo -en '\n'
# echo "Which participant?"
# read PARTIC
PARTIC=$1

##Choose Visit
#echo -en '\n'
#echo "Which visit? (1=Baseline, 2=Mid-training, 3=Post-training)"
#read VISIT

##Set visit directory
#if [[ $VISIT == 1 ]]; then
#    VISIT_DIR='ses-01'
#elif [[ $VISIT == 2 ]]; then
#    VISIT_DIR='ses-02'
#elif [[ $VISIT == 3 ]]; then
#    VISIT_DIR='ses-03'
#fi

##Find raw dicom directories
ANAT_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*MPRAGE_RMS*' -not -iname '*SBREF*' -print | sort -r | tail -1`
FMAP_MAG_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING*' -print | sort -r | tail -1`
FMAP_PHASE_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*FIELD_MAPPING*' -print | sort | tail -1`
DWI_SHELL1_AP_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*CMRR_DTI_UCSF_71AP*' -not -iname '*SBREF*' -print | sort -r | tail -1`
DWI_SHELL1_PA_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*CMRR_DTI_UCSF_71PA*' -not -iname '*SBREF*' -print | sort -r | tail -1`
FUNC_REST1_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*RESTINGSTATE*' -not -iname '*SBREF*' -print | sort -r | tail -1`
FUNC_MemMatch1_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*MEMMATCH_RUN_1*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_MemMatch2_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*MEMMATCH_RUN_2*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_MemMatch3_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*MEMMATCH_RUN_3*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_MemRepeat1_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*MEMREPEAT_RUN_1*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_MemRepeat2_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*MEMREPEAT_RUN_2*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_MemRepeat3_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*MEMREPEAT_RUN_3*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_CSGT1_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*CSGT_RUN1*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_CSGT2_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*CSGT_RUN2*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_PHD1_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*PHD_RUN1*' -not -iname '*SBREF*' -print | sort | tail -1`
FUNC_PHD2_RAW=`find "$SOURCE_DIR"/"$PARTIC" -maxdepth 1 -iname '*PHD_RUN2*' -not -iname '*SBREF*' -print | sort | tail -1`

##Create BIDS filenames
ANAT_FILE="sub-"$PARTIC"_acq-MPRAGE_T1w"
FMAP_MAG_FILE="sub-"$PARTIC""_run-01_magnitude
FMAP_PHASE_FILE="sub-"$PARTIC""_run-01_phasediff
FUNC_REST1_FILE="sub-"$PARTIC""_task-REST_run-01_bold
FUNC_MemMatch1_FILE="sub-"$PARTIC""_task-MemMatch1_run-01_bold
FUNC_MemMatch2_FILE="sub-"$PARTIC""_task-MemMatch2_run-01_bold
FUNC_MemMatch3_FILE="sub-"$PARTIC""_task-MemMatch3_run-01_bold
FUNC_MemRepeat1_FILE="sub-"$PARTIC""_task-MemRepeat1_run-01_bold
FUNC_MemRepeat2_FILE="sub-"$PARTIC""_task-MemRepeat2_run-01_bold
FUNC_MemRepeat3_FILE="sub-"$PARTIC""_task-MemRepeat3_run-01_bold
FUNC_CSGT1_FILE="sub-"$PARTIC""_task-CSGT1_run-01_bold
FUNC_CSGT2_FILE="sub-"$PARTIC""_task-CSGT2_run-01_bold
FUNC_PHD1_FILE="sub-"$PARTIC""_task-PHD1_run-01_bold
FUNC_PHD2_FILE="sub-"$PARTIC""_task-PHD2_run-01_bold
DWI_SHELL1_AP_FILE="sub-"$PARTIC""_acq-71AP_dwi
DWI_SHELL1_PA_FILE="sub-"$PARTIC""_acq-71PA_dwi


##Create BIDS formatted directories
#Diffusion
if [ ! -d "$BIDS_DIR"/"sub-"$PARTIC""/dwi ] && [[ ( "$DWI_SHELL1_AP_RAW" != '' && "$DWI_SHELL1_PA_RAW" != '' ) || ( "$DWI_SHELL2_AP_RAW" != '' && "$DWI_SHELL2_PA_RAW" != '' ) || ( "$DWI_SHELL3_AP_RAW" != '' && "$DWI_SHELL3_PA_RAW" != '' ) ]]; then
    mkdir -p "$BIDS_DIR"/"sub-"$PARTIC""/dwi
fi

#Anatomical
if [ ! -d "$BIDS_DIR"/"sub-"$PARTIC""/anat ] && [ ! -z "$ANAT_RAW" ]; then
    mkdir -p "$BIDS_DIR"/"sub-"$PARTIC""/anat
elif [ -z "$ANAT_RAW" ]; then
    echo -en "\n\n\nAnatomical acquisition is missing for "$PARTIC"!\n\n\n"
fi

#Fieldmaps
if [ ! -d "$BIDS_DIR"/"sub-"$PARTIC""/fmap ] && [ ! -z "$FMAP_MAG_RAW" ] && [ ! -z "$FMAP_PHASE_RAW" ]; then
    mkdir -p "$BIDS_DIR"/"sub-"$PARTIC""/fmap
elif [ -z "$FMAP_MAG_RAW" ]; then
    echo -en "\n\n\nMagnitude fieldmap acquisition is missing for "$PARTIC"!\n\n\n"
elif [ -z "$FMAP_PHASE_RAW" ]; then
    echo -en "\n\n\nPhase fieldmap acquisition is missing for "$PARTIC"!\n\n\n"
fi

#Functional
if [ ! -d "$BIDS_DIR"/"sub-"$PARTIC""/func ]; then
    mkdir -p "$BIDS_DIR"/"sub-"$PARTIC""/func
fi

##Alert for missing Rest
if [ -z "$FUNC_REST1_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition REST 1 is missing for "$PARTIC"!\n\n\n"
fi

##Alert for missing Tasks
if [ -z "$FUNC_MemMatch1_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition MemMatch1 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_MemMatch2_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition MemMatch2 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_MemMatch3_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition MemMatch3 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_MemRepeat1_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition MemRepeat1 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_MemRepeat2_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition MemRepeat2 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_MemRepeat3_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition MemRepeat3 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_PHD1_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition PHD 1 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_PHD2_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition PHD 2 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_CSGT1_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition CSGT 1 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$FUNC_CSGT2_FILE" ]; then
    echo -en "\n\n\nFunctional acquisition CSGT 2 is missing for "$PARTIC"!\n\n\n"
fi

##Alert for missing dwi
if [ -z "$DWI_SHELL1_AP_RAW"_FILE ]; then
    echo -en "\n\n\nDiffusion acquisition AP SHELL 1 is missing for "$PARTIC"!\n\n\n"
fi
if [ -z "$DWI_SHELL1_PA_RAW"_FILE ]; then
    echo -en "\n\n\nDiffusion acquisition PA SHELL 1 is missing for "$PARTIC"!\n\n\n"
fi

if [ -z "$ANAT_RAW" ] && [ -z "$FMAP_PHASE_RAW" ] && [ -z $FMAP_PHASE_MAG ] && [ -z "$FUNC_REST1_FILE" ] && [ -z $FUNC_REST2_FILE ] && [ -z $FUNC_SART1_FILE  ] &&  [ -z $FUNC_SART2_FILE ] && [ -z $FUNC_SART3_FILE ] && [ -z $FUNC_SART4_FILE  ] && [ -z "$DWI_SHELL1_AP_RAW" ] && [ -z "$DWI_SHELL1_PA_RAW" ] && [ -z "$DWI_SHELL2_AP_RAW" ] && [ -z "$DWI_SHELL2_PA_RAW" ] && [ -z "$DWI_SHELL3_AP_RAW" ] && -z "$DWI_SHELL3_PA_RAW" ]; then
    echo -en "\n\n\nALL ACQUISITIONS MISSING FOR "$PARTIC"! Exiting..."
    exit 0
fi

##Convert dicoms to nifti
##Convert DWI Shell 1 AP dicoms
if [ ! -z ""$DWI_SHELL1_AP_RAW"" ]; then
    echo -en "\n\n\nConverting diffusion acquisition AP SHELL 1 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/dwi" -f "$DWI_SHELL1_AP_FILE" -z y -b y -ba y -1 ""$DWI_SHELL1_AP_RAW""
fi

##Convert DWI Shell 1 PA dicoms
if [ ! -z ""$DWI_SHELL1_PA_RAW"" ]; then
    echo -en "\n\n\nConverting diffusion acquisition PA SHELL 1 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/dwi" -f "$DWI_SHELL1_PA_FILE" -z y -b y -ba y -1 ""$DWI_SHELL1_PA_RAW""
fi

##Convert ANAT dicoms
if [ ! -z ""$ANAT_RAW"" ]; then
    echo -en "\n\n\nConverting anatomical for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/anat" -f "$ANAT_FILE" -z y -b y -ba y -1 ""$ANAT_RAW""

    ##Correct json file
    cd "$BIDS_DIR"/"sub-"$PARTIC""/anat
    echo -en "\n\n\nDefacing anatomical for "$PARTIC"...\n\n\n"
    #python3 "$PYDEFACEPATH"/pydeface.py "$ANAT_FILE".nii.gz
    pydeface.py "$ANAT_FILE".nii.gz
    ANAT_FILE_prefix=`echo $ANAT_FILE.nii.gz | cut -f1 -d .`
    rm "$ANAT_FILE".nii.gz 2>/dev/null
    mv "$ANAT_FILE_prefix"_defaced.nii.gz "$ANAT_FILE".nii.gz 2>/dev/null
fi

##Convert FMAP Mag dicoms
if [ ! -z ""$FMAP_MAG_RAW"" ] && [ ! -z ""$FMAP_PHASE_RAW"" ]; then
    echo -en "\n\n\nConverting magnitude fieldmap for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/" -f "$FMAP_MAG_FILE" -z y -b y -ba y -1 ""$FMAP_MAG_RAW""

    ##Convert FMAP Phase dicoms
    echo -en "\n\n\nConverting phase fieldmap for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/" -f "$FMAP_PHASE_FILE" -z y -b y -ba y -1 ""$FMAP_PHASE_RAW""

    ##Fix weird naming
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"_e1.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"_e1.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE".nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE".json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"_e2.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"_e2.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE"_e1.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE"_e1.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE"_e2.nii.gz "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".nii.gz 2>/dev/null
    mv "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE"_e2.json "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json 2>/dev/null

    ##Extract two echo times
    M1=`find ""$FMAP_MAG_RAW"" \( -iname "*.dcm" -o -iname "*.ima" \) | sort | head -1`
    M2=`find ""$FMAP_MAG_RAW"" \( -iname "*.dcm" -o -iname "*.ima" \) | sort | head -2 | tail -1`
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
    sed -i 's/\"EchoTime\"\: '0.00765'/\"EchoTime1\"\: '0.00519'\,\n\t"EchoTime2\"\: '0.00765'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json #is this still correct for aging study??
    sed -i 's/\"EchoTime2\"\: '0.00765'/\"EchoTime2\"\: '0.00765'\,\n\t\"DwellTime\"\: '4.57875e-05'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json #is this still correct for aging study??
    sed -i 's/\"DwellTime\"\: '4.57875e-05'/\"DwellTime\"\: '4.57875e-05'\,\n\t\"deltaEchoTime\"\: '2.46'/g' "$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json #is this still correct for aging study??
fi

##Convert FUNC Rest1 dicoms
if [ ! -z "$FUNC_REST1_RAW" ]; then
    echo -en "\n\n\nConverting functional REST 1 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_REST1_FILE"" -z y -b y -ba y -1 "$FUNC_REST1_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_restingstate\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_restingstate\"\,\n\t\"TaskName\"\: \"REST1\"/g' ""$FUNC_REST1_FILE"".json
fi


##Convert FUNC MemMatch dicoms
if [ ! -z "$FUNC_MemMatch1_RAW" ]; then
    echo -en "\n\n\nConverting functional MemMatch 1 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_MemMatch1_FILE"" -z y -b y -ba y -1 "$FUNC_MemMatch1_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemMatch_Run_1\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemMatch_Run_1\"\,\n\t\"TaskName\"\: \"MemMatch1\"/g' ""$FUNC_MemMatch1_FILE"".json
fi
if [ ! -z "$FUNC_MemMatch2_RAW" ]; then
    echo -en "\n\n\nConverting functional MemMatch 2 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_MemMatch2_FILE"" -z y -b y -ba y -1 "$FUNC_MemMatch2_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemMatch_Run_2\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemMatch_Run_2\"\,\n\t\"TaskName\"\: \"MemMatch2\"/g' ""$FUNC_MemMatch2_FILE"".json
fi
if [ ! -z "$FUNC_MemMatch3_RAW" ]; then
    echo -en "\n\n\nConverting functional MemMatch 3 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_MemMatch3_FILE"" -z y -b y -ba y -1 "$FUNC_MemMatch3_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemMatch_Run_3\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemMatch_Run_3\"\,\n\t\"TaskName\"\: \"MemMatch3\"/g' ""$FUNC_MemMatch3_FILE"".json
fi
##Convert FUNC MemRepeat dicoms
if [ ! -z "$FUNC_MemRepeat1_RAW" ]; then
    echo -en "\n\n\nConverting functional MemRepeat 1 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_MemRepeat1_FILE"" -z y -b y -ba y -1 "$FUNC_MemRepeat1_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemRepeat_Run_1\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemRepeat_Run_1\"\,\n\t\"TaskName\"\: \"MemRepeat1\"/g' ""$FUNC_MemRepeat1_FILE"".json
fi
if [ ! -z "$FUNC_MemRepeat2_RAW" ]; then
    echo -en "\n\n\nConverting functional MemRepeat 2 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_MemRepeat2_FILE"" -z y -b y -ba y -1 "$FUNC_MemRepeat2_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemRepeat_Run_2\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemRepeat_Run_2\"\,\n\t\"TaskName\"\: \"MemRepeat2\"/g' ""$FUNC_MemRepeat2_FILE"".json
fi
if [ ! -z "$FUNC_MemRepeat3_RAW" ]; then
    echo -en "\n\n\nConverting functional MemRepeat 3 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_MemRepeat3_FILE"" -z y -b y -ba y -1 "$FUNC_MemRepeat3_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemRepeat_Run_3\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_MemRepeat_Run_3\"\,\n\t\"TaskName\"\: \"MemRepeat3\"/g' ""$FUNC_MemRepeat3_FILE"".json
fi
##Convert FUNC CSGT dicoms
if [ ! -z "$FUNC_CSGT1_RAW" ]; then
    echo -en "\n\n\nConverting functional CSGT 1 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_CSGT1_FILE"" -z y -b y -ba y -1 "$FUNC_CSGT1_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_CSGT_run1\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_CSGT_run1\"\,\n\t\"TaskName\"\: \"CSGT-RUN1\"/g' ""$FUNC_CSGT1_FILE"".json
fi
if [ ! -z "$FUNC_CSGT2_RAW" ]; then
    echo -en "\n\n\nConverting functional CSGT 2 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_CSGT2_FILE"" -z y -b y -ba y -1 "$FUNC_CSGT2_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_CSGT_run2\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_CSGT_run2\"\,\n\t\"TaskName\"\: \"CSGT-RUN2\"/g' ""$FUNC_CSGT2_FILE"".json
fi
##Convert FUNC PHD dicoms
if [ ! -z "$FUNC_PHD1_RAW" ]; then
    echo -en "\n\n\nConverting functional PHD 1 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_PHD1_FILE"" -z y -b y -ba y -1 "$FUNC_PHD1_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_PHD_run1\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_PHD_run1\"\,\n\t\"TaskName\"\: \"PHD-RUN1\"/g' ""$FUNC_PHD1_FILE"".json
fi
if [ ! -z "$FUNC_PHD2_RAW" ]; then
    echo -en "\n\n\nConverting functional PHD 2 for "$PARTIC"...\n\n\n"
    dcm2niix -o ""$BIDS_DIR"/"sub-"$PARTIC""/func" -f ""$FUNC_PHD2_FILE"" -z y -b y -ba y -1 "$FUNC_PHD2_RAW"
    cd "$BIDS_DIR"/"sub-"$PARTIC""/func
    sed -i 's/\"ProtocolName\"\: \"fMRI_32Chan_2X2_PHD_run2\"/\"ProtocolName\"\: \"fMRI_32Chan_2X2_PHD_run2\"\,\n\t\"TaskName\"\: \"PHD-RUN2\"/g' ""$FUNC_PHD2_FILE"".json
fi
# Modeified 03.13.2019
#ADDINTENDFOR FOR Fieldmaps
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
#Modified 09.16.2018
#if [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json" ] && [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json" ] && [ -f ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json" ]; then
    ##Add intendedfor to magnitude1, magnitude2, and phase
    #python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"1.json"
    #python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_MAG_FILE"2.json"
    #python3 /usr/local/bin/fieldmap_intendedfor_ADM.py ""$BIDS_DIR"/"sub-"$PARTIC""/fmap/"$FMAP_PHASE_FILE".json"
    #echo "true"
#fi
