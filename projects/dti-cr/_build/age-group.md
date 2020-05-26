---
interact_link: content/age-group.ipynb
kernel_name: python3
has_widgets: false
title: 'Age-group'
prev_page:
  url: /rois.html
  title: 'Rois'
next_page:
  url: /cognition.html
  title: 'Cognition'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
# Age Group Effects

### GLM Setup



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import sys

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'
data_dir = '/Users/megmcmahon/Box/CogNeuroLab/Aging Decision Making R01/data/'

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
d = []
d = pd.read_csv(data_dir + 'dataset_2020-04-09.csv')
d = d.sort_values('record_id', ascending = True)
d['sex'] = np.where(d['sex'] == 'Female', 0, 1)
d[0:5]

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">



<div markdown="0" class="output output_html">
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>record_id</th>
      <th>actamp</th>
      <th>actbeta</th>
      <th>actphi</th>
      <th>actmin</th>
      <th>actmesor</th>
      <th>actupmesor</th>
      <th>actdownmesor</th>
      <th>actalph</th>
      <th>actwidthratio</th>
      <th>...</th>
      <th>cowat_zscore</th>
      <th>cowat_perseveration</th>
      <th>cowat_errors</th>
      <th>time_trails_a</th>
      <th>error_trails_a</th>
      <th>trails_a_z_score</th>
      <th>time_trails_b</th>
      <th>error_trails_b</th>
      <th>trails_b_z_score</th>
      <th>neuropsych_scoring_complete</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>30003</td>
      <td>1.389856</td>
      <td>21.815009</td>
      <td>14.373034</td>
      <td>0.541285</td>
      <td>1.236213</td>
      <td>6.117306</td>
      <td>22.628763</td>
      <td>-0.556815</td>
      <td>0.687977</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>35.0</td>
      <td>0.0</td>
      <td>-1.756914</td>
      <td>97.0</td>
      <td>0.0</td>
      <td>-3.784870</td>
      <td>2.0</td>
    </tr>
    <tr>
      <td>1</td>
      <td>30004</td>
      <td>1.630892</td>
      <td>4.438790</td>
      <td>15.128163</td>
      <td>0.000000</td>
      <td>0.815446</td>
      <td>6.927406</td>
      <td>23.328920</td>
      <td>-0.544804</td>
      <td>0.683396</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>25.0</td>
      <td>0.0</td>
      <td>-0.068886</td>
      <td>59.0</td>
      <td>0.0</td>
      <td>-0.673139</td>
      <td>2.0</td>
    </tr>
    <tr>
      <td>2</td>
      <td>30008</td>
      <td>1.610484</td>
      <td>7.306045</td>
      <td>15.569911</td>
      <td>0.139627</td>
      <td>0.944868</td>
      <td>7.708287</td>
      <td>23.431534</td>
      <td>-0.468304</td>
      <td>0.655135</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>27.0</td>
      <td>0.0</td>
      <td>-0.592431</td>
      <td>60.0</td>
      <td>1.0</td>
      <td>-0.869188</td>
      <td>2.0</td>
    </tr>
    <tr>
      <td>3</td>
      <td>30009</td>
      <td>1.951245</td>
      <td>7.026165</td>
      <td>14.377649</td>
      <td>0.081641</td>
      <td>1.057264</td>
      <td>6.388996</td>
      <td>22.366302</td>
      <td>-0.497424</td>
      <td>0.665721</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>35.0</td>
      <td>0.0</td>
      <td>-1.216992</td>
      <td>61.0</td>
      <td>0.0</td>
      <td>-0.834951</td>
      <td>2.0</td>
    </tr>
    <tr>
      <td>4</td>
      <td>30012</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>35.0</td>
      <td>1.0</td>
      <td>-1.216992</td>
      <td>54.0</td>
      <td>0.0</td>
      <td>-0.268608</td>
      <td>2.0</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 742 columns</p>
</div>
</div>


</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
oa_files = []
oa_files = pd.DataFrame(os.listdir(scan_dir + '/tbss_oa/origdata'), columns = ['files'])
oa_files['record_id'] = oa_files['files'].str.split('-', expand = True)[1].str.split('_', expand = True)[0].astype(int)
oa_files = oa_files.drop('files', axis=1)
oa_files = oa_files.set_index('record_id')

oa_df = []
oa_df = d[d['Group'] == 'Older Adults']
oa_df = oa_df.set_index('record_id')

oa_dsn = []
oa_dsn = oa_files.join(oa_df, sort=True).dropna(subset = ['files'])

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
oa_dsn.shape

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
(57, 741)
```


</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
ya_files = []
ya_files = pd.DataFrame(os.listdir(scan_dir + '/tbss_ya/origdata'), columns = ['files'])
ya_files['record_id'] = ya_files['files'].str.split('-', expand = True)[1].str.split('_', expand = True)[0].astype(int)
ya_files = ya_files.drop('files', axis=1)
ya_files = ya_files.set_index('record_id')

ya_df = []
ya_df = d[d['Group'] == 'Young Adults']
ya_df = ya_df.set_index('record_id')

ya_dsn = []
ya_dsn = ya_files.join(ya_df, sort=True).dropna(subset = ['files'])

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
ya_dsn.shape

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
(46, 741)
```


</div>
</div>
</div>



## TBSS Analysis

1. Concatenate all_FA images
2. Run fsl randomise looking for interaction of age group x RAR amplitude



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/

fslmerge -h

printf "\nYoung Adults All FA\n"
fslinfo tbss_ya/stats/all_FA

printf "\nOlder Adults All FA\n"
fslinfo tbss_oa/stats/all_FA

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```

Usage: fslmerge <-x/y/z/t/a/tr> <output> <file1 file2 .......> [tr value in seconds]
     -t : concatenate images in time
     -x : concatenate images in the x direction
     -y : concatenate images in the y direction
     -z : concatenate images in the z direction
     -a : auto-choose: single slices -> volume, volumes -> 4D (time series)
     -tr : concatenate images in time and set the output image tr to the final option value

Young Adults All FA
data_type	FLOAT32
dim1		182
dim2		218
dim3		182
dim4		46
datatype	16
pixdim1		1.000000
pixdim2		1.000000
pixdim3		1.000000
pixdim4		1.000000
cal_max		0.000000
cal_min		0.000000
file_type	NIFTI-1+

Older Adults All FA
data_type	FLOAT32
dim1		182
dim2		218
dim3		182
dim4		57
datatype	16
pixdim1		1.000000
pixdim2		1.000000
pixdim3		1.000000
pixdim4		1.000000
cal_max		0.000000
cal_min		0.000000
file_type	NIFTI-1+
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/

fslmerge -t tbss/stats/all_FA_YA-OA tbss_ya/stats/all_FA tbss_oa/stats/all_FA

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/

fslinfo tbss/stats/all_FA_YA-OA

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
data_type	FLOAT32
dim1		182
dim2		218
dim3		182
dim4		103
datatype	16
pixdim1		1.000000
pixdim2		1.000000
pixdim3		1.000000
pixdim4		1.000000
cal_max		0.000000
cal_min		0.000000
file_type	NIFTI-1+
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import image
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'
nii = scan_dir + 'tbss/stats/all_FA_YA-OA.nii.gz'
first_vol = image.index_img(nii, 0)
plotting.plot_img(first_vol)

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x119949d90>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_11_1.png)

</div>
</div>
</div>



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



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/

fslmaths tbss/stats/all_FA_YA-OA -Tmean -thr 0.25 -bin tbss/stats/all_FA_YA-OA_mask

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_img(scan_dir + 'tbss/stats/all_FA_YA-OA_mask.nii.gz')

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x1194bab10>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_14_1.png)

</div>
</div>
</div>



[FSL GLM 2 groups, continuous covariate interaction](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/GLM#Two_Groups_with_continuous_covariate_interaction) <br>

[Mumford Brain Stats](http://mumford.fmripower.org/mean_centering/)



## Age Group Differences in WM



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

design_ttest2 dsn_ttest 46 57

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

randomise -i all_FA_YA-OA -o tbss_agegroup -m all_FA_YA-OA_mask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
randomise options: -i all_FA_YA-OA -o tbss_agegroup -m all_FA_YA-OA_mask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2 
Loading Data: 
Data loaded
4.44068e+29 permutations required for exhaustive test of t-test 1
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_agegroup_tfce_tstat1 is: 9033.68
4.44068e+29 permutations required for exhaustive test of t-test 2
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_agegroup_tfce_tstat2 is: 121286
Finished, exiting.
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

ls /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/tbss_agegroup*

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_agegroup_tfce_corrp_tstat1.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_agegroup_tfce_corrp_tstat2.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_agegroup_tstat1.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_agegroup_tstat2.nii.gz
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_agegroup_tfce_corrp_tstat1.nii.gz', cmap = 'coolwarm', threshold = 0.95, title = 'YA > OA')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x129b1c710>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_20_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_agegroup_tfce_corrp_tstat2.nii.gz', cmap = 'coolwarm', threshold = 0.95, title = 'YA < OA')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x12a031f90>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_21_1.png)

</div>
</div>
</div>



Why are we seeing areas of greater FA in older adults relative to young adults?

1. Checked all_FA image - First all_FA for OA corresponds to #47 of concatenated all_FA
2. Checked design matrix, matches
3. Checked contrast, matches
4. Rerun with JHU as WM mask?



### Rerun age group differences t-test using JHU atlas as mask



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -bin jhumask

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_img(scan_dir + 'roi/jhumask.nii.gz')

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x123908ad0>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_25_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

randomise -i all_FA_YA-OA -o tbss_agegroup_jhu -m ../../roi/jhumask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
randomise options: -i all_FA_YA-OA -o tbss_agegroup_jhu -m ../../roi/jhumask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2 
Loading Data: 
Data loaded
4.44068e+29 permutations required for exhaustive test of t-test 1
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_agegroup_jhu_tfce_tstat1 is: 5885.89
4.44068e+29 permutations required for exhaustive test of t-test 2
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_agegroup_jhu_tfce_tstat2 is: 33601.7
Finished, exiting.
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

ls /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/tbss_agegroup_jhu*

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_agegroup_jhu_tfce_corrp_tstat1.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_agegroup_jhu_tfce_corrp_tstat2.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_agegroup_jhu_tstat1.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_agegroup_jhu_tstat2.nii.gz
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_agegroup_jhu_tfce_corrp_tstat1.nii.gz', cmap = 'coolwarm', threshold = 0.95, title = 'YA > OA')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x12686f790>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_28_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_agegroup_jhu_tfce_corrp_tstat2.nii.gz', cmap = 'coolwarm', threshold = 0.95, title = 'YA < OA')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x1263bff10>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_29_1.png)

</div>
</div>
</div>



Still seeing some regions where OA FA > YA FA?



### Rerun interaction model with JHU mask



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

randomise -i all_FA_YA-OA -o tbss_int_jhu -m ../../roi/jhumask -d ya_oa_amp-ya_amp-oa.mat -t int.con -n 500 --T2 -D


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
randomise options: -i all_FA_YA-OA -o tbss_int_jhu -m ../../roi/jhumask -d ya_oa_amp-ya_amp-oa.mat -t int.con -n 500 --T2 -D 
Loading Data: 
Data loaded
1.70561e+156 permutations required for exhaustive test of t-test 1
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_int_jhu_tfce_tstat1 is: 782182
1.70561e+156 permutations required for exhaustive test of t-test 2
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_int_jhu_tfce_tstat2 is: 919248
Finished, exiting.
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

ls /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/tbss_int_jhu*

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_int_jhu_tfce_corrp_tstat1.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_int_jhu_tfce_corrp_tstat2.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_int_jhu_tstat1.nii.gz
/Volumes/G-DRIVE mobile/derivatives/tbss/stats/tbss_int_jhu_tstat2.nii.gz
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_jhu_tfce_corrp_tstat1.nii.gz', threshold = 0.95, title = 'YA < OA')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x1275a1b50>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_34_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_jhu_tfce_corrp_tstat2.nii.gz', threshold = 0.95, title = 'YA < OA')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x127743710>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_35_1.png)

</div>
</div>
</div>



No significant interaction effect



## FA Skeleton



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/new

design_ttest2 dsn_ttest 46 57

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/new

randomise -i all_FA_skeletonised -o tbss_agegroup -m mean_FA_skeleton_mask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
randomise options: -i all_FA_skeletonised -o tbss_agegroup -m mean_FA_skeleton_mask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2 
Loading Data: 
Data loaded
4.44068e+29 permutations required for exhaustive test of t-test 1
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_agegroup_tfce_tstat1 is: 58651.4
4.44068e+29 permutations required for exhaustive test of t-test 2
Doing 500 random permutations
Starting permutation 1 (Unpermuted data)
Starting permutation 2
Starting permutation 3
Starting permutation 4
Starting permutation 5
Starting permutation 6
Starting permutation 7
Starting permutation 8
Starting permutation 9
Starting permutation 10
Starting permutation 11
Starting permutation 12
Starting permutation 13
Starting permutation 14
Starting permutation 15
Starting permutation 16
Starting permutation 17
Starting permutation 18
Starting permutation 19
Starting permutation 20
Starting permutation 21
Starting permutation 22
Starting permutation 23
Starting permutation 24
Starting permutation 25
Starting permutation 26
Starting permutation 27
Starting permutation 28
Starting permutation 29
Starting permutation 30
Starting permutation 31
Starting permutation 32
Starting permutation 33
Starting permutation 34
Starting permutation 35
Starting permutation 36
Starting permutation 37
Starting permutation 38
Starting permutation 39
Starting permutation 40
Starting permutation 41
Starting permutation 42
Starting permutation 43
Starting permutation 44
Starting permutation 45
Starting permutation 46
Starting permutation 47
Starting permutation 48
Starting permutation 49
Starting permutation 50
Starting permutation 51
Starting permutation 52
Starting permutation 53
Starting permutation 54
Starting permutation 55
Starting permutation 56
Starting permutation 57
Starting permutation 58
Starting permutation 59
Starting permutation 60
Starting permutation 61
Starting permutation 62
Starting permutation 63
Starting permutation 64
Starting permutation 65
Starting permutation 66
Starting permutation 67
Starting permutation 68
Starting permutation 69
Starting permutation 70
Starting permutation 71
Starting permutation 72
Starting permutation 73
Starting permutation 74
Starting permutation 75
Starting permutation 76
Starting permutation 77
Starting permutation 78
Starting permutation 79
Starting permutation 80
Starting permutation 81
Starting permutation 82
Starting permutation 83
Starting permutation 84
Starting permutation 85
Starting permutation 86
Starting permutation 87
Starting permutation 88
Starting permutation 89
Starting permutation 90
Starting permutation 91
Starting permutation 92
Starting permutation 93
Starting permutation 94
Starting permutation 95
Starting permutation 96
Starting permutation 97
Starting permutation 98
Starting permutation 99
Starting permutation 100
Starting permutation 101
Starting permutation 102
Starting permutation 103
Starting permutation 104
Starting permutation 105
Starting permutation 106
Starting permutation 107
Starting permutation 108
Starting permutation 109
Starting permutation 110
Starting permutation 111
Starting permutation 112
Starting permutation 113
Starting permutation 114
Starting permutation 115
Starting permutation 116
Starting permutation 117
Starting permutation 118
Starting permutation 119
Starting permutation 120
Starting permutation 121
Starting permutation 122
Starting permutation 123
Starting permutation 124
Starting permutation 125
Starting permutation 126
Starting permutation 127
Starting permutation 128
Starting permutation 129
Starting permutation 130
Starting permutation 131
Starting permutation 132
Starting permutation 133
Starting permutation 134
Starting permutation 135
Starting permutation 136
Starting permutation 137
Starting permutation 138
Starting permutation 139
Starting permutation 140
Starting permutation 141
Starting permutation 142
Starting permutation 143
Starting permutation 144
Starting permutation 145
Starting permutation 146
Starting permutation 147
Starting permutation 148
Starting permutation 149
Starting permutation 150
Starting permutation 151
Starting permutation 152
Starting permutation 153
Starting permutation 154
Starting permutation 155
Starting permutation 156
Starting permutation 157
Starting permutation 158
Starting permutation 159
Starting permutation 160
Starting permutation 161
Starting permutation 162
Starting permutation 163
Starting permutation 164
Starting permutation 165
Starting permutation 166
Starting permutation 167
Starting permutation 168
Starting permutation 169
Starting permutation 170
Starting permutation 171
Starting permutation 172
Starting permutation 173
Starting permutation 174
Starting permutation 175
Starting permutation 176
Starting permutation 177
Starting permutation 178
Starting permutation 179
Starting permutation 180
Starting permutation 181
Starting permutation 182
Starting permutation 183
Starting permutation 184
Starting permutation 185
Starting permutation 186
Starting permutation 187
Starting permutation 188
Starting permutation 189
Starting permutation 190
Starting permutation 191
Starting permutation 192
Starting permutation 193
Starting permutation 194
Starting permutation 195
Starting permutation 196
Starting permutation 197
Starting permutation 198
Starting permutation 199
Starting permutation 200
Starting permutation 201
Starting permutation 202
Starting permutation 203
Starting permutation 204
Starting permutation 205
Starting permutation 206
Starting permutation 207
Starting permutation 208
Starting permutation 209
Starting permutation 210
Starting permutation 211
Starting permutation 212
Starting permutation 213
Starting permutation 214
Starting permutation 215
Starting permutation 216
Starting permutation 217
Starting permutation 218
Starting permutation 219
Starting permutation 220
Starting permutation 221
Starting permutation 222
Starting permutation 223
Starting permutation 224
Starting permutation 225
Starting permutation 226
Starting permutation 227
Starting permutation 228
Starting permutation 229
Starting permutation 230
Starting permutation 231
Starting permutation 232
Starting permutation 233
Starting permutation 234
Starting permutation 235
Starting permutation 236
Starting permutation 237
Starting permutation 238
Starting permutation 239
Starting permutation 240
Starting permutation 241
Starting permutation 242
Starting permutation 243
Starting permutation 244
Starting permutation 245
Starting permutation 246
Starting permutation 247
Starting permutation 248
Starting permutation 249
Starting permutation 250
Starting permutation 251
Starting permutation 252
Starting permutation 253
Starting permutation 254
Starting permutation 255
Starting permutation 256
Starting permutation 257
Starting permutation 258
Starting permutation 259
Starting permutation 260
Starting permutation 261
Starting permutation 262
Starting permutation 263
Starting permutation 264
Starting permutation 265
Starting permutation 266
Starting permutation 267
Starting permutation 268
Starting permutation 269
Starting permutation 270
Starting permutation 271
Starting permutation 272
Starting permutation 273
Starting permutation 274
Starting permutation 275
Starting permutation 276
Starting permutation 277
Starting permutation 278
Starting permutation 279
Starting permutation 280
Starting permutation 281
Starting permutation 282
Starting permutation 283
Starting permutation 284
Starting permutation 285
Starting permutation 286
Starting permutation 287
Starting permutation 288
Starting permutation 289
Starting permutation 290
Starting permutation 291
Starting permutation 292
Starting permutation 293
Starting permutation 294
Starting permutation 295
Starting permutation 296
Starting permutation 297
Starting permutation 298
Starting permutation 299
Starting permutation 300
Starting permutation 301
Starting permutation 302
Starting permutation 303
Starting permutation 304
Starting permutation 305
Starting permutation 306
Starting permutation 307
Starting permutation 308
Starting permutation 309
Starting permutation 310
Starting permutation 311
Starting permutation 312
Starting permutation 313
Starting permutation 314
Starting permutation 315
Starting permutation 316
Starting permutation 317
Starting permutation 318
Starting permutation 319
Starting permutation 320
Starting permutation 321
Starting permutation 322
Starting permutation 323
Starting permutation 324
Starting permutation 325
Starting permutation 326
Starting permutation 327
Starting permutation 328
Starting permutation 329
Starting permutation 330
Starting permutation 331
Starting permutation 332
Starting permutation 333
Starting permutation 334
Starting permutation 335
Starting permutation 336
Starting permutation 337
Starting permutation 338
Starting permutation 339
Starting permutation 340
Starting permutation 341
Starting permutation 342
Starting permutation 343
Starting permutation 344
Starting permutation 345
Starting permutation 346
Starting permutation 347
Starting permutation 348
Starting permutation 349
Starting permutation 350
Starting permutation 351
Starting permutation 352
Starting permutation 353
Starting permutation 354
Starting permutation 355
Starting permutation 356
Starting permutation 357
Starting permutation 358
Starting permutation 359
Starting permutation 360
Starting permutation 361
Starting permutation 362
Starting permutation 363
Starting permutation 364
Starting permutation 365
Starting permutation 366
Starting permutation 367
Starting permutation 368
Starting permutation 369
Starting permutation 370
Starting permutation 371
Starting permutation 372
Starting permutation 373
Starting permutation 374
Starting permutation 375
Starting permutation 376
Starting permutation 377
Starting permutation 378
Starting permutation 379
Starting permutation 380
Starting permutation 381
Starting permutation 382
Starting permutation 383
Starting permutation 384
Starting permutation 385
Starting permutation 386
Starting permutation 387
Starting permutation 388
Starting permutation 389
Starting permutation 390
Starting permutation 391
Starting permutation 392
Starting permutation 393
Starting permutation 394
Starting permutation 395
Starting permutation 396
Starting permutation 397
Starting permutation 398
Starting permutation 399
Starting permutation 400
Starting permutation 401
Starting permutation 402
Starting permutation 403
Starting permutation 404
Starting permutation 405
Starting permutation 406
Starting permutation 407
Starting permutation 408
Starting permutation 409
Starting permutation 410
Starting permutation 411
Starting permutation 412
Starting permutation 413
Starting permutation 414
Starting permutation 415
Starting permutation 416
Starting permutation 417
Starting permutation 418
Starting permutation 419
Starting permutation 420
Starting permutation 421
Starting permutation 422
Starting permutation 423
Starting permutation 424
Starting permutation 425
Starting permutation 426
Starting permutation 427
Starting permutation 428
Starting permutation 429
Starting permutation 430
Starting permutation 431
Starting permutation 432
Starting permutation 433
Starting permutation 434
Starting permutation 435
Starting permutation 436
Starting permutation 437
Starting permutation 438
Starting permutation 439
Starting permutation 440
Starting permutation 441
Starting permutation 442
Starting permutation 443
Starting permutation 444
Starting permutation 445
Starting permutation 446
Starting permutation 447
Starting permutation 448
Starting permutation 449
Starting permutation 450
Starting permutation 451
Starting permutation 452
Starting permutation 453
Starting permutation 454
Starting permutation 455
Starting permutation 456
Starting permutation 457
Starting permutation 458
Starting permutation 459
Starting permutation 460
Starting permutation 461
Starting permutation 462
Starting permutation 463
Starting permutation 464
Starting permutation 465
Starting permutation 466
Starting permutation 467
Starting permutation 468
Starting permutation 469
Starting permutation 470
Starting permutation 471
Starting permutation 472
Starting permutation 473
Starting permutation 474
Starting permutation 475
Starting permutation 476
Starting permutation 477
Starting permutation 478
Starting permutation 479
Starting permutation 480
Starting permutation 481
Starting permutation 482
Starting permutation 483
Starting permutation 484
Starting permutation 485
Starting permutation 486
Starting permutation 487
Starting permutation 488
Starting permutation 489
Starting permutation 490
Starting permutation 491
Starting permutation 492
Starting permutation 493
Starting permutation 494
Starting permutation 495
Starting permutation 496
Starting permutation 497
Starting permutation 498
Starting permutation 499
Starting permutation 500
Critical Value for: tbss_agegroup_tfce_tstat2 is: 36355.1
Finished, exiting.
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

more /Volumes/G-DRIVE\ mobile/derivatives/tbss/new/dsn_ttest.mat

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
/NumWaves 2
/NumPoints 103
/PPheights 1 1
/Matrix
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
1 0
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
0 1
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

more /Volumes/G-DRIVE\ mobile/derivatives/tbss/new/dsn_ttest.con

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
/NumWaves 2
/NumContrasts 2
/PPheights 1 1
/Matrix
1 -1
-1 1
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/new/tbss_agegroup_tfce_corrp_tstat1.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'YA > OA')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x11631b590>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_42_1.png)

</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```python
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/new/tbss_agegroup_tfce_corrp_tstat2.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'YA < OA')


```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">


{:.output_data_text}
```
<nilearn.plotting.displays.OrthoSlicer at 0x11559e350>
```


</div>
</div>
<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/age-group_43_1.png)

</div>
</div>
</div>

