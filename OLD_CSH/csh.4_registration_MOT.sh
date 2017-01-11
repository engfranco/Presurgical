#!/bin/csh

##########################################################################################################################
## SCRIPT TO DO IMAGE REGISTRATION from functional to anatomical
## parameters are passed from 0_preprocess.sh
##
## !!!!!*****ALWAYS CHECK YOUR REGISTRATIONS*****!!!!!
##
##
##########################################################################################################################
############################################

######## Modified by Alexandre R. Franco

##########################################################################################################################

## study
set study = $1
## subject
set subj = $2
set ddir = $3
set task = $4
## name of the anatomical scan

set anat = $5


## directory setup
set anat_dir=${ddir}/${anat}
set func_dir=${ddir}/${task}


##########################################################################################################################
##---START OF SCRIPT----------------------------------------------------------------------------------------------------##
##########################################################################################################################

echo ------------------------------
echo ---- RUNNING REGISTRATION ----
echo ------------------------------




set base = `pwd`



#mkdir ${func_dir}

## 1. Copy required images into reg directory
### copy anatomical
#cp ${anat_dir}/${study}${subj}.${anat}_brain.nii.gz ${reg_dir}/highres.nii.gz
### copy anatomical with skull
#cp ${anat_dir}/${study}${subj}.${anat}_RPI.nii.gz ${reg_dir}/anat.nii.gz
### copy standard
#cp ${standard_brain} ${reg_dir}/standard.brain.nii.gz
#cp ${standard_whole} ${reg_dir}/standard.whole.nii.gz
### copy example func created earlier

cd ${func_dir}



cp ${anat_dir}/${study}${subj}.${anat}.nii.gz .



#cp ${anat_dir}/${study}${subj}.${anat}_surf.nii.gz ${study}${subj}.${anat}_surf.nii.gz
cp ${anat_dir}/${study}${subj}.${anat}_brain.nii.gz ${study}${subj}.${anat}_brain.nii.gz


3dcopy ${study}${subj}.${anat}_brain.nii.gz anat_ss
#3dcopy ${study}${subj}.example_func.nii.gz example_func
3dcopy ${study}${subj}.${task}_STC.nii.gz example_func



align_epi_anat.py \
-epi2anat \
-anat_has_skull no \
-anat anat_ss+orig  \
-epi example_func+orig \
-giant_move \
-volreg off \
-epi_base 0 \
-epi_strip 3dAutomask \
-verb 2 \
-partial_coverage 

#-keep_rm_files
#-child_epi example_func+orig \




3dAllineate \
-base anat_ss+orig  \
-input example_func+orig'[0]' \
-cubic \
-1Dmatrix_apply example_func_al_mat.aff12.1D \
-prefix example_func2ANAT



3dAllineate \
-base anat_ss+orig  \
-input rall_func+orig'[7-10]' \
-cubic \
-1Dmatrix_apply example_func_al_mat.aff12.1D \
-prefix ${func_dir}/rall_func2ANAT.nii.gz


# cleaning up
rm anat_ss+orig*
rm example_func+orig*
rm example_func_al+orig* 




