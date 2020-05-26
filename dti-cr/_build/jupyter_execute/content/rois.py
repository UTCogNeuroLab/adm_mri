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


# Creating ROIs from coordinates

[Andy's Brain Blog](http://andysbrainblog.blogspot.com/2013/04/fsl-tutorial-creating-rois-from.html)

%%bash

fslmaths -h

`-roi <xmin> <xsize> <ymin> <ysize> <zmin> <zsize> <tmin> <tsize> : zero outside roi (using voxel coordinates). Inputting -1 for a size will set it to the full image extent for that dimension.`

%%bash

ls $FSLDIR/data/standard

## Selected ROIs

1. Frontal forceps (23 32 4) --> 67/113 158 76
2. Posterior forceps (34 51 0) --> 56/124 177 72
3. Longitudinal fasciculus (19 -18 37 --> 78/102 108 109; -21 -13 23 --> 111/69 113 95)
4. YA cluster (36 -11 28) --> 54/126 115 100
5. Corpus callosum

[Thresholding](https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=fsl;27fa5348.1409)

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 67 1 158 1 76 1 0 1 FFpoint_R -odt float
fslmaths FFpoint_R -kernel sphere 6 -fmean -thr 0.001 -bin FFsphere_R -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 113 1 158 1 76 1 0 1 FFpoint_L -odt float
fslmaths FFpoint_L -kernel sphere 6 -fmean -thr 0.001 -bin FFsphere_L -odt float


from nilearn import plotting

plotting.plot_roi('/Volumes/G-DRIVE mobile/derivatives/roi/FFsphere_R.nii.gz')

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 56 1 177 1 72 1 0 1 PFpoint_R -odt float
fslmaths PFpoint_R -kernel sphere 6 -fmean -thr 0.001 -bin PFsphere_R -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 124 1 177 1 72 1 0 1 PFpoint_L -odt float
fslmaths PFpoint_L -kernel sphere 6 -fmean -thr 0.001 -bin PFsphere_L -odt float


from nilearn import plotting

plotting.plot_roi('/Volumes/G-DRIVE mobile/derivatives/roi/PFsphere_R.nii.gz')

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 78 1 108 1 109 1 0 1 LFpoint1_R -odt float
fslmaths LFpoint1_R -kernel sphere 6 -fmean -thr 0.001 -bin LFsphere1_R -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 102 1 108 1 109 1 0 1 LFpoint1_L -odt float
fslmaths LFpoint1_L -kernel sphere 6 -fmean -thr 0.001 -bin LFsphere1_L -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 69 1 113 1 95 1 0 1 LFpoint2_R -odt float
fslmaths LFpoint2_R -kernel sphere 6 -fmean -thr 0.001 -bin LFsphere2_R -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 111 1 113 1 95 1 0 1 LFpoint2_L -odt float
fslmaths LFpoint2_L -kernel sphere 6 -fmean -thr 0.001 -bin LFsphere2_L -odt float


from nilearn import plotting

plotting.plot_roi('/Volumes/G-DRIVE mobile/derivatives/roi/LFsphere1_L.nii.gz')

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi
mkdir stats

for i in `ls *sphere*`; do
echo $i
outfile="`echo ${i##*/.nii.gz} | cut -d. -f1`"

echo "fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k $i -M >> stats/${outfile}_oa_tstat_means.txt;"
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k $i -M >> stats/${outfile}_oa_tstat_means.txt;

echo "fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k $i -M >> stats/${outfile}_ya_tstat_means.txt;"
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k $i -M >> stats/${outfile}_ya_tstat_means.txt;
done


%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi
mkdir stats

for i in `ls *sphere*`; do
echo $i
outfile="`echo ${i##*/.nii.gz} | cut -d. -f1`"

echo "fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m $i -o stats/${outfile}_oa_fa_means.txt;"
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m $i -o stats/${outfile}_oa_fa_means.txt;

echo "fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m $i -o stats/${outfile}_ya_fa_means.txt;"
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m $i -o stats/${outfile}_ya_fa_means.txt;
done

from nilearn import plotting

plotting.plot_roi('/Volumes/G-DRIVE mobile/derivatives/roi/FFsphere1.nii.gz')