import pandas as pd
import os

SOURCE_DIR = '/Volumes/schnyer/Aging_DecMem/Scan_Data/fmriprep_tacc/fmriprep'

PARTIC = input("Which participant?")

#for local
CONFOUNDS_FILE = os.path.join(SOURCE_DIR, 'sub-' + PARTIC, 'func', 'sub-' + PARTIC + '_task-REST_run-01_bold_confounds.tsv')
#for tacc
#CONFOUNDS_FILE = os.path.join(SOURCE_DIR, 'sub-' + PARTIC, 'func', 'sub-' + PARTIC + '_task-REST_run-01_desc-confounds_regressors.tsv')


CONFOUNDS_FILE_MOD = os.path.join(SOURCE_DIR, 'sub-' + PARTIC, 'func', 'sub-' + PARTIC + '_task-REST_run-01_desc-confounds_regressors_mod.txt')

df = pd.read_csv(CONFOUNDS_FILE, sep = '\t')
df_mod = df[['CSF', 'WhiteMatter', 'GlobalSignal', 'X', 'Y', 'Z', 'RotX', 'RotY', 'RotZ']]
df_mod.to_csv(CONFOUNDS_FILE_MOD, sep = '\t', index=False)
