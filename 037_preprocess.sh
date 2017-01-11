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

set subj = (037)

# Scan number
set anat_number = 005

# Motor mao
set task1_number = 002

# Motor pe
#set task2_number = 006

# Vision
#set task3_number = 002

# Letras
#set task4_number = 002

# Categorias
#set task5_number = 003

# Nomeação
#set task6_number = 003

# Rima
#set task7_number = 002

# Verbos
#set task8_number = 004

# Pseudopalavras
#set task9_number1 = XXX
#set task9_number2 = XXX

# Resting state
set rest_number = 003



#####
#### Parameters that typically don't need to be set for each patient
#####

set task1_name = MOT_M  # Motor Mao
set task2_name = MOT_P  # Motor Pé
set task3_name = VIS  # Motor Pé
set task4_name = LET  # Letras
set task5_name = CAT  # Categorias
set task6_name = NOM # Nomeação
set task7_name = RIM # Rima
set task8_name = VER # Verbos
set task9_name = PALA # Verbos
set rest_name  = RST # Resting state 


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




	cd ${study}${subj}
	set subjdirectory = `pwd`



	echo coverting dicom files
	##################################################
	# Convert dicom files no nifti 
	##################################################
	
	if (0) then
	
	${scripts_dir}/conv_dicom.sh ${study} ${subj}
	
	
	

	echo creating folders and moving files ${subj}
	##################################################
	# Script to create the subdirectories
	###################################################
	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${anat_name} ${anat_number}

	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task1_name} ${task1_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task2_name} ${task2_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task3_name} ${task3_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task4_name} ${task4_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task5_name} ${task5_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task6_name} ${task6_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task7_name} ${task7_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task8_name} ${task8_number}
#	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${task9_name} ${task9_number1} ${task9_number2}
	${scripts_dir}/create_directories.sh ${study} ${subj} ${analysisdirectory} ${rest_name} ${rest_number}




	echo Creating scripts to process data and also run script
	##################################################
	# script to create processing scripts 
	# XXX each "task" will have one line. Lines are different depending on "task" type
	##################################################

	# MOTOR Mão - 1
	${scripts_dir}/create_script_motor.sh ${study} ${subj} ${analysisdirectory} ${task1_name} ${scripts_dir}
	
	# MOTOR Pé - 2
#	${scripts_dir}/create_script_motor.sh_023 ${study} ${subj} ${analysisdirectory} ${task2_name} ${scripts_dir}

	# Vision - 3
#	${scripts_dir}/create_script_vis.sh ${study} ${subj} ${analysisdirectory} ${task3_name} ${scripts_dir}

	# Letras - 4
	${scripts_dir}/create_script_let.sh ${study} ${subj} ${analysisdirectory} ${task4_name} ${scripts_dir}

	# Categorias - 5
#	${scripts_dir}/create_script_cat.sh ${study} ${subj} ${analysisdirectory} ${task5_name} ${scripts_dir}

	# Nomeacao - 6 
	${scripts_dir}/create_script_nom.sh ${study} ${subj} ${analysisdirectory} ${task6_name} ${scripts_dir}

	# Rima - 7 - 
#	${scripts_dir}/create_script_rim.sh ${study} ${subj} ${analysisdirectory} ${task7_name} ${scripts_dir}

	# Verbos - 8 - 
	${scripts_dir}/create_script_ver.sh ${study} ${subj} ${analysisdirectory} ${task8_name} ${scripts_dir}

	# Resting state - Currently do not have the preprocessing script ready


endif

	##################################################
	# Making activation map figures
	# XXX each "task" will have one line. Lines are different depending on "task" type
	##################################################
	echo Now we will generate activation map the image



	# MOTOR Mão - 1
	${scripts_dir}/open_images_MOT.V2.0.sh ${study} ${subj} ${task1_name} ${subjdirectory}
	
	# MOTOR Pé - 2
#	${scripts_dir}/open_images_MOT.V2.0.sh_023 ${study} ${subj} ${task2_name} ${subjdirectory}

	# Visão - 3
#	${scripts_dir}/open_images_VIS.V2.0.sh ${study} ${subj} ${task3_name} ${subjdirectory}

	# Letras - 4
#	${scripts_dir}/open_images_LET.V2.0.sh ${study} ${subj} ${task4_name} ${subjdirectory}

	# Categorias - 5
#	${scripts_dir}/open_images_CAT.V2.0.sh ${study} ${subj} ${task5_name} ${subjdirectory}

	# Nomeacao - 6 
#	${scripts_dir}/open_images_NOM.V2.0.sh ${study} ${subj} ${task6_name} ${subjdirectory}

	# Rima - 7 
#	${scripts_dir}/open_images_RIM.V2.0.sh ${study} ${subj} ${task7_name} ${subjdirectory}

	# Verbos - 8 
#	${scripts_dir}/open_images_VER.V2.0.sh ${study} ${subj} ${task8_name} ${subjdirectory}

	# Resting state - Currently do not have the preprocessing script ready


exit
# XXX pedir o limiar estatistico de cada mapa de ativacao "stat-threshold.txt"





	##################################################
	# Making motion estimation figures
	# XXX call line for each "task". All tasks call the same script
	##################################################
	echo Now we will generate motion estimation figures the image




	# Motor	Mão - 1
	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task1_name}

	# Motor	Pé - 2
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task2_name}

	#Visão - 3
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task3_name}

	# Letras - 4
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task4_name}

	# Categorias - 5
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task5_name}

	# Nomeacao - 6 
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task6_name}

	# Rima - 7 
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task7_name}

	# Verbos - 8 
#	${scripts_dir}/make_motion_figure.V2.0.sh ${study} ${subj} ${subjdirectory} ${task8_name}

	# Resting state - Currently do not have the preprocessing script ready



# XXX tem que pausar para olhar o movimento. Neste momento criar alguns txts para o movimento de cada exame


# XXX pedir para descrever alguma observação sobre o exame "result-summary.txt"



exit








