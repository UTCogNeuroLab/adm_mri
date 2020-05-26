## Preprocessing

1. Run main.sh
2. Inspect all subjects for model fit

## TBSS
We performed analyses separately for older adults and young adults. These analyses were therefore conducted independently in separate directories, tbss_oa and tbss_ya.

1. Move all FA and MD files from DTI preprocessing directory to a new tbss directory
2. We will later rename all the MD files as FA for future TBSS steps. Do not get these mixed up with the actual FA data!

%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa

ls -d ${dtifit_dir}/sub-3*/

%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
work_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives

mkdir ${work_dir}/tbss_ya
mkdir ${work_dir}/tbss_oa

for sub_dir in `ls -d ${dtifit_dir}/sub-3*/`; do
    subj=`echo "$sub_dir" | cut -d '-' -f 2 | rev | cut -c 2- | rev`
    echo $subj
    cp "$sub_dir"*FA.nii.gz ${work_dir}/tbss_ya/
done

for sub_dir in `ls -d ${dtifit_dir}/sub-4*/`; do
    subj=`echo "$sub_dir" | cut -d '-' -f 2 | rev | cut -c 2- | rev`
    echo $subj
    cp "$sub_dir"*FA.nii.gz ${work_dir}/tbss_oa/
done

### TBSS 1 Preprocessing
Erodes FA images and zeroes the end slices to remove likely outliers from the diffusion tensor fitting. Generates a report called slicesdir to allow for quick scanning to detect any major issues.

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
tbss_1_preproc *FA.nii.gz

%%bash

open -a "Google Chrome" /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya/FA/slicesdir/index.html

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
ls | head -5

tbss_1_preproc *FA.nii.gz

%%bash

open -a "Google Chrome" /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa/FA/slicesdir/index.html

### Note 02-20-2020
I removed subjects 30330, 30476, 30227, 40515, and 40516 from analysis due to artifact.

FLIRT version 6.0

### TBSS 2 Registration
Runs the nonlinear registration, aligning all FA images to a 1x1x1mm standard space. We will use the -n option, which aligns every FA image to every other one. In the next step, we will identify the "most representative" one, and use this as the target image. This target image is then affine-aligned into MNI152 standard space, and every image is transformed into 1x1x1mm MNI152 space by combining the nonlinear transform to the target FA image with the affine transform from that target to MNI152 space.

This is highly computationally intensive, so we will run this on TACC to speed things up.

From your local machine, enter this command to move the TBSS directories to TACC. You will need to enter your TACC password and verification code to complete the file transfer.

`scp -r /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya username@stampede2.tacc.utexas.edu:/path/to/destination/`

`scp -r /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa username@stampede2.tacc.utexas.edu:/path/to/destination/`

Log into TACC using `ssh username@stampede2.tacc.utexas.edu`.

`cd path/to/destination/tbss_ya`

From a login node, run the tbss_2_reg command: <br>
`tbss_2_reg -n`. 

Do the same for older adults: <br>
`cd path/to/destination/tbss_oa`

From a login node, run the tbss_2_reg command: <br>
`tbss_2_reg -n`

This will submit 2 jobs to the queue. You can check the status of the jobs with `squeue -u username`. Wait for them to complete before moving forward.

A quick check to make sure it ran properly is: <br>
`ls tbss_ya/sub-30020* | wc -l`

For one subject, there should be (N subjects * 4) + 2 (FA and FA mask) files. In this case, we have 49 subjects, and 198 files.


### TBSS 3 Post-registration
Applies the nonlinear transforms found in the previous stage to all subjects to bring them into standard space.
This will first make the decision about which of the FA images is the most "typical", for selection as the target image to apply all nonlinear transformations into the space of. This happens by taking each FA image in turn, and estimating the average amount of warping that was necessary to align all other images to it, then finding the one that had the smallest amount of average warping when used as a target.

From the login node on TACC:

`cd /path/to/destination/tbss_ya` <br>
`tbss_3_postreg -S`

`cd /path/to/destination/tbss_oa` <br>
`tbss_3_postreg -S`

We will get a message about what the best target subject is for each group. In this case, that was: <br>

```bash

best target is sub-40782_dti_FA_FA - now registering this to standard space

best target is sub-30255_dti_FA_FA - now registering this to standard space
```

When that finishes up, we will need to transfer the results back to the local machine for inspection and to continue with analysis.

From your local machine, this can be done with:

`scp -r username@stampede2.tacc.utexas.edu:/path/to/destination/tbss_ya /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/`

`scp -r username@stampede2.tacc.utexas.edu:/path/to/destination/tbss_oa /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/ `

Again, you will need your TACC password and the verification code.

### QA

Now check all_FA and mean_FA_mask for any outliers or artifacts.

We restricted mean_FA_mask values to values between 0.2 and 1, since the mask output from tbss_3_postreg covers more than the white matter. This will reduce the area used in permutation testing with TFCE and increase the power of our analysis.

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa/stats
fslmaths mean_FA -thr 0.2 -uthr 1 -bin mean_FA_mask_thr20.nii.gz
fslmaths mean_FA -thr 0.22 -uthr 1 -bin mean_FA_mask_thr22.nii.gz
fslmaths mean_FA -thr 0.3 -uthr 1 -bin mean_FA_mask_thr30.nii.gz

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya/stats
fslmaths mean_FA -thr 0.2 -uthr 1 -bin mean_FA_mask_thr20.nii.gz
fslmaths mean_FA -thr 0.22 -uthr 1 -bin mean_FA_mask_thr22.nii.gz
fslmaths mean_FA -thr 0.3 -uthr 1 -bin mean_FA_mask_thr30.nii.gz

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa/stats
fsleyes all_FA -b 0,0.8 mean_FA_skeleton -b 0.2,0.8 -l Green &

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
tbss_4_prestats 0.22 #replace 0.2 if need to change it

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
tbss_4_prestats 0.22 #replace 0.2 if need to change it

Now we're going to run TBSS on the MD, AD, and RD data

%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa

mkdir ${tbss_dir}/MD
mkdir ${tbss_dir}/AD
mkdir ${tbss_dir}/RD

for sub_dir in ${dtifit_dir}/sub-4*/; do
    subj=`echo "$sub_dir" | cut -d '-' -f 2 | rev | cut -c 2- | rev`
    echo $subj
    cp "$sub_dir"*_MD.nii.gz ${tbss_dir}/MD/
    cp "$sub_dir"*_L1.nii.gz ${tbss_dir}/AD/
    fslmaths ${sub_dir}*_L2.nii.gz -add ${sub_dir}*_L3.nii.gz -div 2 ${tbss_dir}/RD/sub-${subj}_dti_RD.nii.gz
done

%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya

mkdir ${tbss_dir}/MD
mkdir ${tbss_dir}/AD
mkdir ${tbss_dir}/RD

for sub_dir in ${dtifit_dir}/sub-3*/; do
    subj=`echo "$sub_dir" | cut -d '-' -f 2 | rev | cut -c 2- | rev`
    echo $subj
    cp "$sub_dir"*_MD.nii.gz ${tbss_dir}/MD/
    cp "$sub_dir"*_L1.nii.gz ${tbss_dir}/AD/
    fslmaths ${sub_dir}*_L2.nii.gz -add ${sub_dir}*_L3.nii.gz -div 2 ${tbss_dir}/RD/sub-${subj}_dti_RD.nii.gz
done

%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa

cd ${tbss_dir}/MD/
for file in `ls ${tbss_dir}/MD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

cd ${tbss_dir}/AD/
for file in `ls ${tbss_dir}/AD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

cd ${tbss_dir}/RD/
for file in `ls ${tbss_dir}/RD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya

cd ${tbss_dir}/MD/
for file in `ls ${tbss_dir}/MD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

cd ${tbss_dir}/AD/
for file in `ls ${tbss_dir}/AD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

cd ${tbss_dir}/RD/
for file in `ls ${tbss_dir}/RD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

To run the tbss_non_FA script, I had to make one modification to get it to work:

```bash

#for f in `$FSLDIR/bin/imglob *_FA.*` ; do #edited MCM 02-21-2020
for f in  `$FSLDIR/bin/imglob *_FA.nii* *_FA.img* *_FA.hdr*`; do
```

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
#tbss_non_FA MD
#tbss_non_FA AD
tbss_non_FA RD

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
tbss_non_FA MD
tbss_non_FA AD
tbss_non_FA RD

## Extract mean FA, MD, AD, RD in ROI

%%bash

tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
cd ${tbss_dir}/roi
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 ${tbss_dir}/roi/cc.nii.gz
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 3 ${tbss_dir}/roi/genu.nii.gz

tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
cd ${tbss_dir}/roi
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 ${tbss_dir}/roi/cc.nii.gz
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 3 ${tbss_dir}/roi/genu.nii.gz



%%bash
# cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
# for mask in `ls ../../roi`; do
# fslmeants -i all_FA_skeletonised -m ${mask} -o ${mask}-meants.txt
# done

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
for mask in `ls ../../roi`; do
echo `fslmeants -i all_FA_skeletonised -m ${mask} -o ${mask}"-meants".txt`
done
