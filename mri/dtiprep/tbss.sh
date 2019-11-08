# Megan McMahon
# 2019

# run tbss

for sub_dir in /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/*/
do
  cp "$sub_dir"*FA.nii.gz /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss/
  #find $sub_dir -type f | echo `grep -i *FA.nii.gz` #| cp {} /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss
done

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss
ls

tbss_1_preproc *FA.nii.gz

tbss_2_reg -T

tbss_3_postreg -S #or -T?

cd stats
fsleyes all_FA -b 0,0.8 mean_FA_skeleton -b 0.2,0.8 -l Green & #all_FA will not load on my computer, updated macOS?

tbss_4_prestats 0.2 #replace 0.2 if need to change it

cd FA
imglob *_FA.*

cd ../stats

# young adults vs. older adults
design_ttest2 design 48 59 #n_YA n_OA

# what we really want is to look at relationships with cr measures
# TO DO: make new design.mat and design.con files

# Baillet (2017) age gender sleep fragmentation


randomise -i all_FA_skeletonised -o tbss -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2


fsleyes $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.8 tbss_tstat1 -l Red-Yellow -b 3,6 tbss_tstat2 -l Blue-Lightblue -b 3,6 #not working
