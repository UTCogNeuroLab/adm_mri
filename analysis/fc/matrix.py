#Pads connectivity matrices from PyNets to be appropriate dimensions (400 x 400)
#Converts connectivity matrices to csv files
#Megan McMahon

import numpy as np
import pickle
import os

#IMPORTANT
#toggle for local vs tacc fmriprep files - naming is not consistent

OUT_DIR = '/Volumes/schnyer/Megan/corr_numpyarrays/'

PARTIC = input("Which participant?")

SCAN_DIR = '/Volumes/schnyer/Aging_DecMem/Scan_Data/fmriprep_tacc/'
#SCAN_DIR = '/Volumes/schnyer/Aging_DecMem/Scan_Data/fmriprep_local/'

SOURCE_DIR = os.path.join(SCAN_DIR + '/fmriprep/sub-' + PARTIC + '/func' + '/Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm')

def missing_elements(L):
  start, end = L[0], L[-1]
  return sorted(set(range(start, end + 1)).difference(L))

labelnames = os.path.join(SOURCE_DIR + '/atlas_labelnames_sub-' + PARTIC + '_task-REST_run-01_space-MNI152NLin2009cAsym_desc-brain_mask.pkl')
#labelnames = os.path.join(SOURCE_DIR + '/atlas_labelnames_sub-' + PARTIC + '_task-REST_run-01_bold_space-MNI152NLin2009cAsym_brainmask.pkl')

with open(labelnames, 'rb') as f:
    labels = pickle.load(f)

missing = missing_elements(labels)
#missing1 = [x+1 for x in missing]

f = os.path.join(SOURCE_DIR + '/' + PARTIC + '_est_corr_0.1prop_sub-' + PARTIC + '_task-REST_run-01_space-MNI152NLin2009cAsym_desc-brain_mask_6mm_nb_nosm.npy')
#f = os.path.join(SOURCE_DIR + '/' + PARTIC + '_est_corr_0.1prop_sub-' + PARTIC + '_task-REST_run-01_bold_space-MNI152NLin2009cAsym_brainmask_6mm_nb_nosm.npy')

print(f)

conn_matrix = np.load(f)
conn_matrix_new = conn_matrix
#conn_matrix_padded = np.zeros((400, 400))
#conn_matrix_padded[:conn_matrix.shape[0],:conn_matrix.shape[1]] = conn_matrix
for i in missing:
  conn_matrix_new= np.insert(conn_matrix_new, i, 0, 0)
  conn_matrix_new = np.insert(conn_matrix_new, i, 0, 1)

f_basename = (os.path.splitext(f)[0])
output = f_basename + '_new.csv'
print(output)

np.savetxt(output, conn_matrix_new, delimiter=',')

print("\n \n")
print("Check matrix dimensions -----------------------")
print(conn_matrix_new.shape)
print("\n \n")

from shutil import copy2
copy2(output, OUT_DIR)
