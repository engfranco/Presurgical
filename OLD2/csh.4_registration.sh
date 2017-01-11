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



if (0) then

cp ${anat_dir}/${study}${subj}.${anat}.nii.gz .

## 2. cd into reg directory
#cd ${func_dir}

#align_epi_anat.py \
#-epi2anat \
#-anat_has_skull no \
#-anat ${anat_dir}/${study}${subj}.${anat}_brain.nii.gz \
#-epi example_func.nii.gz \
#-epi_base 0  



#cp ${anat_dir}/${study}${subj}.${anat}_surf.nii.gz ${study}${subj}.${anat}_surf.nii.gz
cp ${anat_dir}/${study}${subj}.${anat}_brain.nii.gz ${study}${subj}.${anat}_brain.nii.gz


3dcopy ${study}${subj}.${anat}_brain.nii.gz anat_ss
3dcopy ${study}${subj}.example_func.nii.gz example_func


align_epi_anat.py \
-epi2anat \
-anat_has_skull no \
-anat anat_ss+orig  \
-epi example_func+orig \
-epi_base 0  
 


#align_epi_anat.py \
#-epi2anat \
#-anat_has_skull yes \
#-anat ${study}${subj}.${anat}.nii.gz  \
#-epi example_func.nii.gz \
#-epi_base 0  

endif

3dAllineate \
-base anat_ss+orig  \
-input example_func+orig \
-cubic \
-1Dmatrix_apply anat_ss_al_mat.aff12.1D \
-prefix example_func2ANAT


3dAllineate \
-base anat_ss+orig  \
-input rall_func+orig'[7-8]' \
-cubic \
-1Dmatrix_apply anat_ss_al_mat.aff12.1D \
-prefix ${func_dir}/rall_func2ANAT.nii.gz




