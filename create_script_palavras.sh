#! /bin/csh


# This is the script to create preprocessing scripts for the
# frases nonsense paradigm

set study = $1
set subj = $2
set run = PALA
set visit = $3

set script_folder = $4

#set template = /media/DATA/IDEAL_BRAINS/nihpd_sym_07.5-13.5_t1w+tlrc




afni_proc.py \
	-script proc.${study}${subj}.${run}.tcsh 			\
	-out_dir PROC.${run} 								\
	-dsets ${run}1/${study}${subj}.${run}1.nii.gz		\
		   ${run}2/${study}${subj}.${run}2.nii.gz		\
	-copy_anat ANAT/${study}${subj}.ANAT.nii.gz			\
 	-do_block  despike  align 		  					\
	-tcat_remove_first_trs 3                        	\
	-tshift_opts_ts -tpattern alt+z						\
	-volreg_align_to first								\
	-volreg_align_e2a									\
	-align_opts_aea -skullstrip_opts 					\
		-shrink_fac_bot_lim 0.8 						\
		-no_pushout										\
		-giant_move   \
        -mask_segment_anat yes							\
	-blur_filter -1blur_fwhm							\
	-blur_size 6 					\
    -regress_stim_times ${script_folder}/TIMING/PSEUDO/timing_PALA_reg.txt  \
	${script_folder}/TIMING/PSEUDO/timing_PALA_ireg.txt \
	${script_folder}/TIMING/PSEUDO/timing_PALA_pseudo.txt \
	${script_folder}/TIMING/PSEUDO/timing_PALA_base.txt  	\
	-regress_stim_labels reg ireg pseudo base \
	-regress_basis_multi                            \
		'BLOCK(7,1)' 'BLOCK(7,1)' 'BLOCK(7,1)' 'BLOCK(30,1)'     \
        -regress_censor_motion 0.9                      \
	-regress_opts_3dD                               \
		-gltsym 'SYM: +0.34*reg +0.33*ireg +0.33*reg -base'               \
 		-glt_label 1 all_vs_base                \
        -regress_censor_motion 0.5                      \
	-regress_opts_3dD                               \
		-jobs 6					\
		-local_times 				\
		-regress_apply_mot_types demean		\
		-regress_apply_mask



# Now run script

tcsh -xef proc.${study}${subj}.${run}.tcsh |& tee output.proc.${study}${subj}.${run}.tcsh

cd PROC.PALA
gzip -v *BRIK

exit
