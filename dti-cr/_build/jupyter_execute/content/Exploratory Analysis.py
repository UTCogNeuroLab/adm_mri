import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import sys

home_dir = '/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives'

## Older Adults

oa_df1 = []
oa_files = pd.DataFrame(os.listdir(home_dir + '/tbss_oa/origdata'), columns = ['files'])

oa_fa = pd.read_csv(home_dir + '/tbss_oa/stats/mean_fa_cc.txt', names = ['CC_FA'])
oa_md = pd.read_csv(home_dir + '/tbss_oa/stats/mean_md_cc.txt', names = ['CC_MD'])
oa_ad = pd.read_csv(home_dir + '/tbss_oa/stats/mean_ad_cc.txt', names = ['CC_AD'])
oa_rd = pd.read_csv(home_dir + '/tbss_oa/stats/mean_rd_cc.txt', names = ['CC_RD'])

oa_fa_genu = pd.read_csv(home_dir + '/tbss_oa/stats/mean_fa_genu.txt', names = ['genu_FA'])
oa_md_genu = pd.read_csv(home_dir + '/tbss_oa/stats/mean_md_genu.txt', names = ['genu_MD'])
oa_ad_genu = pd.read_csv(home_dir + '/tbss_oa/stats/mean_ad_genu.txt', names = ['genu_AD'])
oa_rd_genu = pd.read_csv(home_dir + '/tbss_oa/stats/mean_rd_genu.txt', names = ['genu_RD'])

oa_df1 = pd.concat([oa_files, oa_fa], axis = 1)
oa_df1 = pd.concat([oa_df1, oa_md], axis = 1)
oa_df1 = pd.concat([oa_df1, oa_ad], axis = 1)
oa_df1 = pd.concat([oa_df1, oa_rd], axis = 1)
oa_df1 = pd.concat([oa_df1, oa_fa_genu], axis = 1)
oa_df1 = pd.concat([oa_df1, oa_md_genu], axis = 1)
oa_df1 = pd.concat([oa_df1, oa_ad_genu], axis = 1)
oa_df1 = pd.concat([oa_df1, oa_rd_genu], axis = 1)

#oa_df1['Group'] == 'Older Adults'

oa_df1

oa_df1.describe()

oa_df1['record_id1'] = oa_df1['files'].str.split('-', expand = True)[1]
oa_df1['record_id'] = oa_df1['record_id1'].str.split('_', expand = True)[0].astype(int)
oa_df1

#oa_df1 = oa_df1.set_index('record_id')
beh = beh.set_index('record_id')

oa_df = []
oa_df = oa_df1.join(beh, sort=True).dropna(subset = ['files'])
oa_df

oa_df.drop(columns = ['record_id1']).describe()

plt.subplots(figsize=(5,5), dpi=250)

plt.scatter(oa_df['age'], oa_df['CC_FA'], color = 'red')
plt.xlabel('Age')
plt.ylabel('CC FA')

fig, (ax1, ax2, ax3) = plt.subplots(3,1, figsize=(5,15), dpi=250)

ax1.scatter(oa_df['age'], oa_df['CC_MD'], color = 'blue')
ax1.set(ylabel='CC MD')
ax1.set_ylim([0.0004, 0.00055])

ax2.scatter(oa_df['age'], oa_df['CC_AD'], color = 'green')
ax2.set(ylabel='CC AD')
ax2.set_ylim([0.00065, 0.001])

ax3.scatter(oa_df['age'], oa_df['CC_RD'], color = 'orange')
ax3.set(xlabel='Age', ylabel='CC RD')
ax3.set_ylim([0.0002, 0.0004])


## Young Adults

ya_files = pd.DataFrame(os.listdir(home_dir + '/tbss_ya/origdata'), columns = ['files'])
ya_df1 = []

ya_fa = pd.read_csv(home_dir + '/tbss_ya/stats/mean_fa_cc.txt', names = ['CC_FA'])
ya_md = pd.read_csv(home_dir + '/tbss_ya/stats/mean_md_cc.txt', names = ['CC_MD'])
ya_ad = pd.read_csv(home_dir + '/tbss_ya/stats/mean_ad_cc.txt', names = ['CC_AD'])
ya_rd = pd.read_csv(home_dir + '/tbss_ya/stats/mean_rd_cc.txt', names = ['CC_RD'])

ya_fa_genu = pd.read_csv(home_dir + '/tbss_ya/stats/mean_fa_genu.txt', names = ['genu_FA'])
ya_md_genu = pd.read_csv(home_dir + '/tbss_ya/stats/mean_md_genu.txt', names = ['genu_MD'])
ya_ad_genu = pd.read_csv(home_dir + '/tbss_ya/stats/mean_ad_genu.txt', names = ['genu_AD'])
ya_rd_genu = pd.read_csv(home_dir + '/tbss_ya/stats/mean_rd_genu.txt', names = ['genu_RD'])

ya_df1 = pd.concat([ya_files, ya_fa], axis = 1)
ya_df1 = pd.concat([ya_df1, ya_md], axis = 1)
ya_df1 = pd.concat([ya_df1, ya_ad], axis = 1)
ya_df1 = pd.concat([ya_df1, ya_rd], axis = 1)
ya_df1 = pd.concat([ya_df1, ya_fa_genu], axis = 1)
ya_df1 = pd.concat([ya_df1, ya_md_genu], axis = 1)
ya_df1 = pd.concat([ya_df1, ya_ad_genu], axis = 1)
ya_df1 = pd.concat([ya_df1, ya_rd_genu], axis = 1)

ya_df1

ya_df1['record_id1'] = ya_df1['files'].str.split('-', expand = True)[1]
ya_df1['record_id'] = ya_df1['record_id1'].str.split('_', expand = True)[0].astype(int)
ya_df1 = ya_df1.set_index('record_id')
ya_df1[0:5]

ya_df = []
ya_df = ya_df1.join(beh, sort=True).dropna(subset = ['files'])
ya_df = ya_df.dropna(subset = ['files'])
ya_df.shape

ya_df.drop(columns = 'record_id1').describe()

plt.scatter(ya_df['age'], ya_df['CC_FA'], color = 'blue')
plt.xlabel("Age")
plt.ylabel("CC FA")
plt.title("Age")

## Correlation Plots

oa_df = oa_df[oa_df['actalph']<.9] #excluding 40175

import seaborn as sns

oa_corr = oa_df.drop(columns = ['record_id', 'years_educ']).iloc[:,0:24].corr()

fig, ax1 = plt.subplots(figsize=(20,15), dpi=400)
sns.heatmap(oa_corr[['CC_FA', 'CC_MD', 'CC_AD', 'CC_RD']].sort_values(by=['CC_AD'],ascending=False), annot=True, ax=ax1)
ax1.set_title('Older Adults')


import seaborn as sns

oa_corr = oa_df.drop(columns = ['years_educ', 'CC_FA', 'CC_MD', 'CC_AD', 'CC_RD']).iloc[:,0:24].corr()

fig, ax1 = plt.subplots(figsize=(20,15), dpi=400)
sns.heatmap(oa_corr[['genu_FA', 'genu_MD', 'genu_AD', 'genu_RD']].sort_values(by=['genu_FA'],ascending=False), annot=True, ax=ax1)
ax1.set_title('Older Adults')

import seaborn as sns

ya_corr = ya_df.drop(columns = ['record_id', 'years_educ']).iloc[:,0:24].corr()

fig, ax1 = plt.subplots(figsize=(20,15), dpi=400)
sns.heatmap(ya_corr[['CC_FA', 'CC_MD', 'CC_AD', 'CC_RD']].sort_values(by=['CC_AD'],ascending=False), annot=True, ax=ax1)
ax1.set_title('Young Adults')


import seaborn as sns

ya_corr = ya_df.drop(columns = ['years_educ', 'CC_FA', 'CC_MD', 'CC_AD', 'CC_RD']).iloc[:,0:24].corr()

fig, ax1 = plt.subplots(figsize=(20,15), dpi=400)
sns.heatmap(ya_corr[['genu_FA', 'genu_MD', 'genu_AD', 'genu_RD']].sort_values(by=['genu_FA'],ascending=False), annot=True, ax=ax1)
ax1.set_title('Older Adults')

df = []
df = pd.concat([ya_df, oa_df], sort=True)
df
df.to_csv('/Users/PSYC-mcm5324/Box/CogNeuroLab/Aging Decision Making R01/Data/data_03_2020.csv')



