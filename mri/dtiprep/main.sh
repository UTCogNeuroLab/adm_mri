#!bash
#Multi-Shell DWI Preprocessing Pipeline
#Megan McMahon

printf "\n \n"

read -p "Which participant? " -r subjects

echo "subject list: "$subjects""

for subject in $subjects; do

  printf "\n \n *************** starting dti preprocessing for subject "$subject" *************** \n \n"

  export bids_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS
  export data_dir="$bids_dir"/sub-$subject/dwi
  export out_dir="$bids_dir"/derivatives/dtiprep/sub-$subject

  #separate script to rescale bvecs and bvals, create acquisition parameters file, and create index file
  python3 /Volumes/schnyer/Aging_DecMem/Scan_Data/Scripts/dti_prep.py $subject $bids_dir $data_dir $out_dir

  cd $out_dir
  sleep 10

  printf "running FSL topup \n \n"
  printf "topup --imain="$out_dir"/sub-"$subject"_AP_PA_b0.nii.gz --datain="$bids_dir"/derivatives/dtiprep/config/acq_param.txt --config=b02b0.cnf --out="$out_dir"/sub-"$subject"_topup_AP_PO_b0 --iout="$out_dir"/sub-"$subject"_topup_AP_PA_b0_iout --fout="$out_dir"/sub-"$subject"_topup_AP_PA_b0_fout --verbose \n"

  topup --imain="$out_dir"/sub-"$subject"_AP_PA_b0.nii.gz --datain="$bids_dir"/derivatives/dtiprep/config/acq_param.txt --config=b02b0.cnf --out="$out_dir"/sub-"$subject"_topup_AP_PO_b0 --iout="$out_dir"/sub-"$subject"_topup_AP_PA_b0_iout --fout="$out_dir"/sub-"$subject"_topup_AP_PA_b0_fout --verbose

  sleep 10

  printf "create mask for b0 image \n \n"
  printf "fslmaths sub-"$subject"_topup_AP_PA_b0_iout -Tmean sub-"$subject"_topup_AP_PA_b0_nodif"
  fslmaths sub-"$subject"_topup_AP_PA_b0_iout -Tmean sub-"$subject"_topup_AP_PA_b0_nodif

  printf "bet sub-"$subject"_topup_AP_PA_b0_nodif sub-"$subject"_topup_AP_PA_b0_nodif_brain -m -f 0.2"
  bet sub-"$subject"_topup_AP_PA_b0_nodif sub-"$subject"_topup_AP_PA_b0_nodif_brain -m -f 0.2

  sleep 10

  #running eddy with regular merged bvecs and bvals
  printf "run FSL eddy \n \n"
  printf "eddy --imain="$out_dir"/sub-"$subject"_AP_PA_dwi.nii.gz --mask="$out_dir"/sub-"$subject"_topup_AP_PA_b0_nodif_brain_mask.nii.gz --acqp="$bids_dir"/derivatives/dtiprep/config/acq_param.txt --index="$bids_dir"/derivatives/dtiprep/config/index.txt --bvecs="$out_dir"/sub-"$subject"_bvecs_rot --bvals="$out_dir"/sub-"$subject"_bvals --topup="$out_dir"/sub-"$subject"_topup_AP_PO_b0 --out="$out_dir"/sub-"$subject"_eddy --fwhm=0 --flm=quadratic --data_is_shelled --repol --verbose \n"

  eddy --imain="$out_dir"/sub-"$subject"_AP_PA_dwi.nii.gz --mask="$out_dir"/sub-"$subject"_topup_AP_PA_b0_nodif_brain_mask.nii.gz --acqp="$bids_dir"/derivatives/dtiprep/config/acq_param.txt --index="$bids_dir"/derivatives/dtiprep/config/index.txt --bvecs="$out_dir"/sub-"$subject"_bvecs_rot --bvals="$out_dir"/sub-"$subject"_bvals --topup="$out_dir"/sub-"$subject"_topup_AP_PO_b0 --out="$out_dir"/sub-"$subject"_eddy --fwhm=0 --flm=quadratic --data_is_shelled --repol --verbose
  # --estimate_move_by_susceptibility not enabled for this version

  sleep 10

  #running dtifit with rescaled bvecs and bvals
  printf "run FSL dtifit \n \n"
  printf "dtifit --data="$out_dir"/sub-"$subject"_eddy.nii.gz --mask="$out_dir"/sub-"$subject"_topup_AP_PA_b0_nodif_brain_mask.nii.gz --bvecs="$out_dir"/sub-"$subject"_bvecs_rescaled_rot --bvals="$out_dir"/sub-"$subject"_bvals_rescaled --out="$out_dir"/sub-"$subject"_dti --verbose \n"

  dtifit --data="$out_dir"/sub-"$subject"_eddy.nii.gz --mask="$out_dir"/sub-"$subject"_topup_AP_PA_b0_nodif_brain_mask.nii.gz --bvecs="$out_dir"/sub-"$subject"_bvecs_rot --bvals="$out_dir"/sub-"$subject"_bvals --out="$out_dir"/sub-"$subject"_dti --verbose

  printf "cleaning up \n \n"
  rm "$out_dir"/ap_vol*
  rm "$out_dir"/pa_vol*
  rm "$out_dir"/b0_??_vol*

  printf "*************** dti preprocessing complete for sub-"$subject" *************** \n \n";
done
