# Preprocessing

Using data collected on a Siemens Skyra 3T, we convert DICOMS to NIFTI, organize data into BIDS format, use MRIQC for quality analysis, and run fMRIprep for minimal preprocessing.

The following commands are given as an example for subject number 30000. 

## Download raw scan data from Osirix

The directory containing raw scan data should be moved to `/Volumes/schnyer/Aging_DecMem/Scan_Data/RAW`.

## BIDS conversion

1. BIDS conversion with Heudiconv

**CURRENTLY TESTING**

`docker run --rm -it -v /Volumes/schnyer/Aging_DecMem/Scan_Data:/base nipy/heudiconv:latest -d /base/RAW/Adm-{subject}/*/*/*.dcm -o /base/BIDS/ -f convertall -s 30000 -c none --overwrite`

2. Convert fieldmaps

`sh bids_conversion/fix_fmaps.sh`

3. BIDS Validator
Upload the BIDS directory to the [BIDS Validator website](http://bids-standard.github.io/bids-validator/) and check to make sure there are no errors.

## mriqc
Requires [Docker](https://docs.docker.com/engine/installation/).\
Documentation available [here](https://mriqc.readthedocs.io/en/stable/docker.html).

To run mriqc:

*Participant level command*\
Currently using a fd threshold of 0.25 mm for rsfMRI and 0.50 mm for task fMRI

```
docker run -it --rm -v /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/:/data:ro -v /Volumes/schnyer/Aging_DecMem/Scan_Data/MRIQC/:/out poldracklab/mriqc:0.9.10 /data /out participant --fd_thres 0.25 --no-sub -vvv --participant_label 30000 
```
*Group level command*

```
docker run -it --rm -v /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/:/data:ro -v /Volumes/schnyer/Aging_DecMem/Scan_Data/MRIQC/:/out poldracklab/mriqc:0.9.10 /data /out group -m {T1w,bold} 
```

#### Update excel sheet with information about scan quality
Review group mriqc report and copy values to the Google Sheet, which is available at `/Volumes/schnyer/Aging_DecMem/Scan_Data/AgingDataProgress.xlsx`

## fmriprep
Requires [Docker](https://docs.docker.com/engine/installation/).\
You will need to specify the path to a freesufer license file. If you do not already have a freesurfer license, you can obtain one [here](https://surfer.nmr.mgh.harvard.edu/fswiki/License).

[Installation instructions](https://fmriprep.readthedocs.io/en/stable/installation.html)

To install fmriprep:

```
pip install --user --upgrade fmriprep-docker
```
To run fmriprep:

```
export FS_LICENSE=/Users/PSYC-mcm5324/Applications/freesurfer/license.txt
fmriprep-docker /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/     /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/fmriprep/     participant -w Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/ --notrack --ignore slicetiming -v --participant_label 30000
```
