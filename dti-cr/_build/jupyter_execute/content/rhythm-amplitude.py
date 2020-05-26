# Effect of circadian rhythm amplitude

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

### Rerun  using JHU atlas as mask

%%bash

cd /Volumes/G-DRIVE\ mobile/derivatives/roi/

fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -bin jhumask

from nilearn import plotting

scan_dir = '/Volumes/G-DRIVE mobile/derivatives/'

plotting.plot_img(scan_dir + 'roi/jhumask.nii.gz')

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

## Interaction using skeleton

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
