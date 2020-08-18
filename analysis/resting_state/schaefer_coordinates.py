#schaefer coordinates

from nilearn import datasets
from nilearn import plotting
import numpy as np

schaefer = datasets.fetch_atlas_schaefer_2018(n_rois=400, yeo_networks=7, resolution_mm=2)
coordinates = plotting.find_parcellation_cut_coords(labels_img=schaefer['maps'])
labels=np.array([x.decode() for x in schaefer['labels']])
seq = np.linspace(1,400,400).astype(int)

atlas = np.column_stack((seq,labels,coordinates))
np.savetxt('/Users/megmcmahon/schaefer_atlas.txt', atlas, delimiter = '\t', fmt = '%s')
