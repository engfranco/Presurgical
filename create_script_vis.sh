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
    	-regress_stim_times ${script_folder}/stim_timing_VIS_B.txt \
			    ${script_folder}/stim_timing_VIS_L.txt \
			    ${script_folder}/stim_timing_VIS_R.txt \
	-regress_stim_labels VIS_B VIS_L VIS_R  	\
	-regress_basis_multi                            \
		'BLOCK(20,1)' 'BLOCK(20,1)' 'BLOCK(20,1)' \
        -regress_censor_motion 0.5                      \
	-regress_opts_3dD                               \
		-jobs 6					\
		-local_times 				\
		-regress_apply_mot_types demean		\
		-regress_apply_mask



# Now run script

tcsh -xef proc.${study}${subj}.${run}.tcsh |& tee output.proc.${study}${subj}.${run}.tcsh

exit

################################################
# extra notes 


		-gltsym 'SYM: +sem -base'               \
 		-glt_label 1 sem_vs_base                \
		-gltsym 'SYM: +csen -base'              \
 		-glt_label 2 csen_vs_base               \
		-gltsym 'SYM: +sem -csen'               \
 		-glt_label 3 sem_vs_csen                \
		-gltsym 'SYM: 0.5*sem 0.5*csen -1.0*base'	\
 		-glt_label 4 sem+csen_vs_base		\


	-tlrc_base MNI_caez_N27+tlrc			\
	-tlrc_NL_warp 					\

 -align_opts_aea OPTS ... : specify extra options for align_epi_anat.py

                e.g. -align_opts_aea -cost lpc+ZZ
                e.g. -align_opts_aea -Allineate_opts -source_automask+4
                e.g. -align_opts_aea -giant_move -AddEdge -epi_strip 3dAutomask

            This option allows the user to add extra options to the alignment
            command, align_epi_anat.py.

            Note that only one -align_opts_aea option should be given, with
            possibly many parameters to be passed on to align_epi_anat.py.

            Note the second example.  In order to pass '-source_automask+4' to
            3dAllineate, one must pass '-Allineate_opts -source_automask+4' to
            align_epi_anat.py.

            Please see "align_epi_anat.py -help" for more information.
            Please see "3dAllineate -help" for more information.


  -skullstrip_opts    
      use:                Alternate options for 3dSkullstrip.
                          like -rat or -blur_fwhm 2


Problems down below:
        + Piece of cerbellum missing, reduce -shrink_fac_bot_lim 
          from default value.
        + Leakage in lower areas, increase -shrink_fac_bot_lim 
          from default value.


-shrink_fac_bot_lim 0.4


-tlrc_opts_at OPTS ...   : add additional options to @auto_tlrc

                e.g. -tlrc_opts_at -OK_maxite

  This option is used to add user-specified options to @auto_tlrc,
            specifically those afni_proc.py is not otherwise set to handle.

            In the case of -tlrc_NL_warp, the options will be passed to
            auto_warp.py, instead.

            Please see '@auto_tlrc -help' for more information.
            Please see 'auto_warp.py -help' for more information.

s

# extra commands
 -volreg_tlrc_warp                                  \
	-do_block despike tshift align tlrc volreg blur mask scale regress \



