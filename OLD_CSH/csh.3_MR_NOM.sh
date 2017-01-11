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


cd ${dir}

3dDeconvolve -input ${study}${subj}.${epi}_sm.nii.gz \
-polort 2 \
-num_stimts 7 \
-stim_times 1 ${stim_loc}/stim_timing_NOM.txt 'GAM' -stim_label 1 task \
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






