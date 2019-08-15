# Preprocessing

Using data collected on a Siemens Skyra 3T, we convert DICOMS to NIFTI, organize data into BIDS format, use MRIQC for quality analysis, and run fMRIprep for minimal preprocessing.

The following commands are given as an example for subject number 30004.

Make sure subject's raw DICOM files are in ~/Scan_Data/RAW/{subject ID}

## BIDS conversion

Open Terminal and run:

```
sh /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/01_BIDS_conversion_ADM.sh 30004
```

#### Rename DICOM folders if subject had multiple fieldmaps

Go to the subject's raw file directory ~/Scan_Data/RAW/{subject ID} and check for instances where there are more than 2 FIELD_MAPPING directories.\

If there are more than 2, each of these FIELD_MAPPING directories will need to be renamed such that the first two corresponding to the first fieldmap are called "FIELD_MAPPING_RUN1_0004" and "FIELD_MAPPING_RUN1_0005", the second two directories corresponding to the second fieldmap are called "FIELD_MAPPING_RUN2_0015" and ""FIELD_MAPPING_RUN2_0016".\

Note that the number suffixes should *not* change (these numbers given here are just for an example :) ).

#### DICOM to NIFTI conversion for multiple fieldmaps

In Terminal, run:

```
/Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/02_BIDS_multfmaps.sh 30004
```

#### Add "Intended for" to fieldmap json files
This documents which functional files correspond to each fieldmap.

In Terminal, run:

```
sh /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/03_BIDS_intendedfor.sh 30004
```

## BIDS Validator
Upload the BIDS directory to the [BIDS Validator website](http://bids-standard.github.io/bids-validator/) and check to make sure there are no errors.

## mriqc
Requires [Docker](https://docs.docker.com/engine/installation/).\
Documentation available [here](https://mriqc.readthedocs.io/en/stable/docker.html).

To run mriqc:

*Participant level command*\
Currently using a fd threshold of 0.25 mm for rsfMRI and 0.50 mm for task fMRI

```
docker run -it --rm -v /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/:/data:ro -v /Volumes/schnyer/Aging_DecMem/Scan_Data/MRIQC/:/out poldracklab/mriqc:0.9.10 /data /out participant --fd_thres 0.25 --no-sub -vvv --participant_label 30004 
```
*Group level command*

```
docker run -it --rm -v /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/:/data:ro -v /Volumes/schnyer/Aging_DecMem/Scan_Data/MRIQC/:/out poldracklab/mriqc:0.9.10 /data /out group -m {T1w,bold} 
```

#### Update excel sheet with information about scan quality
Review group mriqc report and copy values to ~/Scan_Data/AgingDataProgress.xlsx

## fmriprep
Requires [Docker](https://docs.docker.com/engine/installation/).\
You will need to specify the path to a freesufer license file. If you do not already have a freesurfer license, you can obtain one [here](https://surfer.nmr.mgh.harvard.edu/fswiki/License).

[Installation instructions](https://fmriprep.readthedocs.io/en/stable/installation.html)

To install fmriprep:

```
pip install --user --upgrade fmriprep-docker
```
To run fmriprep:

In Terminal, run:
```
export FS_LICENSE=/Users/PSYC-mcm5324/Applications/freesurfer/license.txt
fmriprep-docker /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/     /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/fmriprep/     participant -w Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/ --notrack --ignore slicetiming -v --participant_label 30004
```
