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
		-giant_move                             \
        -mask_segment_anat yes				\
	-blur_filter -1blur_fwhm			\
	-blur_size 6 					\
	-regress_stim_times \
<<<<<<< HEAD
    	${script_folder}/TIMING/FALSE_MEM/audio_false.1D  \
        ${script_folder}/TIMING/FALSE_MEM/audio_true.1D   \
		${script_folder}/TIMING/FALSE_MEM/pergunta.1D     \
=======
    	${script_folder}/TIMING/FALMEM/audio_false.1D  \
        ${script_folder}/TIMING/FALMEM/audio_true.1D   \
		${script_folder}/TIMING/FALMEM/pergunta.1D     \
>>>>>>> 6e767c43390c4c3872ef63e628c6ad06913ca791
	-regress_stim_labels false true pergunta          \
	-regress_basis_multi                              \
		'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(4,1)'   \
	-regress_local_times 			\
	-regress_opts_3dD                               \
		-gltsym 'SYM: +false -true'             \
 		-glt_label 1 false_vs_true              \
		-gltsym 'SYM: +false -pergunta' 	\
		-glt_label 2 false_vs_pergunta		\
		-gltsym 'SYM: +true -pergunta'		\
		-glt_label 3 true_vs_pergunta		\
<<<<<<< HEAD
	-regress_censor_motion 0.5                      \
	-regress_opts_3dD                               \
		-jobs 6					\
		-local_times 				\
		-regress_apply_mot_types demean		\
		-regress_apply_mask \
		-execute
=======
		-gltsym 'SYM: +0.5*true +0.5*false'		\
		-glt_label 4 true+false		\
		-regress_censor_motion 0.5                      \
    	-regress_censor_outliers 0.1                    \
   	-regress_opts_3dD                               \
		-jobs 6					\
		-regress_apply_mot_types demean		\
		-regress_apply_mask \
	-execute
>>>>>>> 6e767c43390c4c3872ef63e628c6ad06913ca791



# Now run script

#tcsh -xef proc.${study}${subj}.${run}.tcsh |& tee output.proc.${study}${subj}.${run}.tcsh

exit
