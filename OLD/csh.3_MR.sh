#!/bin/csh


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


if (0) then

[-CENSORTR clist]    clist = list of strings that specify time indexes 
                       to be removed from the analysis.  Each string is
                       of one of the following forms:                  
                           37 => remove global time index #37          
                         2:37 => remove time index #37 in run #2       
                       37..47 => remove global time indexes #37-47     
                       37-47  => same as above                         
                     2:37..47 => remove time indexes #37-47 in run #2  
                     *:0-2    => remove time indexes #0-2 in all runs  
                      +Time indexes within each run start at 0.        
                      +Run indexes start at 1 (just be to confusing).  
                      +Multiple -CENSORTR options may be used, or      
                        multiple -CENSORTR strings can be given at     
                        once, separated by spaces or commas.           
                      +N.B.: 2:37,47 means index #37 in run #2 and     
                        global time index 47; it does NOT mean         
                        index #37 in run #2 AND index #47 in run #2.   

endif


cd ${dir}

3dDeconvolve -input ${study}${subj}.${epi}_ss.nii.gz \
-polort 2 \
-num_stimts 9 \
-stim_times 1 ${stim_loc}/stim_hand_right.txt 'BLOCK(30,1)' -stim_label 1 right \
-stim_times 2 ${stim_loc}/stim_hand_left.txt 'BLOCK(30,1)' -stim_label 2 left \
-stim_times 3 ${stim_loc}/stim_hand_both.txt 'BLOCK(30,1)' -stim_label 3 both \
-stim_file 4 ${study}${subj}.${epi}_mc.1D'[0]' -stim_base 4 -stim_label 4 roll \
-stim_file 5 ${study}${subj}.${epi}_mc.1D'[1]' -stim_base 5 -stim_label 5 pitch \
-stim_file 6 ${study}${subj}.${epi}_mc.1D'[2]' -stim_base 6 -stim_label 6 yaw \
-stim_file 7 ${study}${subj}.${epi}_mc.1D'[3]' -stim_base 7 -stim_label 7 dS \
-stim_file 8 ${study}${subj}.${epi}_mc.1D'[4]' -stim_base 8 -stim_label 8 dL \
-stim_file 9 ${study}${subj}.${epi}_mc.1D'[5]' -stim_base 9 -stim_label 9 dP \
-gltsym 'SYM: right -left' -glt_label 1 R-L \
-gltsym 'SYM: roll \ pitch \yaw \dS \dL \dP' \
-tout -x1D rall_X.xmat.1D -xjpeg rall_X.jpg \
-fitts rall_fitts \
-bout \
-bucket rall_func \
-jobs 2

exit


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
