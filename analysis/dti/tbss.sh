# Megan McMahon
# 2019

# run tbss

for sub_dir in /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/*/
do
  cp "$sub_dir"*FA.nii.gz /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/
  #find $sub_dir -type f | echo `grep -i *FA.nii.gz` #| cp {} /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss
done

for sub_dir in /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/*/
do
  cp "$sub_dir"*MD.nii.gz /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old/MD/
  #find $sub_dir -type f | echo `grep -i *FA.nii.gz` #| cp {} /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss
done

for file in `ls /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_young/MD/`
do
  partic=`echo "$file" | cut -c5-9`
  echo $partic
  mv "$file" "sub-${partic}_dti_FA.nii.gz"
done

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_old
tbss_non_FA MD

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_cr
ls

tbss_1_preproc *FA.nii.gz

open -a "Google Chrome" /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_cr/FA/slicesdir/index.html

tbss_2_reg -T

tbss_3_postreg -S #or -T?

cd stats
fsleyes all_FA -b 0,0.8 mean_FA_skeleton -b 0.2,0.8 -l Green &

tbss_4_prestats 0.2 #replace 0.2 if need to change it

cd FA
imglob *_FA.*

cd ../stats

# young adults vs. older adults
design_ttest2 design 48 53 #n_YA n_OA

# what we really want is to look at relationships with cr measures
# TO DO: make new design.mat and design.con files

# Baillet (2017) age gender sleep fragmentation
Text2Vest design_within_young_RA.txt design_within_young_RA.mat
Text2Vest design_within_old_RA.txt design_within_old_RA.mat
Text2Vest design_within_RA.con.txt design_within_RA.con

Text2Vest design_within_ya_tmt.txt design_within_young_tmt-b.mat
Text2Vest design_within_oa_tmt.txt design_within_old_tmt-b.mat

###
randomise -i all_FA -o tbss_RA -m mean_FA_mask -d design_within_young_RA.mat -t design_within_RA.con -n 500 --T2

randomise -i all_FA -o tbss_old_RA -m mean_FA_mask -d design_within_old_RA.mat -t design_within_RA.con -n 500 --T2

###
randomise -i all_FA -o tbss_young_tmtb -m mean_FA_mask -d design_within_young_tmt-b.mat -t design_within_RA.con -n 500 --T2

randomise -i all_FA -o tbss_old_tmtb -m mean_FA_mask -d design_within_old_tmt-b.mat -t design_within_RA.con -n 500 --T2

###

randomise -i all_FA_skeletonised -o RA_skel -m mean_FA_skeleton_mask -d design_within_young_RA.mat -t design_within_RA.con -n 500 --T2
randomise -i all_FA_skeletonised -o RA_skel -m mean_FA_skeleton_mask -d design_within_old_RA.mat -t design_within_RA.con -n 500 --T2

randomise -i all_FA -o tbss_young_RA_genu -m genu_bin -d design_within_young_RA.mat -t design_within_RA.con -n 500 --T2
randomise -i all_FA -o tbss_old_RA_genu -m genu_bin -d design_within_old_RA.mat -t design_within_RA.con -n 500 --T2

randomise -i all_FA_skeletonised -o tbss_RA -m mean_FA_skeleton_mask -d design_YA_OA_RA.mat -t design_YA_OA_CR.con -n 500 --T2

randomise -i all_FA -o tbss_YA_OA_RA_fa -m mean_FA_mask -d design_YA_OA_RA.mat -t design_YA_OA_CR.con -n 500 --T2

randomise -i all_FA -o tbss_young_tmtb -m mean_FA_mask -d design_young_tmt.mat -t design_tmt.con -n 500 --T2

randomise -i all_FA -o tbss_old_tmtb -m mean_FA_mask -d design_old_tmt.mat -t design_tmt.con -n 500 --T2

randomise -i all_FA -o tbss_old_RA_genu -m genu_bin -d design_within_old_RA.mat -t design_within_RA.con -n 500 --T2

randomise -i all_FA -o tbss_old_RA_genu -m genu_bin -d design_within_old_RA.mat -t design_within_RA.con -n 500 --T2


###
Text2Vest design_age_alpha.txt design_age_alpha.mat

fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 -bin cc_bin.nii.gz
fslmaths mean_FA_mask.nii.gz -mas cc_bin.nii.gz -bin cc_bin_mask.nii.gz

randomise -i all_FA -o tbss_old_alph_cc_FA -m cc_bin_mask -d design_age_alpha.mat -t design_within_RA.con -n 500 --T2

randomise -i all_MD -o tbss_old_alph_cc_MD -m cc_bin_mask -d design_age_alpha.mat -t design_within_RA.con -n 500 --T2

randomise -i all_MD -o tbss_young_alph_cc_MD -m cc_bin_mask -d design_age_alpha.mat -t design_within_RA.con -n 500 --T2

###
fsleyes $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.8 tbss_tstat1 -l Red-Yellow -b 3,6 tbss_tstat2 -l Blue-Lightblue -b 3,6 &

fsleyes $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.7 tbss_YA_OA_RA_tfce_corrp_tstat1 -l Red-Yellow -b 0.95,1 &

#https://web.stanford.edu/group/vista/cgi-bin/wiki/index.php/MrVista_TBSS#Design_matrix_and_contrast

fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 3 -bin genu_bin.nii.gz
fslmaths mean_FA_mask.nii.gz -mas genu_bin.nii.gz -bin genu_mask.nii.gz
randomise -i all_FA -o tbss_RA_genu -m genu_mask -d design_YA_OA_RA.mat -t design_YA_OA_CR.con -n 500 --T2
fslmeants -i all_FA.nii.gz -m ../../genu_mask.nii.gz -o meants_genu.txt

### young adults
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 -bin cc_bin.nii.gz
fslmaths mean_FA_mask.nii.gz -mas cc_bin.nii.gz -bin cc_mask.nii.gz

Text2Vest design_age_alph.txt design_age_alph.mat
Text2Vest design_age_fact.txt design_age_fact.mat

randomise -i all_MD -o tbss_young_alph_cc_MD -m cc_mask -d design_age_alph.mat -t design_within_RA.con -n 500 --T2

randomise -i all_FA -o tbss_young_fact_cc_FA -m cc_mask -d design_age_fact.mat -t design_within_RA.con -n 500 --T2

####
for roinum in 3 4 5 ; do
   fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr $roinum -uthr $roinum -bin roimask
   fslmaths roimask -mas mean_FA_skeleton_mask.nii.gz -bin roimask
   padroi=`$FSLDIR/bin/zeropad $roinum 3`
   fslmeants -i all_MD.nii.gz -m roimask -o meants_MD_skel_roi${padroi}.txt
done


#SCN
cd /Volumes/schnyer/Megan
flirt -in mask_sca -ref /usr/local/fsl/data/standard/FMRIB58_FA_1mm -applyxfm -out mask_sca_1mm

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_young/stats
fslmaths /Volumes/schnyer/Megan/mask_sca_1mm -mas mean_FA_mask -bin mask_sca_1mm_bin
fslmeants -i all_FA.nii.gz -m mask_sca_1mm_bin -o meants_FA_sca.txt
fslmeants -i all_MD.nii.gz -m mask_sca_1mm_bin -o meants_MD_sca.txt

#https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=fsl;a059b10c.1409
#https://www.brown.edu/carney/mri/researchers/analysis-pipelines/dti#step6
SUBJECTS_DIR=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/freesurfer/
sublist=`ls /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/freesurfer/ | xargs -n 1 basename | grep sub-`
asegstats2table --subjects $sublist --meas volume --skip --segno 251 252 253 254 255 --tablefile aseg_stats_cc.txt
