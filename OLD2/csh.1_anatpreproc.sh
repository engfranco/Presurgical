#!/bin/csh

##########################################################################################################################
## SCRIPT TO PREPROCESS THE ANATOMICAL SCAN
## parameters are passed from 0_preprocess.sh
##
## Written by the Underpants Gnomes (a.k.a Clare Kelly, Zarrar Shehzad, Maarten Mennes & Michael Milham)
## for more information see www.nitrc.org/projects/fcon_1000
##
##########################################################################################################################

######## Adapted by Alexandre R. Fanco

#${scripts_dir}/csh.1_anatpreproc ${study} ${subj} ${analysisdirectory}/${study}${subj} ${anat_name}

## study
set study = $1
## subject
set subj = $2
## analysisdirectory/subject
set dir = $3
## name of the anatomical scan
set anat = $4

## directory setup
#set anat_dir = ${dir}/${anat}
set anat_dir = ${dir}


###############################
#####mprage_noface.nii.gz

##########################################################################################################################
##---START OF SCRIPT----------------------------------------------------------------------------------------------------##
##########################################################################################################################

echo --------------------------------------
echo --- PREPROCESSING ANATOMICAL SCAN ----
echo --------------------------------------

set base = `pwd`

cd ${anat_dir}

## 0. Rename the data
#3dcopy mprage_noface.nii.gz ${study}${subj}.${anat}.nii.gz



## 1. Deoblique anat
echo "deobliquing ${subj} anatomical"
3drefit -deoblique ${study}${subj}.${anat}.nii.gz

## 2. Reorient to fsl-friendly space
echo "Reorienting ${subj} anatomical"
3dresample -orient RPI -inset ${study}${subj}.${anat}.nii.gz -prefix ${study}${subj}.${anat}_RPI.nii.gz

## 3. skull strip
#echo "skull stripping ${subj} anatomical"
#bet ${study}${subj}.${anat}_RPI.nii.gz ${study}${subj}.${anat}_brain.nii.gz

#################### NEED TO CHANGE THIS TO BET!!!!
3dSkullStrip -shrink_fac_bot_lim 0.75 -input ${study}${subj}.${anat}_RPI.nii.gz -o_ply ${study}${subj}.${anat}_surf.nii.gz

3dcalc \
-a ${study}${subj}.${anat}_RPI.nii.gz \
-b ${study}${subj}.${anat}_surf.nii.gz \
-expr 'a*step(b)' \
-prefix ${study}${subj}.${anat}_brain.nii.gz

cd ${base}



