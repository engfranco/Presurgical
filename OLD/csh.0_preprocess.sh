#!/bin/csh


##########################################################################################################################
## SCRIPT TO RUN GENERAL RESTING-STATE PREPROCESSING 
##
## This script can be run on its own, by filling in the appropriate parameters
## Alternatively this script gets called from batch_process.sh, where you can use it to run N sites, one after the other.
##
## Written by the Underpants Gnomes (a.k.a Clare Kelly, Zarrar Shehzad, Maarten Mennes & Michael Milham)
## for more information see www.nitrc.org/projects/fcon_1000
##
##########################################################################################################################

######## Adapted by Alexandre R. Franco

##########################################################################################################################
## PARAMETERS
## 
## Either set them yourself for single site preprocessing or leave as is for batch_process.sh
##
##########################################################################################################################
## directory where scripts are located

#set study = Brown
set study = PSE
set scripts_dir = `pwd`
## full/path/to/site
cd ..
set analysisdirectory = `pwd`
## full/path/to/site/subject_list
#set subject_list = (0010001)
set subject_list = (001)

## what is the first volume, default is 0
set first_vol_rest = 2
set first_vol_task = 5

## what is the number of volumes
set n_vols_rest = 210
set n_vols_task = 270
## TR
set TR = 2.0

## name of anatomical scan (no extension)
set anat_name = ANAT
## name of resting-state scan (no extension)
set rest_name = RST
set task_name = HAND


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


	echo preprocessing ${subj}
	
	##################################################################################################################################
	## preprocess anatomical scan
	## subject - full path to subject directory, subject is paremeterized - name of anatomical scan (no extension)
	##################################################################################################################################

#	${scripts_dir}/csh.1_anatpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${anat_name} ${anat_name}

	##################################################################################################################################
	## slice time correction
	##################################################################################################################################

	# for task 
#	${scripts_dir}/csh.slicetimecorrection.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task_name} ${task_name} ${TR}


	
	##################################################################################################################################
	## preprocess functional scan
	## subject - full path to subject directory, subject is parameterized - name of functional scan (no extension) -
	## first volume - last volume - TR
	## set temporal filtering and spatial smoothing in 2_funcpreproc.sh (default is 0.005-0.1Hz and 6 FWHM)
	##################################################################################################################################

      
#	${scripts_dir}/csh.2_funcpreproc.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task_name} ${task_name} ${first_vol_task} 

# Multiple regression 
	${scripts_dir}/csh.3_MR.sh ${study} ${subj} ${analysisdirectory}/${study}${subj}/${task_name} ${task_name} ${scripts_dir}
		      
exit

	##################################################################################################################################
	## registration
	## subject - full path to subject directory, subject is parameterized - name of anatomical scan (no extension) - standard brain	##################################################################################################################################

#	${scripts_dir}/csh.3_registration.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${anat_name}


	##################################################################################################################################
	## segmentation
	## subject - full path to subject directory, subject is parameterized - name of anatomical scan (no extension) -
	## name of resting-state scan (no extension) - full path to tissueprior dir
	##################################################################################################################################

#	${scripts_dir}/csh.4_segment.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${anat_name} ${rest_name} ${scripts_dir}/tissuepriors/3mm/

	##################################################################################################################################
	## nuisance signal regression
	## subject - full path to subject directory, subject is parameterized - name of resting-state scan (no extension) -
	## TR - number of volumes (default = last_vol + 1; has to be +1 since volume numbering starts at 0) -
	## full path to dir where feat model template fsf file is located
	##################################################################################################################################
#	${scripts_dir}/csh.5_nuisance.sh ${study} ${subj} ${analysisdirectory}/${study}${subj} ${rest_name} ${TR} ${n_vols} ${scripts_dir}/templates/nuisance.fsf
	
	## END OF SUBJECT LOOP

end



