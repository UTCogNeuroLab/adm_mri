---
interact_link: content/tbss.ipynb
kernel_name: python3
has_widgets: false
title: 'preprocessing and tbss'
prev_page:
  url: /intro.html
  title: 'Intro'
next_page:
  url: /rois.html
  title: 'Rois'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
## Preprocessing

1. Run main.sh
2. Inspect all subjects for model fit

## TBSS
We performed analyses separately for older adults and young adults. These analyses were therefore conducted independently in separate directories, tbss_oa and tbss_ya.

1. Move all FA and MD files from DTI preprocessing directory to a new tbss directory
2. We will later rename all the MD files as FA for future TBSS steps. Do not get these mixed up with the actual FA data!



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa

ls -d ${dtifit_dir}/sub-3*/

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30004/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30008/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30009/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30012/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30015/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30019/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30020/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30023/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30040/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30057/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30064/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30066/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30069/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30074/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30085/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30088/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30090/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30091/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30095/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30096/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30116/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30118/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30119/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30128/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30181/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30217/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30227/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30236/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30242/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30255/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30274/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30295/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30330/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30346/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30376/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30395/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30400/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30403/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30412/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30426/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30432/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30466/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30469/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30476/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30478/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30568/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30570/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30581/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30584/
/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep/sub-30588/
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
work_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives

mkdir ${work_dir}/tbss_ya
mkdir ${work_dir}/tbss_oa

for sub_dir in `ls -d ${dtifit_dir}/sub-3*/`; do
    subj=`echo "$sub_dir" | cut -d '-' -f 2 | rev | cut -c 2- | rev`
    echo $subj
    cp "$sub_dir"*FA.nii.gz ${work_dir}/tbss_ya/
done

for sub_dir in `ls -d ${dtifit_dir}/sub-4*/`; do
    subj=`echo "$sub_dir" | cut -d '-' -f 2 | rev | cut -c 2- | rev`
    echo $subj
    cp "$sub_dir"*FA.nii.gz ${work_dir}/tbss_oa/
done

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
30004
30008
30009
30012
30015
30019
30020
30023
30040
30057
30064
30066
30069
30074
30085
30088
30090
30091
30095
30096
30116
30118
30119
30128
30181
30217
30227
30236
30242
30255
30274
30295
30330
30346
30376
30395
30400
30403
30412
30426
30432
30466
30469
30476
30478
30568
30570
30581
30584
30588
40160
40170
40175
40288
40351
40490
40496
40512
40515
40516
40519
40520
40522
40524
40547
40550
40564
40601
40608
40615
40619
40623
40624
40629
40638
40649
40650
40653
40655
40656
40658
40664
40665
40668
40672
40685
40694
40720
40728
40738
40743
40750
40758
40767
40768
40769
40773
40775
40777
40778
40779
40782
40784
40796
40803
40811
40855
40861
40876
40878
```
</div>
</div>
</div>



### TBSS 1 Preprocessing
Erodes FA images and zeroes the end slices to remove likely outliers from the diffusion tensor fitting. Generates a report called slicesdir to allow for quick scanning to detect any major issues.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
tbss_1_preproc *FA.nii.gz

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
processing sub-30004_dti_FA
processing sub-30008_dti_FA
processing sub-30009_dti_FA
processing sub-30012_dti_FA
processing sub-30015_dti_FA
processing sub-30019_dti_FA
processing sub-30020_dti_FA
processing sub-30023_dti_FA
processing sub-30040_dti_FA
processing sub-30057_dti_FA
processing sub-30064_dti_FA
processing sub-30066_dti_FA
processing sub-30069_dti_FA
processing sub-30074_dti_FA
processing sub-30085_dti_FA
processing sub-30088_dti_FA
processing sub-30090_dti_FA
processing sub-30091_dti_FA
processing sub-30095_dti_FA
processing sub-30096_dti_FA
processing sub-30116_dti_FA
processing sub-30118_dti_FA
processing sub-30119_dti_FA
processing sub-30128_dti_FA
processing sub-30181_dti_FA
processing sub-30217_dti_FA
processing sub-30227_dti_FA
processing sub-30236_dti_FA
processing sub-30242_dti_FA
processing sub-30255_dti_FA
processing sub-30274_dti_FA
processing sub-30295_dti_FA
processing sub-30330_dti_FA
processing sub-30346_dti_FA
processing sub-30376_dti_FA
processing sub-30395_dti_FA
processing sub-30400_dti_FA
processing sub-30403_dti_FA
processing sub-30412_dti_FA
processing sub-30426_dti_FA
processing sub-30432_dti_FA
processing sub-30466_dti_FA
processing sub-30469_dti_FA
processing sub-30476_dti_FA
processing sub-30478_dti_FA
processing sub-30568_dti_FA
processing sub-30581_dti_FA
processing sub-30584_dti_FA
processing sub-30588_dti_FA
Now running "slicesdir" to generate report of all input images
Finished. To view, point your web browser at
file:/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya/FA/slicesdir/index.html
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

open -a "Google Chrome" /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya/FA/slicesdir/index.html

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
ls | head -5

tbss_1_preproc *FA.nii.gz

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
sub-40160_dti_FA.nii.gz
sub-40170_dti_FA.nii.gz
sub-40175_dti_FA.nii.gz
sub-40288_dti_FA.nii.gz
sub-40351_dti_FA.nii.gz
processing sub-40160_dti_FA
processing sub-40170_dti_FA
processing sub-40175_dti_FA
processing sub-40288_dti_FA
processing sub-40351_dti_FA
processing sub-40490_dti_FA
processing sub-40496_dti_FA
processing sub-40512_dti_FA
processing sub-40515_dti_FA
processing sub-40516_dti_FA
processing sub-40519_dti_FA
processing sub-40520_dti_FA
processing sub-40522_dti_FA
processing sub-40524_dti_FA
processing sub-40547_dti_FA
processing sub-40550_dti_FA
processing sub-40564_dti_FA
processing sub-40601_dti_FA
processing sub-40608_dti_FA
processing sub-40615_dti_FA
processing sub-40619_dti_FA
processing sub-40623_dti_FA
processing sub-40624_dti_FA
processing sub-40629_dti_FA
processing sub-40638_dti_FA
processing sub-40649_dti_FA
processing sub-40650_dti_FA
processing sub-40653_dti_FA
processing sub-40655_dti_FA
processing sub-40656_dti_FA
processing sub-40658_dti_FA
processing sub-40664_dti_FA
processing sub-40665_dti_FA
processing sub-40668_dti_FA
processing sub-40672_dti_FA
processing sub-40685_dti_FA
processing sub-40694_dti_FA
processing sub-40720_dti_FA
processing sub-40728_dti_FA
processing sub-40738_dti_FA
processing sub-40743_dti_FA
processing sub-40750_dti_FA
processing sub-40758_dti_FA
processing sub-40767_dti_FA
processing sub-40768_dti_FA
processing sub-40769_dti_FA
processing sub-40773_dti_FA
processing sub-40775_dti_FA
processing sub-40777_dti_FA
processing sub-40778_dti_FA
processing sub-40779_dti_FA
processing sub-40782_dti_FA
processing sub-40784_dti_FA
processing sub-40796_dti_FA
processing sub-40803_dti_FA
processing sub-40811_dti_FA
processing sub-40861_dti_FA
processing sub-40876_dti_FA
processing sub-40878_dti_FA
Now running "slicesdir" to generate report of all input images
Finished. To view, point your web browser at
file:/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa/FA/slicesdir/index.html
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

open -a "Google Chrome" /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa/FA/slicesdir/index.html

```
</div>

</div>



### Note 02-20-2020
I removed subjects 30330, 30476, 30227, 40515, and 40516 from analysis due to artifact.

FLIRT version 6.0



### TBSS 2 Registration
Runs the nonlinear registration, aligning all FA images to a 1x1x1mm standard space. We will use the -n option, which aligns every FA image to every other one. In the next step, we will identify the "most representative" one, and use this as the target image. This target image is then affine-aligned into MNI152 standard space, and every image is transformed into 1x1x1mm MNI152 space by combining the nonlinear transform to the target FA image with the affine transform from that target to MNI152 space.

This is highly computationally intensive, so we will run this on TACC to speed things up.



From your local machine, enter this command to move the TBSS directories to TACC. You will need to enter your TACC password and verification code to complete the file transfer.

`scp -r /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya username@stampede2.tacc.utexas.edu:/path/to/destination/`

`scp -r /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa username@stampede2.tacc.utexas.edu:/path/to/destination/`



Log into TACC using `ssh username@stampede2.tacc.utexas.edu`.

`cd path/to/destination/tbss_ya`

From a login node, run the tbss_2_reg command: <br>
`tbss_2_reg -n`. 

Do the same for older adults: <br>
`cd path/to/destination/tbss_oa`

From a login node, run the tbss_2_reg command: <br>
`tbss_2_reg -n`

This will submit 2 jobs to the queue. You can check the status of the jobs with `squeue -u username`. Wait for them to complete before moving forward.

A quick check to make sure it ran properly is: <br>
`ls tbss_ya/sub-30020* | wc -l`

For one subject, there should be (N subjects * 4) + 2 (FA and FA mask) files. In this case, we have 49 subjects, and 198 files.




### TBSS 3 Post-registration
Applies the nonlinear transforms found in the previous stage to all subjects to bring them into standard space.
This will first make the decision about which of the FA images is the most "typical", for selection as the target image to apply all nonlinear transformations into the space of. This happens by taking each FA image in turn, and estimating the average amount of warping that was necessary to align all other images to it, then finding the one that had the smallest amount of average warping when used as a target.

From the login node on TACC:

`cd /path/to/destination/tbss_ya` <br>
`tbss_3_postreg -S`

`cd /path/to/destination/tbss_oa` <br>
`tbss_3_postreg -S`

We will get a message about what the best target subject is for each group. In this case, that was: <br>

```bash

best target is sub-40782_dti_FA_FA - now registering this to standard space

best target is sub-30255_dti_FA_FA - now registering this to standard space
```

When that finishes up, we will need to transfer the results back to the local machine for inspection and to continue with analysis.

From your local machine, this can be done with:

`scp -r username@stampede2.tacc.utexas.edu:/path/to/destination/tbss_ya /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/`

`scp -r username@stampede2.tacc.utexas.edu:/path/to/destination/tbss_oa /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/ `

Again, you will need your TACC password and the verification code.



### QA

Now check all_FA and mean_FA_mask for any outliers or artifacts.



We restricted mean_FA_mask values to values between 0.2 and 1, since the mask output from tbss_3_postreg covers more than the white matter. This will reduce the area used in permutation testing with TFCE and increase the power of our analysis.



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa/stats
fslmaths mean_FA -thr 0.2 -uthr 1 -bin mean_FA_mask_thr20.nii.gz
fslmaths mean_FA -thr 0.22 -uthr 1 -bin mean_FA_mask_thr22.nii.gz
fslmaths mean_FA -thr 0.3 -uthr 1 -bin mean_FA_mask_thr30.nii.gz

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya/stats
fslmaths mean_FA -thr 0.2 -uthr 1 -bin mean_FA_mask_thr20.nii.gz
fslmaths mean_FA -thr 0.22 -uthr 1 -bin mean_FA_mask_thr22.nii.gz
fslmaths mean_FA -thr 0.3 -uthr 1 -bin mean_FA_mask_thr30.nii.gz

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa/stats
fsleyes all_FA -b 0,0.8 mean_FA_skeleton -b 0.2,0.8 -l Green &

```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
tbss_4_prestats 0.22 #replace 0.2 if need to change it

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
creating skeleton mask using threshold 0.22
creating skeleton distancemap (for use in projection search)
projecting all FA data onto skeleton

now run stats - for example:
randomise -i all_FA_skeletonised -o tbss -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V
(after generating design.mat and design.con)
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
tbss_4_prestats 0.22 #replace 0.2 if need to change it

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
creating skeleton mask using threshold 0.22
creating skeleton distancemap (for use in projection search)
projecting all FA data onto skeleton

now run stats - for example:
randomise -i all_FA_skeletonised -o tbss -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V
(after generating design.mat and design.con)
```
</div>
</div>
</div>



Now we're going to run TBSS on the MD, AD, and RD data



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa

mkdir ${tbss_dir}/MD
mkdir ${tbss_dir}/AD
mkdir ${tbss_dir}/RD

for sub_dir in ${dtifit_dir}/sub-4*/; do
    subj=`echo "$sub_dir" | cut -d '-' -f 2 | rev | cut -c 2- | rev`
    echo $subj
    cp "$sub_dir"*_MD.nii.gz ${tbss_dir}/MD/
    cp "$sub_dir"*_L1.nii.gz ${tbss_dir}/AD/
    fslmaths ${sub_dir}*_L2.nii.gz -add ${sub_dir}*_L3.nii.gz -div 2 ${tbss_dir}/RD/sub-${subj}_dti_RD.nii.gz
done

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
40160
40170
40175
40288
40351
40490
40496
40512
40515
40516
40519
40520
40522
40524
40547
40550
40564
40601
40608
40615
40619
40623
40624
40629
40638
40649
40650
40653
40655
40656
40658
40664
40665
40668
40672
40685
40694
40720
40728
40738
40743
40750
40758
40767
40768
40769
40773
40775
40777
40778
40779
40782
40784
40796
40803
40811
40855
40861
40876
40878
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya

mkdir ${tbss_dir}/MD
mkdir ${tbss_dir}/AD
mkdir ${tbss_dir}/RD

for sub_dir in ${dtifit_dir}/sub-3*/; do
    subj=`echo "$sub_dir" | cut -d '-' -f 2 | rev | cut -c 2- | rev`
    echo $subj
    cp "$sub_dir"*_MD.nii.gz ${tbss_dir}/MD/
    cp "$sub_dir"*_L1.nii.gz ${tbss_dir}/AD/
    fslmaths ${sub_dir}*_L2.nii.gz -add ${sub_dir}*_L3.nii.gz -div 2 ${tbss_dir}/RD/sub-${subj}_dti_RD.nii.gz
done

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
30004
30008
30009
30012
30015
30019
30020
30023
30040
30057
30064
30066
30069
30074
30085
30088
30090
30091
30095
30096
30116
30118
30119
30128
30181
30217
30227
30236
30242
30255
30274
30295
30330
30346
30376
30395
30400
30403
30412
30426
30432
30466
30469
30476
30478
30568
30570
30581
30584
30588
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa

cd ${tbss_dir}/MD/
for file in `ls ${tbss_dir}/MD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

cd ${tbss_dir}/AD/
for file in `ls ${tbss_dir}/AD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

cd ${tbss_dir}/RD/
for file in `ls ${tbss_dir}/RD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
mv sub-40160_dti_MD.nii.gz sub-40160_dti_FA.nii.gz
mv sub-40170_dti_MD.nii.gz sub-40170_dti_FA.nii.gz
mv sub-40175_dti_MD.nii.gz sub-40175_dti_FA.nii.gz
mv sub-40288_dti_MD.nii.gz sub-40288_dti_FA.nii.gz
mv sub-40351_dti_MD.nii.gz sub-40351_dti_FA.nii.gz
mv sub-40490_dti_MD.nii.gz sub-40490_dti_FA.nii.gz
mv sub-40496_dti_MD.nii.gz sub-40496_dti_FA.nii.gz
mv sub-40512_dti_MD.nii.gz sub-40512_dti_FA.nii.gz
mv sub-40515_dti_MD.nii.gz sub-40515_dti_FA.nii.gz
mv sub-40516_dti_MD.nii.gz sub-40516_dti_FA.nii.gz
mv sub-40519_dti_MD.nii.gz sub-40519_dti_FA.nii.gz
mv sub-40520_dti_MD.nii.gz sub-40520_dti_FA.nii.gz
mv sub-40522_dti_MD.nii.gz sub-40522_dti_FA.nii.gz
mv sub-40524_dti_MD.nii.gz sub-40524_dti_FA.nii.gz
mv sub-40547_dti_MD.nii.gz sub-40547_dti_FA.nii.gz
mv sub-40550_dti_MD.nii.gz sub-40550_dti_FA.nii.gz
mv sub-40564_dti_MD.nii.gz sub-40564_dti_FA.nii.gz
mv sub-40601_dti_MD.nii.gz sub-40601_dti_FA.nii.gz
mv sub-40608_dti_MD.nii.gz sub-40608_dti_FA.nii.gz
mv sub-40615_dti_MD.nii.gz sub-40615_dti_FA.nii.gz
mv sub-40619_dti_MD.nii.gz sub-40619_dti_FA.nii.gz
mv sub-40623_dti_MD.nii.gz sub-40623_dti_FA.nii.gz
mv sub-40624_dti_MD.nii.gz sub-40624_dti_FA.nii.gz
mv sub-40629_dti_MD.nii.gz sub-40629_dti_FA.nii.gz
mv sub-40638_dti_MD.nii.gz sub-40638_dti_FA.nii.gz
mv sub-40649_dti_MD.nii.gz sub-40649_dti_FA.nii.gz
mv sub-40650_dti_MD.nii.gz sub-40650_dti_FA.nii.gz
mv sub-40653_dti_MD.nii.gz sub-40653_dti_FA.nii.gz
mv sub-40655_dti_MD.nii.gz sub-40655_dti_FA.nii.gz
mv sub-40656_dti_MD.nii.gz sub-40656_dti_FA.nii.gz
mv sub-40658_dti_MD.nii.gz sub-40658_dti_FA.nii.gz
mv sub-40664_dti_MD.nii.gz sub-40664_dti_FA.nii.gz
mv sub-40665_dti_MD.nii.gz sub-40665_dti_FA.nii.gz
mv sub-40668_dti_MD.nii.gz sub-40668_dti_FA.nii.gz
mv sub-40672_dti_MD.nii.gz sub-40672_dti_FA.nii.gz
mv sub-40685_dti_MD.nii.gz sub-40685_dti_FA.nii.gz
mv sub-40694_dti_MD.nii.gz sub-40694_dti_FA.nii.gz
mv sub-40720_dti_MD.nii.gz sub-40720_dti_FA.nii.gz
mv sub-40728_dti_MD.nii.gz sub-40728_dti_FA.nii.gz
mv sub-40738_dti_MD.nii.gz sub-40738_dti_FA.nii.gz
mv sub-40743_dti_MD.nii.gz sub-40743_dti_FA.nii.gz
mv sub-40750_dti_MD.nii.gz sub-40750_dti_FA.nii.gz
mv sub-40758_dti_MD.nii.gz sub-40758_dti_FA.nii.gz
mv sub-40767_dti_MD.nii.gz sub-40767_dti_FA.nii.gz
mv sub-40768_dti_MD.nii.gz sub-40768_dti_FA.nii.gz
mv sub-40769_dti_MD.nii.gz sub-40769_dti_FA.nii.gz
mv sub-40773_dti_MD.nii.gz sub-40773_dti_FA.nii.gz
mv sub-40775_dti_MD.nii.gz sub-40775_dti_FA.nii.gz
mv sub-40777_dti_MD.nii.gz sub-40777_dti_FA.nii.gz
mv sub-40778_dti_MD.nii.gz sub-40778_dti_FA.nii.gz
mv sub-40779_dti_MD.nii.gz sub-40779_dti_FA.nii.gz
mv sub-40782_dti_MD.nii.gz sub-40782_dti_FA.nii.gz
mv sub-40784_dti_MD.nii.gz sub-40784_dti_FA.nii.gz
mv sub-40796_dti_MD.nii.gz sub-40796_dti_FA.nii.gz
mv sub-40803_dti_MD.nii.gz sub-40803_dti_FA.nii.gz
mv sub-40811_dti_MD.nii.gz sub-40811_dti_FA.nii.gz
mv sub-40861_dti_MD.nii.gz sub-40861_dti_FA.nii.gz
mv sub-40876_dti_MD.nii.gz sub-40876_dti_FA.nii.gz
mv sub-40878_dti_MD.nii.gz sub-40878_dti_FA.nii.gz
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

dtifit_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/dtiprep
tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya

cd ${tbss_dir}/MD/
for file in `ls ${tbss_dir}/MD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

cd ${tbss_dir}/AD/
for file in `ls ${tbss_dir}/AD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

cd ${tbss_dir}/RD/
for file in `ls ${tbss_dir}/RD/`
do
  subj=`echo "$file" | cut -c5-9`
  echo mv "$file" "sub-${subj}_dti_FA.nii.gz"
  mv "$file" "sub-${subj}_dti_FA.nii.gz"
done

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
mv sub-30004_dti_MD.nii.gz sub-30004_dti_FA.nii.gz
mv sub-30008_dti_MD.nii.gz sub-30008_dti_FA.nii.gz
mv sub-30009_dti_MD.nii.gz sub-30009_dti_FA.nii.gz
mv sub-30012_dti_MD.nii.gz sub-30012_dti_FA.nii.gz
mv sub-30015_dti_MD.nii.gz sub-30015_dti_FA.nii.gz
mv sub-30019_dti_MD.nii.gz sub-30019_dti_FA.nii.gz
mv sub-30020_dti_MD.nii.gz sub-30020_dti_FA.nii.gz
mv sub-30023_dti_MD.nii.gz sub-30023_dti_FA.nii.gz
mv sub-30040_dti_MD.nii.gz sub-30040_dti_FA.nii.gz
mv sub-30057_dti_MD.nii.gz sub-30057_dti_FA.nii.gz
mv sub-30064_dti_MD.nii.gz sub-30064_dti_FA.nii.gz
mv sub-30066_dti_MD.nii.gz sub-30066_dti_FA.nii.gz
mv sub-30069_dti_MD.nii.gz sub-30069_dti_FA.nii.gz
mv sub-30074_dti_MD.nii.gz sub-30074_dti_FA.nii.gz
mv sub-30085_dti_MD.nii.gz sub-30085_dti_FA.nii.gz
mv sub-30088_dti_MD.nii.gz sub-30088_dti_FA.nii.gz
mv sub-30090_dti_MD.nii.gz sub-30090_dti_FA.nii.gz
mv sub-30091_dti_MD.nii.gz sub-30091_dti_FA.nii.gz
mv sub-30095_dti_MD.nii.gz sub-30095_dti_FA.nii.gz
mv sub-30096_dti_MD.nii.gz sub-30096_dti_FA.nii.gz
mv sub-30116_dti_MD.nii.gz sub-30116_dti_FA.nii.gz
mv sub-30118_dti_MD.nii.gz sub-30118_dti_FA.nii.gz
mv sub-30119_dti_MD.nii.gz sub-30119_dti_FA.nii.gz
mv sub-30128_dti_MD.nii.gz sub-30128_dti_FA.nii.gz
mv sub-30181_dti_MD.nii.gz sub-30181_dti_FA.nii.gz
mv sub-30217_dti_MD.nii.gz sub-30217_dti_FA.nii.gz
mv sub-30227_dti_MD.nii.gz sub-30227_dti_FA.nii.gz
mv sub-30236_dti_MD.nii.gz sub-30236_dti_FA.nii.gz
mv sub-30242_dti_MD.nii.gz sub-30242_dti_FA.nii.gz
mv sub-30255_dti_MD.nii.gz sub-30255_dti_FA.nii.gz
mv sub-30274_dti_MD.nii.gz sub-30274_dti_FA.nii.gz
mv sub-30295_dti_MD.nii.gz sub-30295_dti_FA.nii.gz
mv sub-30330_dti_MD.nii.gz sub-30330_dti_FA.nii.gz
mv sub-30346_dti_MD.nii.gz sub-30346_dti_FA.nii.gz
mv sub-30376_dti_MD.nii.gz sub-30376_dti_FA.nii.gz
mv sub-30395_dti_MD.nii.gz sub-30395_dti_FA.nii.gz
mv sub-30400_dti_MD.nii.gz sub-30400_dti_FA.nii.gz
mv sub-30403_dti_MD.nii.gz sub-30403_dti_FA.nii.gz
mv sub-30412_dti_MD.nii.gz sub-30412_dti_FA.nii.gz
mv sub-30426_dti_MD.nii.gz sub-30426_dti_FA.nii.gz
mv sub-30432_dti_MD.nii.gz sub-30432_dti_FA.nii.gz
mv sub-30466_dti_MD.nii.gz sub-30466_dti_FA.nii.gz
mv sub-30469_dti_MD.nii.gz sub-30469_dti_FA.nii.gz
mv sub-30476_dti_MD.nii.gz sub-30476_dti_FA.nii.gz
mv sub-30478_dti_MD.nii.gz sub-30478_dti_FA.nii.gz
mv sub-30568_dti_MD.nii.gz sub-30568_dti_FA.nii.gz
mv sub-30581_dti_MD.nii.gz sub-30581_dti_FA.nii.gz
mv sub-30584_dti_MD.nii.gz sub-30584_dti_FA.nii.gz
mv sub-30588_dti_MD.nii.gz sub-30588_dti_FA.nii.gz
mv sub-30004_dti_L1.nii.gz sub-30004_dti_FA.nii.gz
mv sub-30008_dti_L1.nii.gz sub-30008_dti_FA.nii.gz
mv sub-30009_dti_L1.nii.gz sub-30009_dti_FA.nii.gz
mv sub-30012_dti_L1.nii.gz sub-30012_dti_FA.nii.gz
mv sub-30015_dti_L1.nii.gz sub-30015_dti_FA.nii.gz
mv sub-30019_dti_L1.nii.gz sub-30019_dti_FA.nii.gz
mv sub-30020_dti_L1.nii.gz sub-30020_dti_FA.nii.gz
mv sub-30023_dti_L1.nii.gz sub-30023_dti_FA.nii.gz
mv sub-30040_dti_L1.nii.gz sub-30040_dti_FA.nii.gz
mv sub-30057_dti_L1.nii.gz sub-30057_dti_FA.nii.gz
mv sub-30064_dti_L1.nii.gz sub-30064_dti_FA.nii.gz
mv sub-30066_dti_L1.nii.gz sub-30066_dti_FA.nii.gz
mv sub-30069_dti_L1.nii.gz sub-30069_dti_FA.nii.gz
mv sub-30074_dti_L1.nii.gz sub-30074_dti_FA.nii.gz
mv sub-30085_dti_L1.nii.gz sub-30085_dti_FA.nii.gz
mv sub-30088_dti_L1.nii.gz sub-30088_dti_FA.nii.gz
mv sub-30090_dti_L1.nii.gz sub-30090_dti_FA.nii.gz
mv sub-30091_dti_L1.nii.gz sub-30091_dti_FA.nii.gz
mv sub-30095_dti_L1.nii.gz sub-30095_dti_FA.nii.gz
mv sub-30096_dti_L1.nii.gz sub-30096_dti_FA.nii.gz
mv sub-30116_dti_L1.nii.gz sub-30116_dti_FA.nii.gz
mv sub-30118_dti_L1.nii.gz sub-30118_dti_FA.nii.gz
mv sub-30119_dti_L1.nii.gz sub-30119_dti_FA.nii.gz
mv sub-30128_dti_L1.nii.gz sub-30128_dti_FA.nii.gz
mv sub-30181_dti_L1.nii.gz sub-30181_dti_FA.nii.gz
mv sub-30217_dti_L1.nii.gz sub-30217_dti_FA.nii.gz
mv sub-30227_dti_L1.nii.gz sub-30227_dti_FA.nii.gz
mv sub-30236_dti_L1.nii.gz sub-30236_dti_FA.nii.gz
mv sub-30242_dti_L1.nii.gz sub-30242_dti_FA.nii.gz
mv sub-30255_dti_L1.nii.gz sub-30255_dti_FA.nii.gz
mv sub-30274_dti_L1.nii.gz sub-30274_dti_FA.nii.gz
mv sub-30295_dti_L1.nii.gz sub-30295_dti_FA.nii.gz
mv sub-30330_dti_L1.nii.gz sub-30330_dti_FA.nii.gz
mv sub-30346_dti_L1.nii.gz sub-30346_dti_FA.nii.gz
mv sub-30376_dti_L1.nii.gz sub-30376_dti_FA.nii.gz
mv sub-30395_dti_L1.nii.gz sub-30395_dti_FA.nii.gz
mv sub-30400_dti_L1.nii.gz sub-30400_dti_FA.nii.gz
mv sub-30403_dti_L1.nii.gz sub-30403_dti_FA.nii.gz
mv sub-30412_dti_L1.nii.gz sub-30412_dti_FA.nii.gz
mv sub-30426_dti_L1.nii.gz sub-30426_dti_FA.nii.gz
mv sub-30432_dti_L1.nii.gz sub-30432_dti_FA.nii.gz
mv sub-30466_dti_L1.nii.gz sub-30466_dti_FA.nii.gz
mv sub-30469_dti_L1.nii.gz sub-30469_dti_FA.nii.gz
mv sub-30476_dti_L1.nii.gz sub-30476_dti_FA.nii.gz
mv sub-30478_dti_L1.nii.gz sub-30478_dti_FA.nii.gz
mv sub-30568_dti_L1.nii.gz sub-30568_dti_FA.nii.gz
mv sub-30581_dti_L1.nii.gz sub-30581_dti_FA.nii.gz
mv sub-30584_dti_L1.nii.gz sub-30584_dti_FA.nii.gz
mv sub-30588_dti_L1.nii.gz sub-30588_dti_FA.nii.gz
mv sub-30004_dti_RD.nii.gz sub-30004_dti_FA.nii.gz
mv sub-30008_dti_RD.nii.gz sub-30008_dti_FA.nii.gz
mv sub-30009_dti_RD.nii.gz sub-30009_dti_FA.nii.gz
mv sub-30012_dti_RD.nii.gz sub-30012_dti_FA.nii.gz
mv sub-30015_dti_RD.nii.gz sub-30015_dti_FA.nii.gz
mv sub-30019_dti_RD.nii.gz sub-30019_dti_FA.nii.gz
mv sub-30020_dti_RD.nii.gz sub-30020_dti_FA.nii.gz
mv sub-30023_dti_RD.nii.gz sub-30023_dti_FA.nii.gz
mv sub-30040_dti_RD.nii.gz sub-30040_dti_FA.nii.gz
mv sub-30057_dti_RD.nii.gz sub-30057_dti_FA.nii.gz
mv sub-30064_dti_RD.nii.gz sub-30064_dti_FA.nii.gz
mv sub-30066_dti_RD.nii.gz sub-30066_dti_FA.nii.gz
mv sub-30069_dti_RD.nii.gz sub-30069_dti_FA.nii.gz
mv sub-30074_dti_RD.nii.gz sub-30074_dti_FA.nii.gz
mv sub-30085_dti_RD.nii.gz sub-30085_dti_FA.nii.gz
mv sub-30088_dti_RD.nii.gz sub-30088_dti_FA.nii.gz
mv sub-30090_dti_RD.nii.gz sub-30090_dti_FA.nii.gz
mv sub-30091_dti_RD.nii.gz sub-30091_dti_FA.nii.gz
mv sub-30095_dti_RD.nii.gz sub-30095_dti_FA.nii.gz
mv sub-30096_dti_RD.nii.gz sub-30096_dti_FA.nii.gz
mv sub-30116_dti_RD.nii.gz sub-30116_dti_FA.nii.gz
mv sub-30118_dti_RD.nii.gz sub-30118_dti_FA.nii.gz
mv sub-30119_dti_RD.nii.gz sub-30119_dti_FA.nii.gz
mv sub-30128_dti_RD.nii.gz sub-30128_dti_FA.nii.gz
mv sub-30181_dti_RD.nii.gz sub-30181_dti_FA.nii.gz
mv sub-30217_dti_RD.nii.gz sub-30217_dti_FA.nii.gz
mv sub-30227_dti_RD.nii.gz sub-30227_dti_FA.nii.gz
mv sub-30236_dti_RD.nii.gz sub-30236_dti_FA.nii.gz
mv sub-30242_dti_RD.nii.gz sub-30242_dti_FA.nii.gz
mv sub-30255_dti_RD.nii.gz sub-30255_dti_FA.nii.gz
mv sub-30274_dti_RD.nii.gz sub-30274_dti_FA.nii.gz
mv sub-30295_dti_RD.nii.gz sub-30295_dti_FA.nii.gz
mv sub-30330_dti_RD.nii.gz sub-30330_dti_FA.nii.gz
mv sub-30346_dti_RD.nii.gz sub-30346_dti_FA.nii.gz
mv sub-30376_dti_RD.nii.gz sub-30376_dti_FA.nii.gz
mv sub-30395_dti_RD.nii.gz sub-30395_dti_FA.nii.gz
mv sub-30400_dti_RD.nii.gz sub-30400_dti_FA.nii.gz
mv sub-30403_dti_RD.nii.gz sub-30403_dti_FA.nii.gz
mv sub-30412_dti_RD.nii.gz sub-30412_dti_FA.nii.gz
mv sub-30426_dti_RD.nii.gz sub-30426_dti_FA.nii.gz
mv sub-30432_dti_RD.nii.gz sub-30432_dti_FA.nii.gz
mv sub-30466_dti_RD.nii.gz sub-30466_dti_FA.nii.gz
mv sub-30469_dti_RD.nii.gz sub-30469_dti_FA.nii.gz
mv sub-30476_dti_RD.nii.gz sub-30476_dti_FA.nii.gz
mv sub-30478_dti_RD.nii.gz sub-30478_dti_FA.nii.gz
mv sub-30568_dti_RD.nii.gz sub-30568_dti_FA.nii.gz
mv sub-30581_dti_RD.nii.gz sub-30581_dti_FA.nii.gz
mv sub-30584_dti_RD.nii.gz sub-30584_dti_FA.nii.gz
mv sub-30588_dti_RD.nii.gz sub-30588_dti_FA.nii.gz
```
</div>
</div>
</div>



To run the tbss_non_FA script, I had to make one modification to get it to work:

```bash

#for f in `$FSLDIR/bin/imglob *_FA.*` ; do #edited MCM 02-21-2020
for f in  `$FSLDIR/bin/imglob *_FA.nii* *_FA.img* *_FA.hdr*`; do
```



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
#tbss_non_FA MD
#tbss_non_FA AD
tbss_non_FA RD

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
using pre-chosen registration target: sub-40728_dti_FA_FA
upsampling alternative images into standard space
sub-40160_dti_FA
sub-40170_dti_FA
sub-40175_dti_FA
sub-40288_dti_FA
sub-40351_dti_FA
sub-40490_dti_FA
sub-40496_dti_FA
sub-40512_dti_FA
sub-40519_dti_FA
sub-40520_dti_FA
sub-40522_dti_FA
sub-40524_dti_FA
sub-40547_dti_FA
sub-40550_dti_FA
sub-40564_dti_FA
sub-40601_dti_FA
sub-40608_dti_FA
sub-40615_dti_FA
sub-40619_dti_FA
sub-40623_dti_FA
sub-40624_dti_FA
sub-40629_dti_FA
sub-40638_dti_FA
sub-40649_dti_FA
sub-40650_dti_FA
sub-40653_dti_FA
sub-40655_dti_FA
sub-40656_dti_FA
sub-40658_dti_FA
sub-40664_dti_FA
sub-40665_dti_FA
sub-40668_dti_FA
sub-40672_dti_FA
sub-40685_dti_FA
sub-40694_dti_FA
sub-40720_dti_FA
sub-40728_dti_FA
sub-40738_dti_FA
sub-40743_dti_FA
sub-40750_dti_FA
sub-40758_dti_FA
sub-40767_dti_FA
sub-40768_dti_FA
sub-40769_dti_FA
sub-40773_dti_FA
sub-40775_dti_FA
sub-40777_dti_FA
sub-40778_dti_FA
sub-40779_dti_FA
sub-40782_dti_FA
sub-40784_dti_FA
sub-40796_dti_FA
sub-40803_dti_FA
sub-40811_dti_FA
sub-40861_dti_FA
sub-40876_dti_FA
sub-40878_dti_FA
merging all upsampled RD images into single 4D image
projecting all_RD onto mean FA skeleton
now run stats - for example:
randomise -i all_RD_skeletonised -o tbss_RD -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V
(after generating design.mat and design.con)
```
</div>
</div>
</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

cd /Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
tbss_non_FA MD
tbss_non_FA AD
tbss_non_FA RD

```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
using pre-chosen registration target: sub-30255_dti_FA_FA
upsampling alternative images into standard space
sub-30004_dti_FA
sub-30008_dti_FA
sub-30009_dti_FA
sub-30012_dti_FA
sub-30015_dti_FA
sub-30019_dti_FA
sub-30020_dti_FA
sub-30023_dti_FA
sub-30040_dti_FA
sub-30057_dti_FA
sub-30064_dti_FA
sub-30066_dti_FA
sub-30069_dti_FA
sub-30074_dti_FA
sub-30085_dti_FA
sub-30088_dti_FA
sub-30090_dti_FA
sub-30091_dti_FA
sub-30095_dti_FA
sub-30096_dti_FA
sub-30116_dti_FA
sub-30118_dti_FA
sub-30119_dti_FA
sub-30128_dti_FA
sub-30181_dti_FA
sub-30217_dti_FA
sub-30236_dti_FA
sub-30242_dti_FA
sub-30255_dti_FA
sub-30274_dti_FA
sub-30295_dti_FA
sub-30346_dti_FA
sub-30376_dti_FA
sub-30395_dti_FA
sub-30400_dti_FA
sub-30403_dti_FA
sub-30412_dti_FA
sub-30426_dti_FA
sub-30432_dti_FA
sub-30466_dti_FA
sub-30469_dti_FA
sub-30478_dti_FA
sub-30568_dti_FA
sub-30581_dti_FA
sub-30584_dti_FA
sub-30588_dti_FA
merging all upsampled MD images into single 4D image
projecting all_MD onto mean FA skeleton
now run stats - for example:
randomise -i all_MD_skeletonised -o tbss_MD -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V
(after generating design.mat and design.con)
using pre-chosen registration target: sub-30255_dti_FA_FA
upsampling alternative images into standard space
sub-30004_dti_FA
sub-30008_dti_FA
sub-30009_dti_FA
sub-30012_dti_FA
sub-30015_dti_FA
sub-30019_dti_FA
sub-30020_dti_FA
sub-30023_dti_FA
sub-30040_dti_FA
sub-30057_dti_FA
sub-30064_dti_FA
sub-30066_dti_FA
sub-30069_dti_FA
sub-30074_dti_FA
sub-30085_dti_FA
sub-30088_dti_FA
sub-30090_dti_FA
sub-30091_dti_FA
sub-30095_dti_FA
sub-30096_dti_FA
sub-30116_dti_FA
sub-30118_dti_FA
sub-30119_dti_FA
sub-30128_dti_FA
sub-30181_dti_FA
sub-30217_dti_FA
sub-30236_dti_FA
sub-30242_dti_FA
sub-30255_dti_FA
sub-30274_dti_FA
sub-30295_dti_FA
sub-30346_dti_FA
sub-30376_dti_FA
sub-30395_dti_FA
sub-30400_dti_FA
sub-30403_dti_FA
sub-30412_dti_FA
sub-30426_dti_FA
sub-30432_dti_FA
sub-30466_dti_FA
sub-30469_dti_FA
sub-30478_dti_FA
sub-30568_dti_FA
sub-30581_dti_FA
sub-30584_dti_FA
sub-30588_dti_FA
merging all upsampled AD images into single 4D image
projecting all_AD onto mean FA skeleton
now run stats - for example:
randomise -i all_AD_skeletonised -o tbss_AD -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V
(after generating design.mat and design.con)
using pre-chosen registration target: sub-30255_dti_FA_FA
upsampling alternative images into standard space
sub-30004_dti_FA
sub-30008_dti_FA
sub-30009_dti_FA
sub-30012_dti_FA
sub-30015_dti_FA
sub-30019_dti_FA
sub-30020_dti_FA
sub-30023_dti_FA
sub-30040_dti_FA
sub-30057_dti_FA
sub-30064_dti_FA
sub-30066_dti_FA
sub-30069_dti_FA
sub-30074_dti_FA
sub-30085_dti_FA
sub-30088_dti_FA
sub-30090_dti_FA
sub-30091_dti_FA
sub-30095_dti_FA
sub-30096_dti_FA
sub-30116_dti_FA
sub-30118_dti_FA
sub-30119_dti_FA
sub-30128_dti_FA
sub-30181_dti_FA
sub-30217_dti_FA
sub-30236_dti_FA
sub-30242_dti_FA
sub-30255_dti_FA
sub-30274_dti_FA
sub-30295_dti_FA
sub-30346_dti_FA
sub-30376_dti_FA
sub-30395_dti_FA
sub-30400_dti_FA
sub-30403_dti_FA
sub-30412_dti_FA
sub-30426_dti_FA
sub-30432_dti_FA
sub-30466_dti_FA
sub-30469_dti_FA
sub-30478_dti_FA
sub-30568_dti_FA
sub-30581_dti_FA
sub-30584_dti_FA
sub-30588_dti_FA
merging all upsampled RD images into single 4D image
projecting all_RD onto mean FA skeleton
now run stats - for example:
randomise -i all_RD_skeletonised -o tbss_RD -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V
(after generating design.mat and design.con)
```
</div>
</div>
</div>



## Extract mean FA, MD, AD, RD in ROI



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash

tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_ya
cd ${tbss_dir}/roi
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 ${tbss_dir}/roi/cc.nii.gz
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 3 ${tbss_dir}/roi/genu.nii.gz

tbss_dir=/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss_oa
cd ${tbss_dir}/roi
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 5 ${tbss_dir}/roi/cc.nii.gz
fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr 3 -uthr 3 ${tbss_dir}/roi/genu.nii.gz



```
</div>

</div>



<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```bash%%bash
# cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_oa/stats
# for mask in `ls ../../roi`; do
# fslmeants -i all_FA_skeletonised -m ${mask} -o ${mask}-meants.txt
# done

cd /Volumes/G-DRIVE\ mobile/derivatives/tbss_ya/stats
for mask in `ls ../../roi`; do
echo `fslmeants -i all_FA_skeletonised -m ${mask} -o ${mask}"-meants".txt`
done


```
</div>

</div>

