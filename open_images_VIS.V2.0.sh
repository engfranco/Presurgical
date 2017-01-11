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
set subjdirectory = $argv[4]

# Go to subject directory
cd ${subjdirectory}
mkdir figures

# go to processed functional data folder
cd PROC.${scan}


# echo $label

echo ${subject} ${scan}


########################################
# Check if registration is OK
########################################

afni -yesplugouts &

plugout_drive \
-com "SEE_OVERLAY +" \
-com "OPEN_PANEL A.Define_Overlay" \
-com "SET_THRESHOLD A.4609 1" \
-com "SET_PBAR_ALL A.-99 1.000000 Spectrum:yellow_to_cyan+gap" \
-com "SET_FUNC_VISIBLE A.+" \
-com "SET_FUNC_RESAM A.NN.NN" \
-com "SET_FUNC_AUTORANGE A.+" \
-com "SWITCH_UNDERLAY A.${study}${subject}.ANAT+orig.HEAD 0" \
-com "SET_OVERLAY pb03.SUBJ.r01.volreg+orig.HEAD 1 1" \
-com "SET_DICOM_XYZ A -12.467392 -5.726204 46.351200" \
-com "OPEN_WINDOW A.axialimage " \
-com "OPEN_WINDOW A.sagittalimage " \
-com "OPEN_WINDOW A.coronalimage " \
-quit

echo " "
echo " "
echo "I am free, press <enter> once you have checked the registration " 
echo " you are working with ${subject} ${scan} "
echo " "
echo " "


# define default...
set text = "Press the <ENTER> key to continue..."

# accept user's alternative if offered...
if ($#argv > 0) set text = "$* >>"

printf "\n$text"
set junk = ($<)

# checking registration

plugout_drive \
-com "QUIT" \
-quit


sleep 5



###########################################
# Resample stats image to have same resolution at the T1 image
###############################################
3dresample -rmode Cu -master ${study}${subject}.ANAT+orig.HEAD -prefix stats.SUBJ.RESAMP+orig -inset stats.SUBJ+orig.HEAD



#################################################
#  both
#################################################

set side = both
set image = 2

afni -yesplugouts &


plugout_drive \
-com "SEE_OVERLAY +" \
-com "OPEN_PANEL A.Define_Overlay" \
-com "SET_THRESHOLD A.4609 1" \
-com "SET_PBAR_ALL A.-99 1.000000 Spectrum:yellow_to_cyan+gap" \
-com "SET_FUNC_VISIBLE A.+" \
-com "SET_FUNC_RESAM A.NN.NN" \
-com "SET_FUNC_AUTORANGE A.+" \
-com "SWITCH_UNDERLAY A.${study}${subject}.ANAT+orig.HEAD 0" \
-com "SET_OVERLAY A.stats.SUBJ.RESAMP+orig.HEAD ${image} ${image}" \
-com "SET_DICOM_XYZ A -12.467392 -5.726204 46.351200" \
-com "OPEN_WINDOW A.axialimage geom=807x1076+840+61 ifrac=0.9 mont=6x8:3:0:none opacity=9" \
-com "OPEN_WINDOW A.sagittalimage geom=633x862+840+59 ifrac=0.89 mont=6x10:5:0:none opacity=9" \
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

# Make images of checkerboard on both
# XXX meneguzzi olha aqui. Aqui estão os nomes para colocar no relatorio
plugout_drive \
-com "SAVE_PNG A.axialimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.axial.png" \
-com "SAVE_PNG A.sagittalimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.sagittal.png" \
-com "SAVE_PNG A.coronalimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.coronal.png" \
-com "QUIT" \
-quit



sleep 5




#################################################
# Left vision
#################################################

set side = left
set image = 5

afni -yesplugouts &


plugout_drive \
-com "SEE_OVERLAY +" \
-com "OPEN_PANEL A.Define_Overlay" \
-com "SET_THRESHOLD A.4609 1" \
-com "SET_PBAR_ALL A.-99 1.000000 Spectrum:yellow_to_cyan+gap" \
-com "SET_FUNC_VISIBLE A.+" \
-com "SET_FUNC_RESAM A.NN.NN" \
-com "SET_FUNC_AUTORANGE A.+" \
-com "SWITCH_UNDERLAY A.${study}${subject}.ANAT+orig.HEAD 0" \
-com "SET_OVERLAY A.stats.SUBJ.RESAMP+orig.HEAD ${image} ${image}" \
-com "SET_DICOM_XYZ A -12.467392 -5.726204 46.351200" \
-com "OPEN_WINDOW A.axialimage geom=807x1076+840+61 ifrac=0.9 mont=6x8:3:0:none opacity=9" \
-com "OPEN_WINDOW A.sagittalimage geom=633x862+840+59 ifrac=0.89 mont=6x10:5:0:none opacity=9" \
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

# Make images of checkerboard on left

# XXX meneguzzi olha aqui. Aqui estão os nomes para colocar no relatorio

plugout_drive \
-com "SAVE_PNG A.axialimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.axial.png" \
-com "SAVE_PNG A.sagittalimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.sagittal.png" \
-com "SAVE_PNG A.coronalimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.coronal.png" \
-com "QUIT" \
-quit


sleep 5



#################################################
# Right vision
#################################################

set side = right
set image = 8

afni -yesplugouts &


plugout_drive \
-com "SEE_OVERLAY +" \
-com "OPEN_PANEL A.Define_Overlay" \
-com "SET_THRESHOLD A.4609 1" \
-com "SET_PBAR_ALL A.-99 1.000000 Spectrum:yellow_to_cyan+gap" \
-com "SET_FUNC_VISIBLE A.+" \
-com "SET_FUNC_RESAM A.NN.NN" \
-com "SET_FUNC_AUTORANGE A.+" \
-com "SWITCH_UNDERLAY A.${study}${subject}.ANAT+orig.HEAD 0" \
-com "SET_OVERLAY A.stats.SUBJ.RESAMP+orig.HEAD ${image} ${image}" \
-com "SET_DICOM_XYZ A -12.467392 -5.726204 46.351200" \
-com "OPEN_WINDOW A.axialimage geom=807x1076+840+61 ifrac=0.9 mont=6x8:3:0:none opacity=9" \
-com "OPEN_WINDOW A.sagittalimage geom=633x862+840+59 ifrac=0.89 mont=6x10:5:0:none opacity=9" \
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

# Make images of checkerboard on right
# XXX meneguzzi olha aqui. Aqui estão os nomes para colocar no relatorio
plugout_drive \
-com "SAVE_PNG A.axialimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.axial.png" \
-com "SAVE_PNG A.sagittalimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.sagittal.png" \
-com "SAVE_PNG A.coronalimage ${subjdirectory}/figures/${study}${subject}.${scan}_${side}.coronal.png" \
-com "QUIT" \
-quit


sleep 5




exit

