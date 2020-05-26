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
