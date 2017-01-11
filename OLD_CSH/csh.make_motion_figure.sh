#!/bin/csh

# Script generate 1D plot of motion and save it as a figure
######## Created by Alexandre R. Franco

## Study
set study = $1
## subject
set subj=$2
## analysisdirectory/subject
set dir=$3
## name of the epiing-state scan
set epi=$4


## directory setup
set func_dir = ${dir}/${epi}

echo ---------------------------------------
echo ---- 1D plot of motion  ${epi}  ----
echo ---------------------------------------


cd ${func_dir}


 #1dplot -volreg -dx 2 -sepsc1 -xlabel Time LING004.LET_mc.1D
1dplot -volreg -dx 2 -sepsc1 -png MOTION.${study}${subj}.${epi} -title "movimento" -xlabel Time ${study}${subj}.${epi}_mc.1D

mv MOTION.${study}${subj}.${epi}.png ../figures

