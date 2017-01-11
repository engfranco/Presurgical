#!/bin/csh


##########################################################################################################################
## Script to process clinical fmri
##
## created by Alexandre R. Franco
##
##########################################################################################################################
## directory where scripts are located
## Updated Feb 6th 2014


###########################################################################
#### Parameters that need to be set for each patient
###########################################################################


###########################################################################
#### Parameters that typically don't need to be set for each patient
###########################################################################

set subject_list = (015)

# Scan number
set anat_number = 003
# Motor mao
#set task1_number = 005
# Motor pe
#set task2_number = 006

# Vision
set task3_number = 002



#####
#### Parameters that typically don't need to be set for each patient
#####

set task1_name = MOT_M  # Motor Mao
set task2_name = MOT_P  # Motor Pé
set task3_name = VIS  # Motor Pé

set study = LING
set scripts_dir = `pwd`
## full/path/to/site
cd ..
set analysisdirectory = `pwd`


## what is the first volume, default is 2
#set first_vol_rest = 2
set first_vol_task = 3

## what is the number of volumes left after removing the first volumes
#set n_vols_rest = 210
#set n_vols_task = 170
## TR
set TR = 2.0

## name of anatomical scan (no extension)
set anat_name = ANAT
## name of resting-state scan (no extension)
 




## shift parameters one to the left; comment if not running batch_process.sh
#shift
## Standard brain
#standard_brain=$9
##########################################################################################################################


##########################################################################################################################
##---START OF SCRIPT----------------------------------------------------------------------------------------------------##
##########################################################################################################################


## Get subjects to run


## SUBJECT LOOP
foreach subj (${subject_list})
	cd ${study}${subj}
	set subjdirectory = `pwd`


	echo coverting dicom files
	##################################################
	# Convert dicom files no nifti 
	##################################################
	${scripts_dir}/conv_dicom.sh ${study} ${subj}


	echo creating folders and moving files ${subj}
	##################################################
	# Script to create the subdirectories
	##################################################
	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${anat_name} ${anat_number}

#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task1_name} ${task1_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task2_name} ${task2_number}
	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task3_name} ${task3_number}




	echo Creating scripts to process data and also run script
	##################################################
	# script to create processing scripts
	##################################################

	# MOTOR Mão
#	${scripts_dir}/create_script_motor.sh ${study} ${subj} ${analysisdirectory} ${task1_name} ${scripts_dir}
	# MOTOR Pé
#	${scripts_dir}/create_script_motor.sh ${study} ${subj} ${analysisdirectory} ${task2_name} ${scripts_dir}

	# Vision
	${scripts_dir}/create_script_vis.sh ${study} ${subj} ${analysisdirectory} ${task3_name} ${scripts_dir}




	echo Now we will generate activation map the image
	##################################################
	# Making activation map figures
	##################################################

	# MOTOR Mão
#	${scripts_dir}/open_images_MOT.V2.0.sh ${study} ${subj} ${task1_name} ${subjdirectory}
	# MOTOR Pé
#	${scripts_dir}/open_images_MOT.V2.0.sh ${study} ${subj} ${task2_name} ${subjdirectory}
	# Visão
	${scripts_dir}/open_images_VIS.V2.0.sh ${study} ${subj} ${task3_name} ${subjdirectory}


	echo Now we will generate motion estimation figures the image
	##################################################
	# Making motion estimation figures
	##################################################

	# Motor	Mão
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task1_name}
	# Motor	Pé
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task2_name}
	#Visão
	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task3_name}



end







exit
#####################
OLD STUFF
	##################################################################################################################################
	## preprocess anatomical scan
	## subject - full path to subject directory, subject is paremeterized - name of anatomical scan (no extension)
	##################################################################################################################################

#	${scripts_dir}/csh.1_anatpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${anat_name} ${anat_name}

##################################################################################################################################
	## preprocess functional scan
	## subject - full path to subject directory, subject is parameterized - name of functional scan (no extension) -
	## XXXXX
	##################################################################################################################################
   
	# task1
#	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task1_name} ${task1_name} ${first_vol_task}

	# task2
#	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task2_name} ${task2_name} ${first_vol_task} 
 
	# task3
#	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task3_name} ${task3_name} ${first_vol_task}

	# task4
#	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task4_name} ${task4_name} ${first_vol_task}

	# task5
	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task5_name} ${task5_name} ${first_vol_task}    

	# task6
#	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task6_name} ${task6_name} ${first_vol_task}

	# task7
#	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task7_name} ${task7_name} ${first_vol_task}


	##################################################################################################################################
	## Multiple regression 
	##################################cs################################################################################################
	##################################################################################################################################
	
	# LET, CAT tasks
#	${scripts_dir}/csh.3_MR.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task1_name} ${task1_name} ${scripts_dir}
#	${scripts_dir}/csh.3_MR.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task2_name} ${task2_name} ${scripts_dir}



	# The rima task is different in its timing, and needs a different mutiple regression task
#	${scripts_dir}/csh.3_MR_RIM2.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task3_name} ${task3_name} ${scripts_dir}
	      
	# Motor task - also has a different timings, since there are two tasks.
#	${scripts_dir}/csh.3_MR_MOT.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task4_name} ${task4_name} ${scripts_dir}

	# Nomeação - has its own timing
	${scripts_dir}/csh.3_MR_NOM.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task5_name} ${task5_name} ${scripts_dir}

	# Verbos - also has its own timing
#	${scripts_dir}/csh.3_MR_VER.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task6_name} ${task6_name} ${scripts_dir}

	# Visual task - also has a different timings, since there are three tasks.
#	${scripts_dir}/csh.3_MR_VIS.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task7_name} ${task7_name} ${scripts_dir}


	##################################################################################################################################
	## registration
	#################################################################################################################################


#	${scripts_dir}/csh.4_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task1_name} ${anat_name}
#	${scripts_dir}/csh.4_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task2_name} ${anat_name}


#	${scripts_dir}/csh.4_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task3_name} ${anat_name}
	
	# Motor is different since we need to register two conditions to the anatomical
#	${scripts_dir}/csh.4_registration_MOT.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task4_name} ${anat_name}

	${scripts_dir}/csh.4_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task5_name} ${anat_name}

#	${scripts_dir}/csh.4_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task6_name} ${anat_name}

#	${scripts_dir}/csh.4_registration_VIS.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task7_name} ${anat_name}


	##################################################################################################################################
	## making images
	#################################################################################################################################

	cd ${subjdirectory}
	mkdir figures
	# Making motion figure
#	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task1_name}
#	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task2_name}
#	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task3_name}
#	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task4_name}
	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task5_name}
#	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task6_name}
#	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task7_name}



	# Making activation map figures
#	${scripts_dir}/csh.open_images.sh ${study} ${subj} ${task1_name}
#	${scripts_dir}/csh.open_images.sh ${study} ${subj} ${task2_name}
#	${scripts_dir}/csh.open_images.sh ${study} ${subj} ${task3_name}

	# Motor is different and we'll have to fix the script
#	${scripts_dir}/csh.open_images_MOT.sh ${study} ${subj} ${task4_name}

	${scripts_dir}/csh.open_images.sh ${study} ${subj} ${task5_name}
#	${scripts_dir}/csh.open_images.sh ${study} ${subj} ${task6_name}





