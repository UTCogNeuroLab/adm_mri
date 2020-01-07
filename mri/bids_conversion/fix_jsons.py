import os
import sys
import json
import pandas as pd
import glob

partic = sys.argv[1]

bids_dir = "/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS"
os.path.exists(bids_dir)
out_dir = os.path.join(bids_dir, "sub-" + partic)
os.chdir(out_dir)

# get acquisition times of fieldmaps
f = pd.DataFrame(columns = ['filename', 'acq', 'run'])
for file in glob.glob("fmap/*magnitude1.json"):
    acquisition = json.load(open(os.path.join(out_dir, file)))['AcquisitionTime']
    run = str.split(file, "run-")[1][0:2]
    f = f.append({'filename': file, "acq": acquisition, "run": run}, ignore_index = True)

# get acquisition times of functional scans, and assign run numbers to match fieldmaps
nfmaps = f['run'].nunique()
print('%s fieldmaps detected' % nfmaps)

d = pd.DataFrame(columns = ['filename', 'acq', 'run'])
for file in glob.glob("func/*.json"):
    acquisition = json.load(open(os.path.join(out_dir, file)))['AcquisitionTime']

    for r, a in zip(sorted(f['run']), sorted(f['acq'])):
        if acquisition > a:
            run = r

    d = d.append({'filename': file, "acq": acquisition, "run": run}, ignore_index = True)

d = d.sort_values(['acq'])

# add intended for to fieldmap json files to document corresponding functional scans
for file in sorted(glob.glob("fmap/*.json")):
    run = str.split(file, "run-")[1][0:2]
    jdata = json.load(open(os.path.join(out_dir, file)))

    jdata['IntendedFor'] = d[d['run'] == run]['filename'].sort_values().to_list()

    with open(file, "w") as jfile:
        json.dump(jdata, jfile, indent=4, sort_keys = True, ensure_ascii=False)
