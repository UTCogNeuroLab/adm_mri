# TBSS Analysis Procedures

## DTI Preprocessing

main.sh

Inspect all subjects for model fit

Move FA results from DTI preprocessing to new tbss directory

for sub_dir in /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/*/
do
  cp "$sub_dir"*FA.nii.gz /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/
  #find $sub_dir -type f | echo `grep -i *FA.nii.gz` #| cp {} /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss
done

Move MD to new tbss directory and will need to rename as FA so that later steps work. Do not get these mixed up with the actual FA data!

for sub_dir in /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/*/
do
  cp "$sub_dir"*MD.nii.gz /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/MD/
  #find $sub_dir -type f | echo `grep -i *FA.nii.gz` #| cp {} /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss
done

for file in `ls /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/MD/`
do
  partic=`echo "$file" | cut -c5-9`
  echo $partic
  mv "$file" "sub-${partic}_dti_FA.nii.gz"
done

## TBSS 

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old_1
ls

tbss_1_preproc *FA.nii.gz

open -a "Google Chrome" /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old_1/FA/slicesdir/index.html

#tbss_2_reg -T
tbss_2_reg -n

tbss_3_postreg -S 

cd stats
fsleyes all_FA -b 0,0.8 mean_FA_skeleton -b 0.2,0.8 -l Green &

Restricting mean_FA_mask values to values between 0.2 and 1, since the mask output from tbss_3_postreg covers more than the white matter. This will reduce the area used in permutation testing with TFCE and increase the power of our analysis.

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old_1/stats
fslmaths mean_FA -thr 0.2 -uthr 1 -bin mean_FA_mask_thr.nii.gz

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old_1/stats
fslmaths mean_FA -thr 0.22 -uthr 1 -bin mean_FA_mask_thr22.nii.gz

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_young_1/stats
fslmaths mean_FA -thr 0.2 -uthr 1 -bin mean_FA_mask_thr.nii.gz

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_young_1/stats
fslmaths mean_FA -thr 0.22 -uthr 1 -bin mean_FA_mask_thr22.nii.gz

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old_1/stats
tbss_4_prestats 0.22 #replace 0.2 if need to change it

cd ../stats

## Modeling

### Steps:
1. Create design matrices and contrasts in Excel, then copy and paste into .txt files
2. Use Text2Vest to reformat for tbss

#### Create design matrices and contrasts for each age group independently in Excel, then copy and paste into .txt files
Excel tip: absolute cell reference shortcut is cmd + t on mac

Design matrix = \[ actalph-AVERAGE(actalph) \]

Contrasts = \[0 1\], \[0,-1\]

Save contrasts to .txt file in tbss directory


#### Use Text2Vest to reformat for tbss

#Older adults

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/stats

Text2Vest design_age_alpha.txt design_age_alpha.mat
Text2Vest design_age_CR.txt design_age_CR.con

#Young adults

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_young/stats

Text2Vest design_age_alpha.txt design_age_alpha.mat

Check design matrices and contrasts by opening them with TextEdit. (Drag file to TextEdit icon in dock)

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/stats

randomise -i all_FA -o tbss_old_age_d -m mean_FA_mask -d design_age_d.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_old_alpha_d -m mean_FA_mask -d design_alpha_d.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_old_IS_d -m mean_FA_mask -d design_IS_d.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_old_IV -m mean_FA_mask -d design_IV_d.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_old_RA -m mean_FA_mask -d design_RA_d.mat -t design_CR.con -n 500 --T2 -D

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_young/stats

randomise -i all_FA -o tbss_young_age_alpha -m mean_FA_mask -d design_age_alpha.mat -t design_age_CR.con -n 500 --T2
randomise -i all_FA -o tbss_young_age_IS -m mean_FA_mask -d design_age_IS.mat -t design_age_CR.con -n 500 --T2
randomise -i all_FA -o tbss_young_age_IV -m mean_FA_mask -d design_age_IV.mat -t design_age_CR.con -n 500 --T2
randomise -i all_FA -o tbss_young_age_RA -m mean_FA_mask -d design_age_RA.mat -t design_age_CR.con -n 500 --T2

## New design matrices

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old_1/stats

randomise -i all_FA -o tbss_oa_IS_0218 -m mean_FA_mask_thr22 -d design_IS_0218.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_oa_IV_0218 -m mean_FA_mask_thr22 -d design_IV_0218.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_oa_RA_0218 -m mean_FA_mask_thr22 -d design_RA_0218.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_oa_alpha_0218 -m mean_FA_mask_thr22 -d design_alpha_0218.mat -t design_CR.con -n 500 --T2 -D


cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_young_1/stats

randomise -i all_FA -o tbss_ya_IS_0218 -m mean_FA_mask_thr22 -d design_IS_0218.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_ya_IV_0218 -m mean_FA_mask_thr22 -d design_IV_0218.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_ya_RA_0218 -m mean_FA_mask_thr22 -d design_RA_0218.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_ya_alpha_0218 -m mean_FA_mask_thr22 -d design_alpha_0218.mat -t design_CR.con -n 500 --T2 -D



### Using non-FA Images in TBSS (from [TBSS User Guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/TBSS/UserGuide))

1. Run the full TBSS analysis on your FA data.
2. Create a new directory called MD (or any other name) in your TBSS analysis directory (the one that contains the existing origdata, FA and stats directories from the FA analysis). Type: ```mkdir MD```
3. Copy MD images into this new directory, making sure that they are named exactly the same as the original FA images were (look in origdata to check the original names - and keep them exactly the same, even if they include FA, which can be confusing; e.g. if there is an image origdata/subj005_FA.nii.gz then you need an image MD/subj005_FA.nii.gz and this file should contain the MD data, even though it has FA in the name).
4. Now, making sure that you are in your top working TBSS directory (the one that now contains FA, stats and MD subdirectories) and run the tbss_non_FA script, telling it that the alternate data is called L2. This will apply the original nonlinear registration to the MD data, merge all subjects' warped MD data into a 4D file stats/all_MD, project this onto the original mean FA skeleton (using the original FA data to find the projection vectors), resulting in the 4D projected data stats/all_MD_skeletonised. Run: ```tbss_non_FA MD```

You can now run voxelwise stats on the projected 4D data all_MD_skeletonised.

### Creating masks

1. Create masks for corpus callosum regions. The corpus callosum is regions 3, 4, and 5 using the JHU atlas.
2. Extract mean FA values from the ROI.

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old_1/roi
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 -bin cc_bin.nii.gz
fslmaths ../stats/mean_FA_mask.nii.gz -mas cc_bin.nii.gz -bin cc_bin_mask.nii.gz

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old_1/stats
fslmeants -i all_FA.nii.gz -m ../roi/cc_bin_mask.nii.gz -o meants_cc.txt

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_young_1/stats
fslmeants -i all_FA.nii.gz -m ../roi/cc_bin_mask.nii.gz -o meants_cc.txt


for roinum in 3 4 5 ; do
   fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr $roinum -uthr $roinum -bin roimask
   fslmaths roimask -mas mean_FA_mask.nii.gz -bin roimask
   padroi=`$FSLDIR/bin/zeropad $roinum 3`
   fslmeants -i all_MD.nii.gz -m roimask -o meants_MD_roi${padroi}.txt
done

Run TFCE permutation analyses within the corpus callosum

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/stats

randomise -i all_FA -o tbss_old_alph_cc_FA -m cc_bin_mask -d design_age_alpha.mat -t design_within_RA.con -n 500 --T2
randomise -i all_MD -o tbss_old_alph_cc_MD -m cc_bin_mask -d design_age_alpha.mat -t design_within_RA.con -n 500 --T2

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/stats

randomise -i all_MD -o tbss_young_alph_cc_MD -m cc_bin_mask -d design_age_alpha.mat -t design_within_RA.con -n 500 --T2
#also look at f-statistic?

