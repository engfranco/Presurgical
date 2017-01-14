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
        -mask_segment_anat yes				\
	-blur_filter -1blur_fwhm			\
	-blur_size 6 					\
    	-regress_stim_times \
    	${script_folder}/stim_timing_verbo.txt \
    	${script_folder}/stim_timing_verbo_BASELINE.txt \
	-regress_stim_labels VER BASE 	\
	-regress_basis_multi                            \
		'GAM' 'BLOCK(20,1)' \
	-regress_opts_3dD                           \
                -gltsym 'SYM: +VER -BASE'             \
                -glt_label 1 VER_vs_BASE     \
    -regress_censor_motion 0.5                      \
	-regress_censor_outliers 0.1                    \
	-regress_opts_3dD                               \
		-jobs 6					\
		-local_times 				\
		-regress_apply_mot_types demean		\
		-regress_apply_mask \
	-execute



# Now run script

#tcsh -xef proc.${study}${subj}.${run}.tcsh |& tee output.proc.${study}${subj}.${run}.tcsh

exit

