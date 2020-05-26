---
interact_link: content/rois.ipynb
kernel_name: python3
has_widgets: false
title: 'Rois'
prev_page:
  url: /tbss.html
  title: 'preprocessing and tbss'
next_page:
  url: /age-group.html
  title: 'Age-group'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
## Extract mean FA, MD, AD, RD in ROI



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
cd ${tbss_dir}/roi
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 ${tbss_dir}/roi/cc.nii.gz
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 3 ${tbss_dir}/roi/genu.nii.gz

tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
cd ${tbss_dir}/roi
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 ${tbss_dir}/roi/cc.nii.gz
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 3 ${tbss_dir}/roi/genu.nii.gz



```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash
# cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
# for mask in `ls ../../roi`; do
# fslmeants -i all_FA_skeletonised -m ${mask} -o ${mask}-meants.txt
# done

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
for mask in `ls ../../roi`; do
echo `fslmeants -i all_FA_skeletonised -m ${mask} -o ${mask}"-meants".txt`
done


```
</div>

</div>



# Creating ROIs from coordinates

[Andy's Brain Blog](http://andysbrainblog.blogspot.com/2013/04/fsl-tutorial-creating-rois-from.html)



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

fslmaths -h

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```

Usage: fslmaths [-dt <datatype>] <first_input> [operations and inputs] <output> [-odt <datatype>]

Datatype information:
 -dt sets the datatype used internally for calculations (default float for all except double images)
 -odt sets the output datatype ( default is float )
 Possible datatypes are: char short int float double input
 "input" will set the datatype to that of the original image

Binary operations:
  (some inputs can be either an image or a number)
 -add   : add following input to current image
 -sub   : subtract following input from current image
 -mul   : multiply current image by following input
 -div   : divide current image by following input
 -rem   : modulus remainder - divide current image by following input and take remainder
 -mas   : use (following image>0) to mask current image
 -thr   : use following number to threshold current image (zero anything below the number)
 -thrp  : use following percentage (0-100) of ROBUST RANGE to threshold current image (zero anything below the number)
 -thrP  : use following percentage (0-100) of ROBUST RANGE of non-zero voxels and threshold below
 -uthr  : use following number to upper-threshold current image (zero anything above the number)
 -uthrp : use following percentage (0-100) of ROBUST RANGE to upper-threshold current image (zero anything above the number)
 -uthrP : use following percentage (0-100) of ROBUST RANGE of non-zero voxels and threshold above
 -max   : take maximum of following input and current image
 -min   : take minimum of following input and current image
 -seed  : seed random number generator with following number
 -restart : replace the current image with input for future processing operations
 -save : save the current working image to the input filename

Basic unary operations:
 -exp   : exponential
 -log   : natural logarithm
 -sin   : sine function
 -cos   : cosine function
 -tan   : tangent function
 -asin  : arc sine function
 -acos  : arc cosine function
 -atan  : arc tangent function
 -sqr   : square
 -sqrt  : square root
 -recip : reciprocal (1/current image)
 -abs   : absolute value
 -bin   : use (current image>0) to binarise
 -binv  : binarise and invert (binarisation and logical inversion)
 -fillh : fill holes in a binary mask (holes are internal - i.e. do not touch the edge of the FOV)
 -fillh26 : fill holes using 26 connectivity
 -index : replace each nonzero voxel with a unique (subject to wrapping) index number
 -grid <value> <spacing> : add a 3D grid of intensity <value> with grid spacing <spacing>
 -edge  : edge strength
 -tfce <H> <E> <connectivity>: enhance with TFCE, e.g. -tfce 2 0.5 6 (maybe change 6 to 26 for skeletons)
 -tfceS <H> <E> <connectivity> <X> <Y> <Z> <tfce_thresh>: show support area for voxel (X,Y,Z)
 -nan   : replace NaNs (improper numbers) with 0
 -nanm  : make NaN (improper number) mask with 1 for NaN voxels, 0 otherwise
 -rand  : add uniform noise (range 0:1)
 -randn : add Gaussian noise (mean=0 sigma=1)
 -inm <mean> :  (-i i ip.c) intensity normalisation (per 3D volume mean)
 -ing <mean> :  (-I i ip.c) intensity normalisation, global 4D mean)
 -range : set the output calmin/max to full data range

Matrix operations:
 -tensor_decomp : convert a 4D (6-timepoint )tensor image into L1,2,3,FA,MD,MO,V1,2,3 (remaining image in pipeline is FA)

Kernel operations (set BEFORE filtering operation if desired):
 -kernel 3D : 3x3x3 box centered on target voxel (set as default kernel)
 -kernel 2D : 3x3x1 box centered on target voxel
 -kernel box    <size>     : all voxels in a cube of width <size> mm centered on target voxel
 -kernel boxv   <size>     : all voxels in a cube of width <size> voxels centered on target voxel, CAUTION: size should be an odd number
 -kernel boxv3  <X> <Y> <Z>: all voxels in a cuboid of dimensions X x Y x Z centered on target voxel, CAUTION: size should be an odd number
 -kernel gauss  <sigma>    : gaussian kernel (sigma in mm, not voxels)
 -kernel sphere <size>     : all voxels in a sphere of radius <size> mm centered on target voxel
 -kernel file   <filename> : use external file as kernel

Spatial Filtering operations: N.B. all options apart from -s use the default kernel or that _previously_ specified by -kernel
 -dilM    : Mean Dilation of non-zero voxels
 -dilD    : Modal Dilation of non-zero voxels
 -dilF    : Maximum filtering of all voxels
 -dilall  : Apply -dilM repeatedly until the entire FOV is covered
 -ero     : Erode by zeroing non-zero voxels when zero voxels found in kernel
 -eroF    : Minimum filtering of all voxels
 -fmedian : Median Filtering 
 -fmean   : Mean filtering, kernel weighted (conventionally used with gauss kernel)
 -fmeanu  : Mean filtering, kernel weighted, un-normalised (gives edge effects)
 -s <sigma> : create a gauss kernel of sigma mm and perform mean filtering
 -subsamp2  : downsamples image by a factor of 2 (keeping new voxels centred on old)
 -subsamp2offc  : downsamples image by a factor of 2 (non-centred)

Dimensionality reduction operations:
  (the "T" can be replaced by X, Y or Z to collapse across a different dimension)
 -Tmean   : mean across time
 -Tstd    : standard deviation across time
 -Tmax    : max across time
 -Tmaxn   : time index of max across time
 -Tmin    : min across time
 -Tmedian : median across time
 -Tperc <percentage> : nth percentile (0-100) of FULL RANGE across time
 -Tar1    : temporal AR(1) coefficient (use -odt float and probably demean first)

Basic statistical operations:
 -pval    : Nonparametric uncorrected P-value, assuming timepoints are the permutations; first timepoint is actual (unpermuted) stats image
 -pval0   : Same as -pval, but treat zeros as missing data
 -cpval   : Same as -pval, but gives FWE corrected P-values
 -ztop    : Convert Z-stat to (uncorrected) P
 -ptoz    : Convert (uncorrected) P to Z
 -rank    : Convert data to ranks (over T dim)
 -ranknorm: Transform to Normal dist via ranks

Multi-argument operations:
 -roi <xmin> <xsize> <ymin> <ysize> <zmin> <zsize> <tmin> <tsize> : zero outside roi (using voxel coordinates). Inputting -1 for a size will set it to the full image extent for that dimension.
 -bptf  <hp_sigma> <lp_sigma> : (-t in ip.c) Bandpass temporal filtering; nonlinear highpass and Gaussian linear lowpass (with sigmas in volumes, not seconds); set either sigma<0 to skip that filter
 -roc <AROC-thresh> <outfile> [4Dnoiseonly] <truth> : take (normally binary) truth and test current image in ROC analysis against truth. <AROC-thresh> is usually 0.05 and is limit of Area-under-ROC measure FP axis. <outfile> is a text file of the ROC curve (triplets of values: FP TP threshold). If the truth image contains negative voxels these get excluded from all calculations. If <AROC-thresh> is positive then the [4Dnoiseonly] option needs to be set, and the FP rate is determined from this noise-only data, and is set to be the fraction of timepoints where any FP (anywhere) is seen, as found in the noise-only 4d-dataset. This is then controlling the FWE rate. If <AROC-thresh> is negative the FP rate is calculated from the zero-value parts of the <truth> image, this time averaging voxelwise FP rate over all timepoints. In both cases the TP rate is the average fraction of truth=positive voxels correctly found.

Combining 4D and 3D images:
 If you apply a Binary operation (one that takes the current image and a new image together), when one is 3D and the other is 4D,
 the 3D image is cloned temporally to match the temporal dimensions of the 4D image.

e.g. fslmaths inputVolume -add inputVolume2 output_volume
     fslmaths inputVolume -add 2.5 output_volume
     fslmaths inputVolume -add 2.5 -mul inputVolume2 output_volume

     fslmaths 4D_inputVolume -Tmean -mul -1 -add 4D_inputVolume demeaned_4D_inputVolume

```
</div>
</div>
</div>



`-roi <xmin> <xsize> <ymin> <ysize> <zmin> <zsize> <tmin> <tsize> : zero outside roi (using voxel coordinates). Inputting -1 for a size will set it to the full image extent for that dimension.`



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

ls $FSLDIR/data/standard

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
FMRIB58_FA-skeleton_1mm.nii.gz
FMRIB58_FA_1mm.nii.gz
FSL_HCP1065_FA_1mm.nii.gz
FSL_HCP1065_L1_1mm.nii.gz
FSL_HCP1065_L2_1mm.nii.gz
FSL_HCP1065_L3_1mm.nii.gz
FSL_HCP1065_MD_1mm.nii.gz
FSL_HCP1065_MO_1mm.nii.gz
FSL_HCP1065_V1_1mm.nii.gz
FSL_HCP1065_V2_1mm.nii.gz
FSL_HCP1065_V3_1mm.nii.gz
FSL_HCP1065_tensor_1mm.nii.gz
Fornix_FMRIB_FA1mm.nii.gz
LowerCingulum_1mm.nii.gz
MNI152_T1_0.5mm.nii.gz
MNI152_T1_1mm.nii.gz
MNI152_T1_1mm_BigFoV_facemask.nii.gz
MNI152_T1_1mm_Hipp_mask_dil8.nii.gz
MNI152_T1_1mm_brain.nii.gz
MNI152_T1_1mm_brain_mask.nii.gz
MNI152_T1_1mm_brain_mask_dil.nii.gz
MNI152_T1_1mm_first_brain_mask.nii.gz
MNI152_T1_2mm.nii.gz
MNI152_T1_2mm_LR-masked.nii.gz
MNI152_T1_2mm_VentricleMask.nii.gz
MNI152_T1_2mm_b0.nii.gz
MNI152_T1_2mm_brain.nii.gz
MNI152_T1_2mm_brain_mask.nii.gz
MNI152_T1_2mm_brain_mask_deweight_eyes.nii.gz
MNI152_T1_2mm_brain_mask_dil.nii.gz
MNI152_T1_2mm_brain_mask_dil1.nii.gz
MNI152_T1_2mm_edges.nii.gz
MNI152_T1_2mm_eye_mask.nii.gz
MNI152_T1_2mm_skull.nii.gz
MNI152_T1_2mm_strucseg.nii.gz
MNI152_T1_2mm_strucseg_periph.nii.gz
MNI152lin_T1_1mm.nii.gz
MNI152lin_T1_1mm_brain.nii.gz
MNI152lin_T1_1mm_subbr_mask.nii.gz
MNI152lin_T1_2mm.nii.gz
MNI152lin_T1_2mm_brain.nii.gz
MNI152lin_T1_2mm_brain_mask.nii.gz
avg152T1.nii.gz
avg152T1_brain.nii.gz
bianca
tissuepriors
```
</div>
</div>
</div>



## Selected ROIs

1. Frontal forceps (23 32 4) --> 67/113 158 76
2. Posterior forceps (34 51 0) --> 56/124 177 72
3. Longitudinal fasciculus (19 -18 37 --> 78/102 108 109; -21 -13 23 --> 111/69 113 95)
4. YA cluster (36 -11 28) --> 54/126 115 100
5. Corpus callosum

[Thresholding](https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=fsl;27fa5348.1409)



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 67 1 158 1 76 1 0 1 FFpoint_R -odt float
fslmaths FFpoint_R -kernel sphere 6 -fmean -thr 0.001 -bin FFsphere_R -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 113 1 158 1 76 1 0 1 FFpoint_L -odt float
fslmaths FFpoint_L -kernel sphere 6 -fmean -thr 0.001 -bin FFsphere_L -odt float


```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

plotting.plot_roi('/Volumes/G-DRIVE mobile/derivatives/roi/FFsphere_R.nii.gz')

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x11d0bdcd0>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/rois_9_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 56 1 177 1 72 1 0 1 PFpoint_R -odt float
fslmaths PFpoint_R -kernel sphere 6 -fmean -thr 0.001 -bin PFsphere_R -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 124 1 177 1 72 1 0 1 PFpoint_L -odt float
fslmaths PFpoint_L -kernel sphere 6 -fmean -thr 0.001 -bin PFsphere_L -odt float


```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

plotting.plot_roi('/Volumes/G-DRIVE mobile/derivatives/roi/PFsphere_R.nii.gz')

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x11d3c8ad0>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/rois_11_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 78 1 108 1 109 1 0 1 LFpoint1_R -odt float
fslmaths LFpoint1_R -kernel sphere 6 -fmean -thr 0.001 -bin LFsphere1_R -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 102 1 108 1 109 1 0 1 LFpoint1_L -odt float
fslmaths LFpoint1_L -kernel sphere 6 -fmean -thr 0.001 -bin LFsphere1_L -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 69 1 113 1 95 1 0 1 LFpoint2_R -odt float
fslmaths LFpoint2_R -kernel sphere 6 -fmean -thr 0.001 -bin LFsphere2_R -odt float
fslmaths $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -roi 111 1 113 1 95 1 0 1 LFpoint2_L -odt float
fslmaths LFpoint2_L -kernel sphere 6 -fmean -thr 0.001 -bin LFsphere2_L -odt float


```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

plotting.plot_roi('/Volumes/G-DRIVE mobile/derivatives/roi/LFsphere1_L.nii.gz')

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x11fb6ced0>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/rois_13_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

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


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
FFsphere_L.nii.gz
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k FFsphere_L.nii.gz -M >> stats/FFsphere_L_oa_tstat_means.txt;
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k FFsphere_L.nii.gz -M >> stats/FFsphere_L_ya_tstat_means.txt;
FFsphere_R.nii.gz
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k FFsphere_R.nii.gz -M >> stats/FFsphere_R_oa_tstat_means.txt;
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k FFsphere_R.nii.gz -M >> stats/FFsphere_R_ya_tstat_means.txt;
LFsphere1_L.nii.gz
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k LFsphere1_L.nii.gz -M >> stats/LFsphere1_L_oa_tstat_means.txt;
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k LFsphere1_L.nii.gz -M >> stats/LFsphere1_L_ya_tstat_means.txt;
LFsphere1_R.nii.gz
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k LFsphere1_R.nii.gz -M >> stats/LFsphere1_R_oa_tstat_means.txt;
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k LFsphere1_R.nii.gz -M >> stats/LFsphere1_R_ya_tstat_means.txt;
LFsphere2_L.nii.gz
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k LFsphere2_L.nii.gz -M >> stats/LFsphere2_L_oa_tstat_means.txt;
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k LFsphere2_L.nii.gz -M >> stats/LFsphere2_L_ya_tstat_means.txt;
LFsphere2_R.nii.gz
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k LFsphere2_R.nii.gz -M >> stats/LFsphere2_R_oa_tstat_means.txt;
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k LFsphere2_R.nii.gz -M >> stats/LFsphere2_R_ya_tstat_means.txt;
PFsphere_L.nii.gz
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k PFsphere_L.nii.gz -M >> stats/PFsphere_L_oa_tstat_means.txt;
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k PFsphere_L.nii.gz -M >> stats/PFsphere_L_ya_tstat_means.txt;
PFsphere_R.nii.gz
fslstats ../tbss_oa/stats/tbss_oa_amp7_jhu_tstat1.nii.gz -k PFsphere_R.nii.gz -M >> stats/PFsphere_R_oa_tstat_means.txt;
fslstats ../tbss_ya/stats/tbss_ya_amp7_jhu_tstat1.nii.gz -k PFsphere_R.nii.gz -M >> stats/PFsphere_R_ya_tstat_means.txt;
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

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

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
FFsphere_L.nii.gz
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m FFsphere_L.nii.gz -o stats/FFsphere_L_oa_fa_means.txt;
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m FFsphere_L.nii.gz -o stats/FFsphere_L_ya_fa_means.txt;
FFsphere_R.nii.gz
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m FFsphere_R.nii.gz -o stats/FFsphere_R_oa_fa_means.txt;
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m FFsphere_R.nii.gz -o stats/FFsphere_R_ya_fa_means.txt;
LFsphere1_L.nii.gz
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m LFsphere1_L.nii.gz -o stats/LFsphere1_L_oa_fa_means.txt;
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m LFsphere1_L.nii.gz -o stats/LFsphere1_L_ya_fa_means.txt;
LFsphere1_R.nii.gz
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m LFsphere1_R.nii.gz -o stats/LFsphere1_R_oa_fa_means.txt;
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m LFsphere1_R.nii.gz -o stats/LFsphere1_R_ya_fa_means.txt;
LFsphere2_L.nii.gz
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m LFsphere2_L.nii.gz -o stats/LFsphere2_L_oa_fa_means.txt;
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m LFsphere2_L.nii.gz -o stats/LFsphere2_L_ya_fa_means.txt;
LFsphere2_R.nii.gz
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m LFsphere2_R.nii.gz -o stats/LFsphere2_R_oa_fa_means.txt;
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m LFsphere2_R.nii.gz -o stats/LFsphere2_R_ya_fa_means.txt;
PFsphere_L.nii.gz
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m PFsphere_L.nii.gz -o stats/PFsphere_L_oa_fa_means.txt;
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m PFsphere_L.nii.gz -o stats/PFsphere_L_ya_fa_means.txt;
PFsphere_R.nii.gz
fslmeants -i ../tbss_oa/stats/all_FA.nii.gz -m PFsphere_R.nii.gz -o stats/PFsphere_R_oa_fa_means.txt;
fslmeants -i ../tbss_ya/stats/all_FA.nii.gz -m PFsphere_R.nii.gz -o stats/PFsphere_R_ya_fa_means.txt;
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

plotting.plot_roi('/Volumes/G-DRIVE mobile/derivatives/roi/FFsphere1.nii.gz')

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x11cb7af90>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/rois_16_1.png)

</div>
</div>
</div>

