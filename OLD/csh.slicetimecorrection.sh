#!/bin/csh


## directory where scripts are located
## study
set study = $1
## subject
set subj = $2
## analysisdirectory/subject
set dir = $3
## name of the anatomical scan
set epi = $4
## set TR value
set TR = $5



echo slice time correction ${subj}

cd ${dir}

3dTshift -tpattern alt+z -prefix ${study}${subj}.${epi}.STC.nii.gz ${study}${subj}.${epi}.nii.gz




