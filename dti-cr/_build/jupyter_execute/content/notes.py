## Notes

03/2020: For PsychFest results, used this:

%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya/stats

randomise -i all_FA -o tbss_ya_amp7_skel -m mean_FA_skeleton_mask -d dsn_amp7.mat -t design_CR.con -n 500 --T2 -D
randomise -i all_FA -o tbss_ya_fact7_skel -m mean_FA_skeleton_mask -d dsn_fact7.mat -t design_CR.con -n 500 --T2 -D


tbss_fill tbss_oa_amp7_skel_tfce_corrp_tstat1 0.95 mean_FA tbss_fill_amp7
tbss_fill tbss_ya_amp7_skel_tfce_corrp_tstat1 0.95 mean_FA tbss_fill_amp7