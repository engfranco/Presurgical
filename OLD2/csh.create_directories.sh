#!/bin/csh

##########################################################################################################################
## SCRIPT TO PREPARE DAT
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
##analysisdirectory
set analysisdirectory = $3
set scan = $4
set img_number = $5



cd ${analysisdirectory}


cd ${study}${subj}
mkdir ${scan} 
cd ${scan}
mv ../2*${img_number}* .
mv 2*${img_number}*.nii.gz ${study}${subj}.${scan}.nii.gz









