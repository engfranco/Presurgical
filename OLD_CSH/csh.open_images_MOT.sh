#! /bin/csh

# This code will open task the subject's anatomical image as underlay and the t-test result
# as an overlay. The images will be set up for a montage. The Script stops in the middle
# so that the user can set the preferred threshold and also the preferred location of 
# images. 
# After this is selected, press <enter> in the terminal and the script will save the png
# images in the task folder. 

# Alexandre Rosa Franco - Oct 15th 2013


# Usage
# csh.open_images.sh study subject run_type


set study = $argv[1]
set subject = $argv[2]
set scan = $argv[3]


# Get out of SCRIPTS folder

cd ../
set basepath = `pwd`

# go to the subjectfolder
cd ${study}${subject}


set subj_loc = `pwd`

# go to functional data folder
cd ${scan}

# # get Verify file name
# set label = `ls VERIFY.${run_type}.*.HEAD | cut -f1 -d'+'`

# echo $label

echo ${subject} ${scan}

#################################################
# Left hand movement
#################################################




set side = left
set image = 1

afni -yesplugouts &


plugout_drive \
-com "SEE_OVERLAY +" \
-com "OPEN_PANEL A.Define_Overlay" \
-com "SET_THRESHOLD A.4609 1" \
-com "SET_PBAR_ALL A.-99 1.000000 Spectrum:yellow_to_cyan+gap" \
-com "SET_FUNC_VISIBLE A.+" \
-com "SET_FUNC_RESAM A.NN.NN" \
-com "SET_FUNC_AUTORANGE A.+" \
-com "SWITCH_UNDERLAY A.${study}${subject}.ANAT.nii.gz 0" \
-com "SET_OVERLAY A.rall_func2ANAT.nii.gz ${image} ${image}" \
-com "SET_DICOM_XYZ A -12.467392 -5.726204 46.351200" \
-com "OPEN_WINDOW A.axialimage geom=807x1076+1788+61 ifrac=0.9 mont=6x8:3:0:none opacity=9" \
-com "OPEN_WINDOW A.sagittalimage geom=633x862+2605+59 ifrac=0.89 mont=6x10:5:0:none opacity=9" \
-com "OPEN_WINDOW A.coronalimage geom=640x870+840+435 ifrac=0.91 mont=6x10:6:0:none opacity=9" \
-com "SET_XHAIRS A.OFF" \
-quit

echo " "
echo " "
echo "I am free, press <enter> once you have fixed the threshold and images " 
echo " you are working with ${subject} ${scan} "
echo " "
echo " "


# define default...
set text = "Press the <ENTER> key to continue..."

# accept user's alternative if offered...
if ($#argv > 0) set text = "$* >>"

printf "\n$text"
set junk = ($<)

# Make images of moving left hand

plugout_drive \
-com "SAVE_PNG A.axialimage ${subj_loc}/figures/${study}${subject}.${scan}_${side}.axial.png" \
-com "SAVE_PNG A.sagittalimage ${subj_loc}/figures/${study}${subject}.${scan}_${side}.sagittal.png" \
-com "SAVE_PNG A.coronalimage ${subj_loc}/figures/${study}${subject}.${scan}_${side}.coronal.png" \
-com "QUIT" \
-quit


sleep 5



#################################################
# Right hand movement
#################################################

set side = right
set image = 3

afni -yesplugouts &


plugout_drive \
-com "SEE_OVERLAY +" \
-com "OPEN_PANEL A.Define_Overlay" \
-com "SET_THRESHOLD A.4609 1" \
-com "SET_PBAR_ALL A.-99 1.000000 Spectrum:yellow_to_cyan+gap" \
-com "SET_FUNC_VISIBLE A.+" \
-com "SET_FUNC_RESAM A.NN.NN" \
-com "SET_FUNC_AUTORANGE A.+" \
-com "SWITCH_UNDERLAY A.${study}${subject}.ANAT.nii.gz 0" \
-com "SET_OVERLAY A.rall_func2ANAT.nii.gz ${image} ${image}" \
-com "SET_DICOM_XYZ A -12.467392 -5.726204 46.351200" \
-com "OPEN_WINDOW A.axialimage geom=807x1076+1788+61 ifrac=0.9 mont=6x8:3:0:none opacity=9" \
-com "OPEN_WINDOW A.sagittalimage geom=633x862+2605+59 ifrac=0.89 mont=6x10:5:0:none opacity=9" \
-com "OPEN_WINDOW A.coronalimage geom=640x870+840+435 ifrac=0.91 mont=6x10:6:0:none opacity=9" \
-com "SET_XHAIRS A.OFF" \
-quit

echo " "
echo " "
echo "I am free, press <enter> once you have fixed the threshold and images " 
echo " you are working with ${subject} ${scan} "
echo " "
echo " "


# define default...
set text = "Press the <ENTER> key to continue..."

# accept user's alternative if offered...
if ($#argv > 0) set text = "$* >>"

printf "\n$text"
set junk = ($<)

# Make images of moving left hand

plugout_drive \
-com "SAVE_PNG A.axialimage ${subj_loc}/figures/${study}${subject}.${scan}_${side}.axial.png" \
-com "SAVE_PNG A.sagittalimage ${subj_loc}/figures/${study}${subject}.${scan}_${side}.sagittal.png" \
-com "SAVE_PNG A.coronalimage ${subj_loc}/figures/${study}${subject}.${scan}_${side}.coronal.png" \
-com "QUIT" \
-quit


sleep 5




exit

