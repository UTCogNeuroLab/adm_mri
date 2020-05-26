# Rest-Activity Rhythms and White Matter Microstructure in Aging

* [Preprocessing](#Preprocessing)
* [TBSS](#TBSS)
* [GLM](#GLM)
  * [Trails B](#Trails-B-Performance-and-WM)
  * [Interaction Age Group x Rhythm Amplitude and WM](#Interaction-Age-Group-x-Rhythm-Amplitude-and-WM)
  * [Age Group Differences in WM](#Age-Group-Differences-in-WM)
  * [Rhythm Amplitude Main Effect within Groups](#Rhythm-Amplitude-Effect-Controlling-for-Age-and-Sex-within-Age-Groups)
* [Notes](#Notes)
* [BMI Correlations](#BMI-Correlations)

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


# GLM

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import sys

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'
data_dir = '/Users/megmcmahon/Box/CogNeuroLab/Aging Decision Making R01/data/'

d = []
d = pd.read_csv(data_dir + 'dataset_2020-04-09.csv')
d = d.sort_values('record_id', ascending = True)
d['sex'] = np.where(d['sex'] == 'Female', 0, 1)
d[0:5]

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

oa_dsn.shape

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

ya_dsn.shape

## Trails B Performance and WM

d[['record_id', 'Group', 'trails_b_z_score']]

imp = []
imp = oa_dsn[['record_id', 'Group', 'trails_b_z_score']]
imp['trails_b_z_score'] = imp['trails_b_z_score'].fillna(oa_dsn['trails_b_z_score'].mean())
imp['trails_b_z_score'] = imp['trails_b_z_score'] - imp['trails_b_z_score'].mean()
imp

np.savetxt(scan_dir + 'tbss_oa/stats/dsn_tmtbz.txt', imp[['trails_b_z_score']].values, fmt = '%f')


imp = []
imp = ya_dsn[['record_id', 'Group', 'trails_b_z_score']]
imp['trails_b_z_score'] = imp['trails_b_z_score'].fillna(ya_dsn['trails_b_z_score'].mean())
imp['trails_b_z_score'] = imp['trails_b_z_score'] - imp['trails_b_z_score'].mean()
imp

np.savetxt(scan_dir + 'tbss_ya/stats/dsn_tmtbz.txt', imp[['trails_b_z_score']].values, fmt = '%f')


%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
Text2Vest dsn_tmtbz.txt dsn_tmtbz.mat

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
Text2Vest dsn_tmtbz.txt dsn_tmtbz.mat

%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
ls *.con

printf "1\n-1" > 1var.txt
Text2Vest 1var.txt 1var.con

randomise -i all_FA_skeletonised -o tbss_oa_dsn_tmtbz -d dsn_tmtbz.mat \
-t 1var.con -n 500 --T2 -D

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats

ls *tmtbz*

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_oa/stats/tbss_oa_dsn_tmtbz_tfce_corrp_tstat1.nii.gz', threshold = 0.90, title = 'TMT-B')

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_oa/stats/tbss_oa_dsn_tmtbz_tfce_corrp_tstat2.nii.gz', threshold = 0.90, title = 'TMT-B')

%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
ls *.con

printf "1\n-1" > 1var.txt
Text2Vest 1var.txt 1var.con

randomise -i all_FA_skeletonised -o tbss_ya_dsn_tmtbz -d dsn_tmtbz.mat \
-t 1var.con -n 500 --T2 -D

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_ya/stats/tbss_ya_dsn_tmtbz_tfce_corrp_tstat1.nii.gz', threshold = 0.90, title = 'YA slope > OA slope')


from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_ya/stats/tbss_ya_dsn_tmtbz_tfce_corrp_tstat2.nii.gz', threshold = 0.90, title = 'YA slope > OA slope')


## Interaction Age Group x Rhythm Amplitude and WM

1. Concatenate all_FA images
2. Run fsl randomise looking for interaction of age group x RAR amplitude

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/

fslmerge -h

printf "\nYoung Adults All FA\n"
fslinfo tbss_ya/stats/all_FA

printf "\nOlder Adults All FA\n"
fslinfo tbss_oa/stats/all_FA

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/

fslmerge -t tbss/stats/all_FA_YA-OA tbss_ya/stats/all_FA tbss_oa/stats/all_FA

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/

fslinfo tbss/stats/all_FA_YA-OA

from nilearn import image
from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'
nii = scan_dir + 'tbss/stats/all_FA_YA-OA.nii.gz'
first_vol = image.index_img(nii, 0)
plotting.plot_img(first_vol)

%%bash

fslmaths -h

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/

fslmaths tbss/stats/all_FA_YA-OA -Tmean -thr 0.25 -bin tbss/stats/all_FA_YA-OA_mask

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_img(scan_dir + 'tbss/stats/all_FA_YA-OA_mask.nii.gz')

[FSL GLM 2 groups, continuous covariate interaction](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/GLM#Two_Groups_with_continuous_covariate_interaction) <br>

[Mumford Brain Stats](http://mumford.fmripower.org/mean_centering/)

import numpy as np
import pandas as pd
import os

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'
data_dir = '/Users/megmcmahon/Box/CogNeuroLab/Aging Decision Making R01/data/'

x1 = np.concatenate((np.ones(46), np.zeros(57)))
x2 = np.concatenate((np.zeros(46), np.ones(57)))

d = pd.read_csv(data_dir + 'dataset_2020-04-09.csv', usecols = ['record_id', 'actamp'])
d = d.sort_values('record_id', ascending = True)
d = d.set_index('record_id')

ya_files = pd.DataFrame(os.listdir(scan_dir + '/tbss_ya/origdata'), columns = ['files'])
oa_files = pd.DataFrame(os.listdir(scan_dir + '/tbss_oa/origdata'), columns = ['files'])
files = pd.DataFrame(np.concatenate([ya_files, oa_files]), columns = ['files'])
files['record_id'] = files['files'].str.split('-', expand = True)[1].str.split('_', expand = True)[0].astype(int)
files = files.set_index('record_id')

dsn = []
dsn = files.join(d, sort=True).dropna(subset = ['files'])

dsn['actamp'] = dsn['actamp'].fillna(dsn['actamp'].mean())
#NOT mean centering because testing the interaction
dsn

x3 = x1 * dsn['actamp'].values
x4 = x2 * dsn['actamp'].values

dsnmat = np.column_stack((x1, x2, x3, x4))
dsnmat

np.savetxt(scan_dir + 'tbss/stats/ya_oa_amp-ya_amp-oa.txt', dsnmat, fmt = '%f')

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

Text2Vest ya_oa_amp-ya_amp-oa.txt ya_oa_amp-ya_amp-oa.mat

printf "0 0 -1 1\n0 0 1 -1" > int.txt
Text2Vest int.txt int.con

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

randomise -i all_FA_YA-OA -o tbss_int -m all_FA_YA-OA_mask -d ya_oa_amp-ya_amp-oa.mat -t int.con -n 500 --T2 -D


%%bash

ls /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/tbss_int*

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_tfce_corrp_tstat1.nii.gz', title = 'YA slope > OA slope')

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_tfce_corrp_tstat1.nii.gz', threshold = 0.90, title = 'YA slope > OA slope')

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_tstat1.nii.gz', title = 'YA slope > OA slope')


from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_tfce_corrp_tstat2.nii.gz', title = 'YA slope < OA slope')

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_tfce_corrp_tstat2.nii.gz', threshold = 0.90, title = 'YA slope < OA slope')

## Age Group Differences in WM

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

design_ttest2 dsn_ttest 46 57

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

randomise -i all_FA_YA-OA -o tbss_agegroup -m all_FA_YA-OA_mask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2


%%bash

ls /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/tbss_agegroup*

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_agegroup_tfce_corrp_tstat1.nii.gz', cmap = 'coolwarm', threshold = 0.95, title = 'YA > OA')


from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_agegroup_tfce_corrp_tstat2.nii.gz', cmap = 'coolwarm', threshold = 0.95, title = 'YA < OA')


Why are we seeing areas of greater FA in older adults relative to young adults?

1. Checked all_FA image - First all_FA for OA corresponds to #47 of concatenated all_FA
2. Checked design matrix, matches
3. Checked contrast, matches
4. Rerun with JHU as WM mask?

### Rerun age group differences t-test using JHU atlas as mask

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -bin jhumask

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_img(scan_dir + 'roi/jhumask.nii.gz')

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

randomise -i all_FA_YA-OA -o tbss_agegroup_jhu -m ../../roi/jhumask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2


%%bash

ls /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/tbss_agegroup_jhu*

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_agegroup_jhu_tfce_corrp_tstat1.nii.gz', cmap = 'coolwarm', threshold = 0.95, title = 'YA > OA')


from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_agegroup_jhu_tfce_corrp_tstat2.nii.gz', cmap = 'coolwarm', threshold = 0.95, title = 'YA < OA')


Still seeing some regions where OA FA > YA FA?

### Rerun interaction model with JHU mask

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats

randomise -i all_FA_YA-OA -o tbss_int_jhu -m ../../roi/jhumask -d ya_oa_amp-ya_amp-oa.mat -t int.con -n 500 --T2 -D


%%bash

ls /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/tbss_int_jhu*

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_jhu_tfce_corrp_tstat1.nii.gz', threshold = 0.95, title = 'YA < OA')


from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/stats/tbss_int_jhu_tfce_corrp_tstat2.nii.gz', threshold = 0.95, title = 'YA < OA')


No significant interaction effect

## Rhythm Amplitude Effect Controlling for Age and Sex within Age Groups

[FSL GLM](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/GLM) <br>
Note that categorical covariates (e.g. gender) are treated in exactly the same way as continuous covariates - that is, use two indicator values (e.g. 0 and 1) and then demean these values as appropriate before entering them into the EV. <br>

d[['record_id', 'Group', 'actamp', 'age', 'sex']]

d[['record_id', 'Group', 'actamp', 'fact', 'age', 'sex']].isnull().sum()

oa_dsn

imp = []
imp = oa_dsn[['actamp', 'fact', 'age', 'sex']]

imp['actamp'] = imp['actamp'].fillna(oa_dsn['actamp'].mean())
imp['actamp'] = imp['actamp'] - imp['actamp'].mean()

imp['fact'] = imp['fact'].fillna(oa_dsn['fact'].mean())
imp['fact'] = imp['fact'] - imp['fact'].mean()

imp['age'] = imp['age'] - imp['age'].mean()

imp['sex'] = imp['sex'] - imp['sex'].mean()

imp

np.savetxt(scan_dir + 'tbss_oa/stats/dsn_amp7-age-sex.txt', imp[['actamp', 'age', 'sex']].values, fmt = '%f')
np.savetxt(scan_dir + 'tbss_oa/stats/dsn_amp7.txt', imp[['actamp']].values, fmt = '%f')
np.savetxt(scan_dir + 'tbss_oa/stats/dsn_fact7.txt', imp[['fact']].values, fmt = '%f')


%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats

Text2Vest dsn_amp7-age-sex.txt dsn_amp7-age-sex.mat
Text2Vest dsn_amp7.txt dsn_amp7.mat
Text2Vest dsn_fact7.txt dsn_fact7.mat

printf "1 0 0\n1 1 0\n1 -1 0\n-1 0 0\n-1 1 0" > 3var.txt
Text2Vest 3var.txt 3var.con
more 3var.con

imp = []
imp = ya_dsn[['actamp', 'fact', 'age', 'sex']]

imp['actamp'] = imp['actamp'].fillna(ya_dsn['actamp'].mean())
imp['actamp'] = imp['actamp'] - imp['actamp'].mean()

imp['fact'] = imp['fact'].fillna(ya_dsn['fact'].mean())
imp['fact'] = imp['fact'] - imp['fact'].mean()

imp['age'] = imp['age'] - imp['age'].mean()

imp['sex'] = imp['sex'] - imp['sex'].mean()

imp['ones'] = np.ones(len(imp))

imp

np.savetxt(scan_dir + 'tbss_ya/stats/dsn_amp7-age-sex.txt', imp[['actamp', 'age', 'sex']].values, fmt = '%f')
np.savetxt(scan_dir + 'tbss_ya/stats/dsn_amp7.txt', imp[['actamp']].values, fmt = '%f')
np.savetxt(scan_dir + 'tbss_ya/stats/dsn_fact7.txt', imp[['fact']].values, fmt = '%f')


%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats

Text2Vest dsn_amp7-age-sex.txt dsn_amp7-age-sex.mat
Text2Vest dsn_amp7.txt dsn_amp7.mat
Text2Vest dsn_fact7.txt dsn_fact7.mat

printf "1 0 0\n1 1 0\n1 -1 0\n-1 0 0\n-1 1 0" > 3var.txt
Text2Vest 3var.txt 3var.con

%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
randomise -i all_FA -m ../../roi/jhumask -o tbss_oa_1-amp7-age-sex_jhu -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_oa/stats/tbss_oa_1-amp7-age-sex_jhu_tfce_corrp_tstat1.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'Amplitude in OA controlling for age and sex')


%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats

cluster -i tbss_oa_1-amp7-age-sex_jhu_tfce_corrp_tstat1.nii.gz -t 0.95 --mm > cluster_t1_95_5-1.txt

more cluster_t1_95_5-1.txt

Not controlling for age and sex

%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
randomise -i all_FA -m ../../roi/jhumask -o tbss_oa_amp7_jhu -d dsn_amp7.mat \
-t 1var.con -n 500 --T2 -D

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_oa/stats/tbss_oa_amp7_jhu_tfce_corrp_tstat1.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'Amplitude in OA')


%%bash
#skeleton
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
randomise -i all_FA_skeletonised -o tbss_oa_1-amp7-age-sex -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D


%%bash
#jhu mask all FA 
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
randomise -i all_FA -m ../../roi/jhumask -o tbss_ya_amp7-age-sex_jhu -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_ya/stats/tbss_ya_amp7-age-sex_jhu_tfce_corrp_tstat1.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'Amplitude in YA controlling for age and sex')


%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats

cluster -i tbss_ya_amp7-age-sex_jhu_tfce_corrp_tstat1.nii.gz -t 0.95 --mm > cluster_t1_95_5-1.txt

more cluster_t1_95_5-1.txt

Not controlling for age and sex

%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
randomise -i all_FA -m ../../roi/jhumask -o tbss_ya_amp7_jhu -d dsn_amp7.mat \
-t 1var.con -n 500 --T2 -D

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss_ya/stats/tbss_ya_amp7_jhu_tfce_corrp_tstat1.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'Amplitude in YA')


%%bash

fslmaths -h

%%bash

#Extract map with regions of overlap for YA and OA

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
fslmaths tbss_ya_amp7_jhu_tfce_corrp_tstat1.nii.gz -thr 0.95 -bin tbss_ya_amp7_jhu_tfce_corrp_tstat1_bin.nii.gz

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
fslmaths tbss_oa_amp7_jhu_tfce_corrp_tstat1.nii.gz -thr 0.95 -bin tbss_oa_amp7_jhu_tfce_corrp_tstat1_bin.nii.gz

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats
fslmaths ../../tbss_oa/stats/tbss_oa_amp7_jhu_tfce_corrp_tstat1_bin.nii.gz -mul 2 -add ../../tbss_ya/stats/tbss_ya_amp7_jhu_tfce_corrp_tstat1_bin.nii.gz tbss_amp7_jhu_tfce_corrp_tstat1_bin_yaoa-sum.nii.gz

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_img(scan_dir + 'tbss/stats/tbss_amp7_jhu_tfce_corrp_tstat1_bin_yaoa-sum.nii.gz')


%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
randomise -i all_FA_skeletonised -o tbss_ya_amp7-age-sex -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D


%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
randomise -i all_MD_skeletonised -o tbss_oa_MD_1-amp7-age-sex -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D


%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
randomise -i all_MD_skeletonised -o tbss_ya_MD_amp7-age-sex -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D

%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
randomise -i all_AD_skeletonised -o tbss_oa_AD_amp7-age-sex -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D


%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
randomise -i all_AD_skeletonised -o tbss_ya_AD_amp7-age-sex -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D

%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
randomise -i all_AD_skeletonised -o tbss_oa_RD_amp7-age-sex -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D

%%bash
cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
randomise -i all_RD_skeletonised -o tbss_ya_RD_amp7-age-sex -d dsn_amp7-age-sex.mat \
-t 3var.con -n 500 --T2 -D

## Notes

03/2020: For PsychFest results, used this:

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya/stats

randomise -i all_FA -o tbss_ya_amp7_skel -m mean_FA_skeleton_mask -d dsn_amp7.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_ya_fact7_skel -m mean_FA_skeleton_mask -d dsn_fact7.mat -t design_CR.con -n 500 --T2 -D


tbss_fill tbss_oa_amp7_skel_tfce_corrp_tstat1 0.95 mean_FA tbss_fill_amp7
tbss_fill tbss_ya_amp7_skel_tfce_corrp_tstat1 0.95 mean_FA tbss_fill_amp7

### BMI Correlations

bmi = pd.read_csv('/Users/PSYC-mcm5324/Box/CogNeuroLab/Aging Decision Making R01/data/Redcap/bmi.csv').dropna().reset_index()
bmi[0:5]

def calculate_bmi(data, i):
    #print(bmi['sub_id'].iloc[i])
    
    feet = float(bmi['height_mri'].iloc[i].split("\'")[0])*12
    inches = float(bmi['height_mri'].iloc[i].split("\'")[1].split('"')[0])
    height = feet + inches
    weight = float(bmi['weight_mri'].iloc[i])
    
    body_mass_index = round( (weight * 703) / (height ** 2) , 2)
    
    return body_mass_index

body_mass_index = []

for i in bmi.index:
    
    body_mass_index.append(calculate_bmi(bmi, i))

body_mass_index = pd.DataFrame(body_mass_index, columns = ['bmi'])
bmi_df = pd.concat([bmi, body_mass_index], axis = 1).reset_index().drop(columns = ['level_0', 'index'])
bmi_df[0:5]

oa_df_n = oa_df.merge(bmi_df[bmi_df['sub_id'] > 40000], left_on = 'record_id', right_on = 'sub_id', how = 'right')
ya_df_n = ya_df.merge(bmi_df[bmi_df['sub_id'] < 40000], left_on = 'record_id', right_on = 'sub_id', how = 'right')

Some of these values aren't right (eg. > 200)

plt.subplots(dpi=350)
plt.scatter(ya_df_n['bmi'], ya_df_n['CC_FA'], color = 'blue', label = 'Young Adults')
plt.scatter(oa_df_n['bmi'], oa_df_n['CC_FA'], color = 'red', label = 'Older Adults')
plt.xlim([15, 35])
plt.xlabel("BMI")
plt.ylabel("CC FA")
plt.legend(loc='lower center', shadow=True, ncol=2)
plt.title("BMI vs CC FA")

plt.subplots(dpi=350)
plt.scatter(ya_df_n['bmi'], ya_df_n['actalph'], color = 'blue', label = 'Young Adults')
plt.scatter(oa_df_n['bmi'], oa_df_n['actalph'], color = 'red', label = 'Older Adults')
plt.xlim([15, 35])
plt.xlabel("BMI")
plt.ylabel("Width (alpha)")
plt.legend(loc='lower center', shadow=True, ncol=2)
plt.title("BMI vs Duration of Peak Activity")

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

fslmeants -h


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



## Interaction using skeleton

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/new

design_ttest2 dsn_ttest 46 57

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/new

randomise -i all_FA_skeletonised -o tbss_agegroup -m mean_FA_skeleton_mask -d dsn_ttest.mat -t dsn_ttest.con -n 500 --T2


%%bash

more /Volumes/G-DRIVE\ mobile/derivatives/tbss/new/dsn_ttest.mat

%%bash

more /Volumes/G-DRIVE\ mobile/derivatives/tbss/new/dsn_ttest.con

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/new/tbss_agegroup_tfce_corrp_tstat1.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'YA > OA')


from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/new/tbss_agegroup_tfce_corrp_tstat2.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'YA < OA')


# Amplitude Interaction by Age Group

%%bash

cp /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/ya_oa_amp-ya_amp-oa.mat /Volumes/G-DRIVE\ mobile/derivatives/tbss/new/.
cp /Volumes/G-DRIVE\ mobile/derivatives/tbss/stats/int.con /Volumes/G-DRIVE\ mobile/derivatives/tbss/new/.


%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss/new

randomise -i all_FA_skeletonised -o tbss_int_skel -m mean_FA_skeleton_mask -d ya_oa_amp-ya_amp-oa.mat -t int.con -n 500 --T2 -D


%%bash

more /Volumes/G-DRIVE\ mobile/derivatives/tbss/new/int.con


from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/new/tbss_int_skel_tfce_corrp_tstat1.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'YA Slope < OA Slope')


from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_stat_map(scan_dir + 'tbss/new/tbss_int_skel_tfce_corrp_tstat2.nii.gz', threshold = 0.95, cmap = 'coolwarm', title = 'YA Slope > OA Slope')


