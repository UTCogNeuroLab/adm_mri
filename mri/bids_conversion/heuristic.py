import os

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

def infotodict(seqinfo):
    T1w = create_key('sub-{subject}/anat/sub-{subject}_run-{item}_T1w')
    dwi_ap = create_key('sub-{subject}/dwi/sub-{subject}_run-{item}_acq-71AP_dwi')
    dwi_pa = create_key('sub-{subject}/dwi/sub-{subject}_run-{item}_acq-71PA_dwi')
    # fmap_mag =  create_key('sub-{subject}/{session}/fmap/sub-{subject}_run-{item:2d}_magnitude')
    # fmap_phase = create_key('sub-{subject}/{session}/fmap/sub-{subject}_run-{item:2d}_phasediff')
    REST = create_key('sub-{subject}/func/sub-{subject}_task-REST_run-{item:2d}_bold')
    MemMatch1 = create_key('sub-{subject}/func/sub-{subject}_task-MemMatch1_run-{item:2d}_bold')
    MemMatch2 = create_key('sub-{subject}/func/sub-{subject}_task-MemMatch2_run-{item:2d}_bold')
    MemMatch3 = create_key('sub-{subject}/func/sub-{subject}_task-MemMatch3_run-{item:2d}_bold')
    MemRepeat1 = create_key('sub-{subject}/func/sub-{subject}_task-MemRepeat1_run-{item:2d}_bold')
    MemRepeat2 = create_key('sub-{subject}/func/sub-{subject}_task-MemRepeat2_run-{item:2d}_bold')
    MemRepeat3 = create_key('sub-{subject}/func/sub-{subject}_task-MemRepeat3_run-{item:2d}_bold')
    CSGT1 = create_key('sub-{subject}/func/sub-{subject}_task-CSGT1_run-{item:2d}_bold')
    CSGT2 = create_key('sub-{subject}/func/sub-{subject}_task-CSGT2_run-{item:2d}_bold')
    PHD1 = create_key('sub-{subject}/func/sub-{subject}_task-PHD1_run-{item:2d}_bold')
    PHD2 = create_key('sub-{subject}/func/sub-{subject}_task-PHD2_run-{item:2d}_bold')

    info = {T1w: [], dwi_ap: [], dwi_pa: [], REST: [], MemMatch1: [], MemMatch2: [], MemMatch3: [], MemRepeat1: [], MemRepeat2: [], MemRepeat3: [], CSGT1: [], CSGT2: [], PHD1: [], PHD2: []}

    for idx, s in enumerate(seqinfo):
        if (s.dim3 == 176) and (s.dim4 == 1) and ('MEMPRAGE' in s.protocol_name):
            info[T1w].append({'item': s.series_id})
        if (s.dim3 == 78) and (s.dim4 == 72) and ('CMRR DTI UCSF_71AP' in s.protocol_name):
            info[dwi_ap].append({'item': s.series_id})
        if (s.dim3 == 78) and (s.dim4 == 72) and ('CMRR DTI UCSF_71PA' in s.protocol_name):
            info[dwi_pa].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 240) and ('restingstate' in s.protocol_name):
            info[REST].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 164) and ('MemMatch Run 1' in s.protocol_name):
            info[MemMatch1].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 164) and ('MemMatch Run 2' in s.protocol_name):
            info[MemMatch2].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 164) and ('MemMatch Run 3' in s.protocol_name):
            info[MemMatch3].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 175) and ('MemRepeat Run 1' in s.protocol_name):
            info[MemRepeat1].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 175) and ('MemRepeat Run 2' in s.protocol_name):
            info[MemRepeat2].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 175) and ('MemRepeat Run 3' in s.protocol_name):
            info[MemRepeat3].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 203) and ('CSGT_run1' in s.protocol_name):
            info[CSGT1].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 203) and ('CSGT_run2' in s.protocol_name):
            info[CSGT2].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 268) and ('PHD_run1' in s.protocol_name):
            info[PHD1].append({'item': s.series_id})
        if (s.dim3 == 66) and (s.dim4 == 268) and ('PHD_run2' in s.protocol_name):
            info[PHD2].append({'item': s.series_id})
    return info
