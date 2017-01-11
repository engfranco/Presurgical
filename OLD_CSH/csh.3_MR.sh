#!/bin/csh

# Script to perform multiple regression
######## Adapted by Alexandre R. Fanco

## Study
set study = $1
## subject
set subj=$2
## analysisdirectory/subject
set dir=$3
## name of the epiing-state scan
set epi=$4

## last timepoint
#set TRend=$6
## TR
#set TR=$7
set stim_loc = $5

## directory setup
#set func_dir = ${dir}/${epi}
set func_dir = ${dir}




echo ---------------------------------------
echo ---- MR of FUNCTIONAL SCAN ----
echo ---------------------------------------


cd ${dir}

3dDeconvolve -input ${study}${subj}.${epi}_sm.nii.gz \
-polort 2 \
-num_stimts 7 \
-stim_times 1 ${stim_loc}/stim_timing.txt 'BLOCK(20,1)' -stim_label 1 task \
-stim_file 2 ${study}${subj}.${epi}_mc.1D'[0]' -stim_base 2 -stim_label 2 roll \
-stim_file 3 ${study}${subj}.${epi}_mc.1D'[1]' -stim_base 3 -stim_label 3 pitch \
-stim_file 4 ${study}${subj}.${epi}_mc.1D'[2]' -stim_base 4 -stim_label 4 yaw \
-stim_file 5 ${study}${subj}.${epi}_mc.1D'[3]' -stim_base 5 -stim_label 5 dS \
-stim_file 6 ${study}${subj}.${epi}_mc.1D'[4]' -stim_base 6 -stim_label 6 dL \
-stim_file 7 ${study}${subj}.${epi}_mc.1D'[5]' -stim_base 7 -stim_label 7 dP \
-gltsym 'SYM: roll \ pitch \yaw \dS \dL \dP' \
-tout -x1D rall_X.xmat.1D -xjpeg rall_X.jpg \
-fitts rall_fitts \
-bout \
-bucket rall_func \
-jobs 2

exit





-gltsym 'SYM: punho - pe' -glt_label 1 PU-PE \
-gltsym 'SYM: ombro - pe' -glt_label 1 OM-PE \

 Content of stim_AV1_vis.txt
"60 90 120 180 240"
"120 150 180 210 270"
"0 60 120 150 240
★ Each of 3 lines specifies start time in seconds for stimuli within the run




##########################################################################################################################
##---START OF SCRIPT----------------------------------------------------------------------------------------------------##
##########################################################################################################################

echo ---------------------------------------
echo ---- PREPROCESSING FUNCTIONAL SCAN ----
echo ---------------------------------------

set base = `pwd`
cd ${func_dir}



echo ${TRstart}
#echo ${TRend}

## 1. Dropping first # TRS

3dcalc \
-a ${study}${subj}.${epi}.STC.nii.gz'['${TRstart}'..$]' \
-expr 'a' \
-prefix ${study}${subj}.${epi}_dr.nii.gz


##2. Deoblique
echo "Deobliquing ${subj}"
3drefit -deoblique ${study}${subj}.${epi}_dr.nii.gz

##3. Reorient into fsl friendly space (what AFNI calls RPI)
echo "Reorienting ${subj}"
3dresample -orient RPI -inset ${study}${subj}.${epi}_dr.nii.gz -prefix ${study}${subj}.${epi}_ro.nii.gz

##4. Motion correct to average of timeseries
echo "Motion correcting ${subj}"
3dTstat -mean -prefix ${study}${subj}.${epi}_ro_mean.nii.gz  \
${study}${subj}.${epi}_ro.nii.gz 

3dvolreg -Fourier -twopass \
-base ${study}${subj}.${epi}_ro_mean.nii.gz -zpad 4 \
-prefix ${study}${subj}.${epi}_mc.nii.gz \
-1Dfile ${study}${subj}.${epi}_mc.1D \
${study}${subj}.${epi}_ro.nii.gz


##5. Remove skull/edge detect
echo "Skull stripping ${subj}"
3dAutomask -prefix ${study}${subj}.${epi}_mask.nii.gz \
-dilate 1 ${study}${subj}.${epi}_mc.nii.gz

3dcalc \
-a ${study}${subj}.${epi}_mc.nii.gz \
-b ${study}${subj}.${epi}_mask.nii.gz \
-expr 'a*b' \
-prefix ${study}${subj}.${epi}_ss.nii.gz

##6. Get eighth image for use in registration
echo "Getting example_func for registration for ${subj}"
3dcalc -a ${study}${subj}.${epi}_ss.nii.gz'[7]' \
-expr 'a' \
-prefix ${study}${subj}.example_func.nii.gz



if (0) then

##7. Spatial smoothing
echo "Smoothing ${subj}"
fslmaths ${study}${subj}.${epi}_ss.nii.gz -kernel gauss ${sigma} -fmean -mas ${study}${subj}.${epi}_mask.nii.gz ${study}${subj}.${epi}_sm.nii.gz

##8. Grandmean scaling
echo "Grand-mean scaling ${subj}"
fslmaths ${study}${subj}.${epi}_sm.nii.gz -ing 10000 ${study}${subj}.${epi}_gms.nii.gz -odt float

##9. Temporal filtering
echo "Band-pass filtering ${subj}"
3dFourier -lowpass ${lp} -highpass ${hp} -retrend -prefix ${study}${subj}.${epi}_filt.nii.gz ${study}${subj}.${epi}_gms.nii.gz

##10.Detrending
echo "Removing linear and quadratic trends for ${subj}"
3dTstat -mean -prefix ${study}${subj}.${epi}_filt_mean.nii.gz ${study}${subj}.${epi}_filt.nii.gz

3dDetrend -polort 2 -prefix ${study}${subj}.${epi}_dt.nii.gz ${study}${subj}.${epi}_filt.nii.gz

3dcalc -a ${study}${subj}.${epi}_filt_mean.nii.gz -b ${study}${subj}.${epi}_dt.nii.gz -expr 'a+b' -prefix ${study}${subj}.${epi}_pp.nii.gz

##11.Create Mask
echo "Generating mask of preprocessed data for ${subj}"
fslmaths ${study}${subj}.${epi}_pp.nii.gz -Tmin -bin ${study}${subj}.${epi}_pp_mask.nii.gz -odt char

endif 



cd ${base}
