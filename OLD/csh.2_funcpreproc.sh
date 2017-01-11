#!/bin/csh

##########################################################################################################################
## SCRIPT TO PREPROCESS THE FUNCTIONAL SCAN
## parameters are passed from 0_preprocess.sh
##
## Written by the Underpants Gnomes (a.k.a Clare Kelly, Zarrar Shehzad, Maarten Mennes & Michael Milham)
## for more information see www.nitrc.org/projects/fcon_1000
##
##########################################################################################################################

######## Adapted by Alexandre R. Fanco

## Study
set study = $1
## subject
set subj=$2
## analysisdirectory/subject
set dir=$3
## name of the epiing-state scan
set epi=$4
## first timepoint (remember timepoint numbering starts from 0)
set TRstart=$5
## last timepoint
#set TRend=$6
## TR
#set TR=$7

## set your desired spatial smoothing FWHM - we use 6 (acquisition voxel size is 3x3x4mm)
set FWHM = 6
set sigma = `echo "scale=10 ; ${FWHM}/2.3548" | bc`

## Set high pass and low pass cutoffs for temporal filtering
set hp = 0.005
set lp = 0.1

## directory setup
#set func_dir = ${dir}/${epi}
set func_dir = ${dir}




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





##7. Spatial smoothing
echo "Smoothing ${subj}"
fslmaths ${study}${subj}.${epi}_ss.nii.gz -kernel gauss ${sigma} -fmean -mas ${study}${subj}.${epi}_mask.nii.gz ${study}${subj}.${epi}_sm.nii.gz


if (0) then
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
