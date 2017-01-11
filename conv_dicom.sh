#! /bin/csh 


### In this script we will read the dicom files and convert them to NII.
### Note, this script assumes that the subject folder exists, and inside it there is a "dicom" folder in it with the 
### dicom files in it
### 
### Author: Alexandre Franco
### Nov 14, 2013

### SOMENTE EDITAR ESTA PARTE PARA CADA SUJEITO@@@@@
set study = $argv[1]
set subj = $argv[2]

#set study = COG
#set subj = 001


###########################@@@@@@@@@@@@@@@@@@@@
 
# get out of script folder
cd ..

# go inside subject folder
cd ${study}${subj}


# convert dicom images to nii
set subj_folder = `pwd`


dcm2nii -c -g -o ${subj_folder} dicom/*
#dcm2nii -c -g -o ${subj_folder} a/*
#dcm2nii -c -g -o ${subj_folder} A/*

#mcverter -o ./ -f nifti -n -d -v A/


# Now we can compact the dicom folder
#tar -zcvf dicom.tar.gz dicom
tar -zcvf dicom.tar.gz dicom

# Now we can delete the original dicom folder
#rm -rfv dicom
rm -rfv dicom






