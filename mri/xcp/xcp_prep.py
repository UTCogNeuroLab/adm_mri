import os
import numpy as np
import pandas as pd
import glob
from shutil import copyfile

# ------------------------------------ setup -----------------------------------
fmriprep_dir = '/scratch/06089/mcm5324/fmriprep'
xcp_dir = '/scratch/06089/mcm5324/xcp'

os.path.exists(fmriprep_dir)
os.path.exists(xcp_dir)

# ---------------------- create cohort files for xcpEngine ---------------------
# This creates the cohort file for xcpEngine, with subjects grouped in sets of 20.
# The format of the xcpEngine cohort file is as follows:
# id0,antsct,img
# sub-1,xcp_output/sub-1/struc,fmriprep/sub-1/func/sub-1_task-rest_space-T1w_desc-preproc_bold.nii.gz
imgs = sorted(glob.glob(fmriprep_dir + "/sub-?????/func/*task-REST_run-01_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz"))

subjects = []
anat_files = []
func_files = []
for img in sorted(imgs):
    sub = img.split('sub-',1)[1][0:5]
    subjects.append(sub)

    anat_files.append(os.path.join('/fmriprep', 'sub-%s' % sub, 'anat', 'sub-%s_desc-preproc_T1w.nii.gz' % sub))

    func_files.append(img.split('mcm5324', 1)[1])

def cohorts(l, n):
    # For item i in a range that is a length of l,
    for i in range(0, len(l), n):
        # Create an index range for l of n items:
        yield l[i:i+n]

sub_cohort = list(cohorts(subjects, 20))
anat_cohort = list(cohorts(anat_files, 20))
func_cohort = list(cohorts(func_files, 20))

for cohort in range(0,len(func_cohort)):
    df = []
    df = pd.DataFrame([sub_cohort[cohort], anat_cohort[cohort], func_cohort[cohort])
    df = df.transpose()
    df.columns = ['id0', 'antsct', 'img']
    df.to_csv(os.path.join(xcp_dir, 'adm_cohort_%03d.csv' % cohort), sep = ',', header = True, index = False)

# --------------------- create new confound files for xcpEngine ----------------
# This will create a copy of all fmriprep-generated confound files saved as '*confounds_regressors_fmr.tsv'.
# The '*confounds_regressors.tsv' files will then contain only relevant confounds (6 motion parameters, CSF,
# white matter, and a regressor to remove the effect of high motion TRs (FD > 0.25)
# The FD regressor will be saved under the name global_signal so that it can be read into the xcp design file,
# as xcp currently only includes options for despiking and scrubbing.

for sub in subjects:
    #new confound file with regressor as global_signal variable for use with xcp
    conf_file = os.path.join(fmriprep_dir, 'sub-' + sub, 'func', 'sub-' + sub + '_task-REST_run-01_desc-confounds_regressors.tsv')
    #original confounds file generated from fmriprep
    conf_file_copy = os.path.join(fmriprep_dir, 'sub-' + sub, 'func', 'sub-' + sub + '_task-REST_run-01_desc-confounds_regressors_fmr.tsv')
    if os.path.exists(conf_file_copy):
        print('%s already exists' % conf_file_copy)
    else:
        copyfile(conf_file, conf_file_copy)
    df = pd.read_csv(conf_file_copy, sep = '\t')
    #replacing global_signal with indicators of TRs with FD > threshold
    df['global_signal'] = np.where(df['framewise_displacement'] > 0.25, 1, 0) #is this 1 or 0?
    df = df[['csf', 'white_matter', 'global_signal', 'trans_x', 'trans_y', 'trans_z', 'rot_x', 'rot_y', 'rot_z']]
    df.to_csv(conf_file, sep = '\t', index=False)
    print('%s created' % conf_file)
