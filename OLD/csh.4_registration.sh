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
## analysisdirectory/subject
set ddirs = $3
## name of the anatomical scan
set anat = $4
##standard brain to be used in registration
#set standard=$5
#set standard_brain = /media/DATA/IDEAL_BRAINS/nihpd_asym_04.5-18.5_t1w.brain.3x3x3.nii.gz
#set standard_whole = /media/DATA/IDEAL_BRAINS/nihpd_asym_04.5-18.5_t1w.3x3x3.nii.gz


#set standard_brain = /media/DATA/IDEAL_BRAINS/MNI152_T1_3mm_brain.nii.gz
#set standard_whole = /media/DATA/IDEAL_BRAINS/MNI152_T1_3mm.nii.gz

## directory setup
set anat_dir=${ddirs}/ANAT
set func_dir=${ddirs}/RST
set reg_dir=${ddirs}/REG

##########################################################################################################################
##---START OF SCRIPT----------------------------------------------------------------------------------------------------##
##########################################################################################################################

echo ------------------------------
echo ---- RUNNING REGISTRATION ----
echo ------------------------------




set base = `pwd`

mkdir ${reg_dir}

## 1. Copy required images into reg directory
### copy anatomical
cp ${anat_dir}/${study}${subj}.${anat}_brain.nii.gz ${reg_dir}/highres.nii.gz
### copy anatomical with skull
#cp ${anat_dir}/${study}${subj}.${anat}_RPI.nii.gz ${reg_dir}/anat.nii.gz
### copy standard
#cp ${standard_brain} ${reg_dir}/standard.brain.nii.gz
#cp ${standard_whole} ${reg_dir}/standard.whole.nii.gz
### copy example func created earlier
cp ${func_dir}/${study}${subj}.example_func.nii.gz ${reg_dir}/example_func.nii.gz


## 2. cd into reg directory
cd ${reg_dir}


## 3. FUNC->T1
## You may want to change some of the options
flirt -ref highres -in example_func -out example_func2highres -omat example_func2highres.mat -cost corratio -dof 6 -interp trilinear
# Create mat file for conversion from subject's anatomical to functional
convert_xfm -inverse -omat highres2example_func.mat example_func2highres.mat

exit
# test if conversion was ok
applywarp --ref=${standard_whole} --in=highres.nii.gz --warp=highres2standard_NL_trans_matrix.nii.gz --out=highres2standard_NL



###***** ALWAYS CHECK YOUR REGISTRATIONS!!! YOU WILL EXPERIENCE PROBLEMS IF YOUR INPUT FILES ARE NOT ORIENTED CORRECTLY (IE. RPI, ACCORDING TO AFNI) *****###

cd ${base}



