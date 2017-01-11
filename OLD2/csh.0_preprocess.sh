#!/bin/csh


##########################################################################################################################
## Script to process clinical language fmri test
##
## created by Alexandre R. Franco
##
##########################################################################################################################
## directory where scripts are located


###########################################################################
#### Parameters that need to be set for each patient
###########################################################################


###########################################################################
#### Parameters that typically don't need to be set for each patient
###########################################################################

set subject_list = (004)

# Scan number
set anat_number = 004
set task1_number = 003
set task2_number = 002
set task3_number = XXX
set rest_number = XXX


#####
#### Parameters that typically don't need to be set for each patient
#####


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
set rest_name = RST # Letras - old FLU
set task1_name = LET # Categorias - old SEM
set task2_name = CAT  # Rima
set task3_name = RIM  # Motor
set task4_name = MOT 




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

	echo preprocessing ${subj}

if (0) then

	##################################################
	# Script to create the subdirectories
	##################################################
	${scripts_dir}/csh.create_directories.sh ${study} ${subj} ${analysisdirectory} ${anat_name} ${anat_number}
#	${scripts_dir}/csh.create_directories.sh ${study} ${subj} ${analysisdirectory} ${rest_name} ${rest_number}
	${scripts_dir}/csh.create_directories.sh ${study} ${subj} ${analysisdirectory} ${task1_name} ${task1_number}
	${scripts_dir}/csh.create_directories.sh ${study} ${subj} ${analysisdirectory} ${task2_name} ${task2_number}
#	${scripts_dir}/csh.create_directories.sh ${study} ${subj} ${analysisdirectory} ${task3_name} ${task3_number}



	##################################################################################################################################
	## preprocess anatomical scan
	## subject - full path to subject directory, subject is paremeterized - name of anatomical scan (no extension)
	##################################################################################################################################


	${scripts_dir}/csh.1_anatpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${anat_name} ${anat_name}




	##################################################################################################################################
	## preprocess functional scan
	## subject - full path to subject directory, subject is parameterized - name of functional scan (no extension) -
	## XXXXX
	##################################################################################################################################
   
	# task1
	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task1_name} ${task1_name} ${first_vol_task}

	# task2
	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task2_name} ${task2_name} ${first_vol_task} 
 
	# task3
#	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task3_name} ${task3_name} ${first_vol_task} 




	##################################################################################################################################
	## Multiple regression 
	##################################cs################################################################################################
	##################################################################################################################################
	
	# FLU, SEM and RIM task
	${scripts_dir}/csh.3_MR.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task1_name} ${task1_name} ${scripts_dir}
	${scripts_dir}/csh.3_MR.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task2_name} ${task2_name} ${scripts_dir}


	# The rima task is different in its timing, and needs a different mutiple regression task
#	${scripts_dir}/csh.3_MR_RIM.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task3_name} ${task3_name} ${scripts_dir}
		      




	##################################################################################################################################
	## registration
	#################################################################################################################################

	${scripts_dir}/csh.4_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task1_name} ${anat_name}
	${scripts_dir}/csh.4_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task2_name} ${anat_name}
#	${scripts_dir}/csh.4_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${task3_name} ${anat_name}

endif

	##################################################################################################################################
	## making images
	#################################################################################################################################

	cd ${subjdirectory}
	mkdir figures
	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task1_name}
	${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task2_name}
	#${scripts_dir}/csh.make_motion_figure.sh ${study} ${subj} ${subjdirectory} ${task1_name}

	


end



