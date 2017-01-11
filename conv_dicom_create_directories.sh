#! /bin/csh 


### In this script we will read the dicom files and convert them to NII and organise by folders.
### Note, this script assumes that the subject folder exists, and inside it there is a "dicom" folder in it with the 
### dicom files in it. Also, it assumes that the files where downloaded using the dcmget.sh scritp
### 
### Author: Alexandre Franco
### Sept 19th, 2016


### SOMENTE EDITAR ESTA PARTE PARA CADA SUJEITO@@@@@
set study = $argv[1]
set subj = $argv[2]
set subj_folder = $argv[3]
set run_name = $argv[4]
set run_dicom_folder = $argv[5]

#set study = COG
#set subj = 001


###########################@@@@@@@@@@@@@@@@@@@@
 
# go to subject folder
cd subj_folder


mkdir ${run_name}
cd ${run_name}
set outputdir = `pwd`

cd ..
cd dicom/${run_dicom_folder}*

pwd

dcm2nii -c -g -o ${outputdir} *

cd ${outputdir}

mv 2*nii* ${study}${subj}.${run_name}.nii.gz

# remove for the anat files
if (-f o*nii*) then
	rm o*nii*
	rm co*nii*
endif




