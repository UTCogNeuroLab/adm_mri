import numpy as np
import pandas as pd
import json
import os
import glob
import shutil
import sys

# subject = '30295'
# test_dir = '/Users/PSYC-mcm5324/Box/CogNeuroLab/Aging Decision Making R01/Analysis/dwi_test'
# os.chdir(test_dir)

subject = str(sys.argv[1])
bids_dir = str(sys.argv[2])
data_dir = str(sys.argv[3])
out_dir = str(sys.argv[4])

try:
    os.makedirs(out_dir)
    print('created subject directory %s' % out_dir)
except:
    print('subject directory exists')

try:
    os.makedirs(os.path.join(bids_dir, 'derivatives/dtiprep/config'))
except:
    print('configuration directory exists')

src_files = os.listdir(data_dir)
for file_name in src_files:
    full_file_name = os.path.join(data_dir, file_name)
    if os.path.isfile(full_file_name):
        shutil.copy(full_file_name, out_dir)

os.chdir(out_dir)
print('current working directory: %s' % os.getcwd())


# rescale bvecs and bvals
def rescale_bvec(bvec_file):
    if os.path.exists(bvec_file):

        bvec = np.loadtxt(bvec_file)
        bvec = bvec.transpose() if bvec.shape[0] == 3 else bvec

        bvecs_rescaled = [ b / np.linalg.norm(b) if not np.isclose(np.linalg.norm(b), 0) else b for b in bvec ]

        bvec_file_n = (os.path.splitext(bvec_file)[0] + '_rescaled' + os.path.splitext(bvec_file)[1])
        np.savetxt(bvec_file_n, bvecs_rescaled)
        print('rescaled %s' % bvec_file)

    else:

        print('%s not found' % bvec_file)

    return bvecs_rescaled

def rescale_bval(bval_file):

    if os.path.exists(bval_file):

        bval = np.loadtxt(bval_file)
        bvals_rescaled = bval * np.square(np.gradient(bval))

        bval_file_n = (os.path.splitext(bval_file)[0] + '_rescaled' + os.path.splitext(bval_file)[1])
        np.savetxt(bval_file_n, bvals_rescaled)
        print('rescaled %s' % bval_file)

    else:

        print('%s not found' % bval_file)

    return bvals_rescaled

def merge_bvals():

    bval_files = glob.glob('sub-*_acq-71??_dwi.bval')
    bvals = np.concatenate((np.loadtxt(bval_files[0]), np.loadtxt(bval_files[1])))
    np.savetxt(os.path.join(out_dir, 'sub-%s_bvals' % subject), bvals, fmt='%s')

    print('merged bvals')

    return bvals

def merge_bvecs():

    bvecs = []
    bvec_files = glob.glob('sub-*_acq-71??_dwi.bvec')
    bvecs = np.concatenate((np.loadtxt(bvec_files[0]), np.loadtxt(bvec_files[1])), axis=1)

    np.savetxt(os.path.join(out_dir, 'sub-%s_bvecs_rot' % subject), bvecs, fmt='%s')

    print('merged bvecs')

    return bvecs

bvecs = merge_bvecs()
bvals = merge_bvals()
bvec_ap_r = rescale_bvec(os.path.join(out_dir, 'sub-%s_acq-71AP_dwi.bvec' % subject))
bvec_pa_r = rescale_bvec(os.path.join(out_dir, 'sub-%s_acq-71PA_dwi.bvec' % subject))
bval_ap_r = rescale_bval(os.path.join(out_dir, 'sub-%s_acq-71AP_dwi.bval' % subject))
bval_pa_r = rescale_bval(os.path.join(out_dir, 'sub-%s_acq-71PA_dwi.bval' % subject))

# merge rescaled ap and pa bvecs and bvals
bvecs_rescaled = np.concatenate((bvec_ap_r, bvec_pa_r))
bvals_rescaled = np.concatenate((bval_ap_r, bval_pa_r), axis=0)

np.savetxt(os.path.join(out_dir, 'sub-%s_bvecs_rescaled') % subject, bvecs_rescaled, fmt='%s')
print('merged ap and pa rescaled bvec files')

np.savetxt(os.path.join(out_dir, 'sub-%s_bvals_rescaled') % subject, bvals_rescaled, fmt='%s')
print('merged ap and pa rescaled bval files')


# create acquisition parameters file for topup and eddy
if os.path.exists(os.path.join(bids_dir, 'derivatives/dtiprep/config/acq_param.txt')):

    print('acquisition parameters file exists')

else:

    json_ap = os.path.join(out_dir, 'sub-%s_acq-71AP_dwi.json') % subject
    with open(json_ap) as json_file:
        json_ap = json.load(json_file)
        readout_ap = json_ap['TotalReadoutTime'] #time between collection of the center of the first echo and the center of the last echo
        print('Readout time: %s' % readout_ap)
        tr = json_ap['RepetitionTime']
        print('Repetition time : %s' % tr)

    ap = [0, -1, 0]
    pa = [0, 1, 0]

    bval = np.loadtxt('sub-%s_acq-71AP_dwi.bval' % subject)
    len_b0_loc = int(len(np.where(bval < 1000)[0]))

    acq_param_ap = np.tile(ap, (len_b0_loc,1))
    acq_param_pa = np.tile(pa, (len_b0_loc,1))

    readout_vec = np.tile(readout_ap, (2*len_b0_loc,1))
    #readout_vec = np.ones((8,1))
    b0_acq_param = []
    readout_vec.shape
    b0_acq_param = np.concatenate((acq_param_ap, acq_param_pa), axis=0)
    b0_acq_param = np.concatenate((b0_acq_param, readout_vec), axis=1)
    len(b0_acq_param)

    np.savetxt(os.path.join(bids_dir, 'derivatives/dtiprep/config/acq_param.txt'), b0_acq_param, fmt='%s')
    print('created acquisition parameters file')

#merge ap and pa nifti files
niftis = np.array(sorted(glob.glob('*acq-71??_dwi.nii.gz')))

from nipype.interfaces.fsl import Merge
merger = Merge(in_files=niftis.tolist(), dimension='t', output_type='NIFTI_GZ')
cmd = merger.cmdline
print(cmd)
os.system(cmd)

output = os.path.abspath(glob.glob('*acq-71??_dwi_merged.nii.gz')[0])
os.rename(output, os.path.join(os.path.dirname(output), 'sub-%s_AP_PA_dwi.nii.gz' % subject))
print('merged AP and PA into single image')

#split nifti files into separate volumes
from nipype.interfaces.fsl import Split
split = Split(in_file = 'sub-%s_acq-71AP_dwi.nii.gz' % subject, dimension = 't', out_base_name = 'ap_vol', output_type = 'NIFTI_GZ')
cmd = split.cmdline
print(cmd)
os.system(cmd)

split = Split(in_file = 'sub-%s_acq-71PA_dwi.nii.gz' % subject, dimension = 't', out_base_name = 'pa_vol', output_type = 'NIFTI_GZ')
cmd = split.cmdline
print(cmd)
os.system(cmd)

#extract b0 images
bval = np.loadtxt('sub-%s_acq-71AP_dwi.bval' % subject)
b0_loc = np.where(bval < 1000)[0].tolist()#ap and pa are the same
niftis_ap = np.array(sorted(glob.glob('ap_vol*.nii.gz')))
b0_nii_ap = niftis_ap[b0_loc]

for file in sorted(b0_nii_ap):
    os.rename(file, os.path.join(os.path.dirname(file), 'b0_' + os.path.basename(file)))

niftis_pa = np.array(sorted(glob.glob('pa_vol*.nii.gz')))
b0_nii_pa = niftis_pa[b0_loc]

for file in sorted(b0_nii_pa):
    os.rename(file, os.path.join(os.path.dirname(file), 'b0_' + os.path.basename(file)))

b0_nii = np.array(sorted(glob.glob('b0_*.nii.gz')))

#create a single b0 image
merger = Merge(in_files=b0_nii.tolist(), dimension='t', output_type='NIFTI_GZ')
cmd = merger.cmdline
print(cmd)
os.system(cmd)

b0_merged = glob.glob('b0_*merged.nii.gz')[-1]
os.rename(b0_merged, os.path.join(os.path.dirname(b0_merged), 'sub-%s_AP_PA_b0.nii.gz' % subject))
print('created b0 image')

# create index file for eddy
if os.path.exists(os.path.join(bids_dir, 'derivatives/dtiprep/config/index.txt')):
    print('index file exists')
else:
    b0_loca = np.where(bval < 1000)[0]
    b0_new = np.concatenate((b0_loca, 72+b0_loca))
    index = np.ones((144,1))

    for i in range(1,len(b0_new)-1):
        index[b0_new[i]:b0_new[i+1]] = (index[b0_new[i-1]] + 1)
    index[-1] = len(b0_new)

    np.savetxt(os.path.join(bids_dir, 'derivatives/dtiprep/config/index.txt'), index, fmt='%1d')
    print('created index file')

#rotate bvecs for eddy and dtifit
bvecs_rescaled = np.loadtxt('sub-%s_bvecs_rescaled' % subject)
bvecs_rot = bvecs_rescaled.transpose()
bvecs_rot.shape
np.savetxt('sub-%s_bvecs_rescaled_rot' % subject, bvecs_rot, fmt='%s')
print('rotated rescaled bvecs for eddy')
