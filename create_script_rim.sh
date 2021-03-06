#! /bin/csh


# This is the script to create preprocessing scripts for the
# frases nonsense paradigm

set study = $1
set subj = $2
set ddir = $3
set run = $4
set script_folder = $5


echo $script_folder
# Get out of the SCRIPTS folder
#cd ..
#cd ${study}${subj}



afni_proc.py \
	-script proc.${study}${subj}.${run}.tcsh 	\
	-out_dir PROC.${run} 				\
	-dsets ${run}/${study}${subj}.${run}.nii.gz	\
	-copy_anat ANAT/${study}${subj}.ANAT.nii.gz	\
 	-do_block  despike  align 		  	\
	-tcat_remove_first_trs 3                        \
	-tshift_opts_ts -tpattern alt+z			\
	-volreg_align_to first				\
	-volreg_align_e2a				\
	-align_opts_aea -skullstrip_opts 		\
		-shrink_fac_bot_lim 0.8 		\
		-no_pushout				\
		-giant_move   \
        -mask_segment_anat yes				\
	-blur_filter -1blur_fwhm			\
	-blur_size 6 					\
    	-regress_stim_times ${script_folder}/stim_timing_RIM2.txt \
	-regress_stim_labels RIM  	\
	-regress_basis_multi                            \
		'GAM' \
        -regress_censor_motion 0.5                      \
	-regress_opts_3dD                               \
		-jobs 6					\
		-local_times 				\
		-regress_apply_mot_types demean		\
		-regress_apply_mask



# Now run script

tcsh -xef proc.${study}${subj}.${run}.tcsh |& tee output.proc.${study}${subj}.${run}.tcsh

exit
