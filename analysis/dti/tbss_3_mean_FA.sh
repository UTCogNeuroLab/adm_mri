# create mean FA
echo "creating valid mask and mean FA"
$FSLDIR/bin/fslmaths all_FA -max 0 -Tmin -bin mean_FA_mask -odt char
$FSLDIR/bin/fslmaths all_FA -mas mean_FA_mask all_FA
$FSLDIR/bin/fslmaths all_FA -Tmean mean_FA

# create skeleton
if [ $SKELETON = 0 ] ; then
    echo "skeletonising mean FA"
    $FSLDIR/bin/tbss_skeleton -i mean_FA -o mean_FA_skeleton
else
    $FSLDIR/bin/fslmaths $FSLDIR/data/standard/FMRIB58_FA_1mm -mas mean_FA_mask mean_FA
    $FSLDIR/bin/fslmaths mean_FA -bin mean_FA_mask
    $FSLDIR/bin/fslmaths all_FA -mas mean_FA_mask all_FA
    $FSLDIR/bin/imcp $FSLDIR/data/standard/FMRIB58_FA-skeleton_1mm mean_FA_skeleton
fi

echo "now view mean_FA_skeleton to check whether the default threshold of 0.2 needs changing, when running:"
echo "tbss_4_prestats <threshold>"

thresh=0.2

echo "creating skeleton mask using threshold $thresh"
echo $thresh > thresh.txt
${FSLDIR}/bin/fslmaths mean_FA_skeleton -thr $thresh -bin mean_FA_skeleton_mask

echo "creating skeleton distancemap (for use in projection search)"
${FSLDIR}/bin/fslmaths mean_FA_mask -mul -1 -add 1 -add mean_FA_skeleton_mask mean_FA_skeleton_mask_dst
${FSLDIR}/bin/distancemap -i mean_FA_skeleton_mask_dst -o mean_FA_skeleton_mask_dst

echo "projecting all FA data onto skeleton"
${FSLDIR}/bin/tbss_skeleton -i mean_FA -p $thresh mean_FA_skeleton_mask_dst ${FSLDIR}/data/standard/LowerCingulum_1mm all_FA all_FA_skeletonised

echo ""
echo "now run stats - for example:"
echo "randomise -i all_FA_skeletonised -o tbss -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V"
echo "(after generating design.mat and design.con)"

##
ALTIM="MD"
$FSLDIR/bin/fslmaths all_$ALTIM -mas mean_FA_mask all_$ALTIM

echo "projecting all_$ALTIM onto mean FA skeleton"
thresh=`cat thresh.txt`
${FSLDIR}/bin/tbss_skeleton -i mean_FA -p $thresh mean_FA_skeleton_mask_dst ${FSLDIR}/data/standard/LowerCingulum_1mm all_FA all_${ALTIM}_skeletonised -a all_$ALTIM

echo "now run stats - for example:"
echo "randomise -i all_${ALTIM}_skeletonised -o tbss_$ALTIM -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V"
echo "(after generating design.mat and design.con)"
