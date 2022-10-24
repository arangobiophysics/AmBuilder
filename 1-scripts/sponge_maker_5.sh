#!/bin/bash

#This script makes the required files for namd3 simulation


DRUGNAME="${1}"
PROTNAME="${2}"
RPL="${3}"




if [ -z "$1" ]; then
  echo "MISSING AMPHO DERIVATIE:"
  echo "sponge maker requires 2 arguements STEROL, AMPHO, & REPLICA"
  echo "Use the same names as your parameters"
  #This is to avoid selection errors later on
  exit
fi

if [ -z "$2" ]; then
  echo "MISSING PROTEIN:"
  echo "sponge maker requires 3 arguements STEROL, AMPHO, & REPLICA"
  echo "3 letter names for drug and protein are recommended"
  exit
fi

if [ -z "$3" ]; then
  echo "MISSING REPLICA:"
  echo "sponge maker requires 3 arguements STEROL, AMPHO, & REPLICA"
  echo "3 letter names for drug and protein are recommended"
  exit
fi


echo ""
echo "#########################"
echo "#  YOUR STEROL IS $DRUGNAME   #"
echo "#  YOUR AMPHO IS $PROTNAME    #"
echo "#  THIS IS REPLICA $RPL    #"
echo "#########################"
echo ""


##################################################################################################
##################################################################################################
##################################################################################################

#Template-Sterol:
#-structure-prep
#|-chl_fold
#-min
#-run
#|-par
#-analysis
#Making directories
mkdir -p "$DRUGNAME.$PROTNAME.$RPL"
mkdir -p "$DRUGNAME.$PROTNAME.$RPL/structure-prep"
mkdir -p "$DRUGNAME.$PROTNAME.$RPL/structure-prep/chl_fold"
mkdir -p "$DRUGNAME.$PROTNAME.$RPL/min"
cp -r /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/run_template ./$DRUGNAME.$PROTNAME.$RPL/run
sed -i -e "s/AMB.prm/$PROTNAME.prm/g" ./$DRUGNAME.$PROTNAME.$RPL/run/equilibrium_parallel.0.conf

mkdir -p "$DRUGNAME.$PROTNAME.$RPL/analysis"


#mkdir -p "./$DRUGNAME.$PROTNAME/reference.files"
#rsync -avt /Projects/arango/par ./$DRUGNAME.$PROTNAME/run/
ln -s /Projects/arango/par ./$DRUGNAME.$PROTNAME.$RPL/run/

cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/$DRUGNAME-scripts/* ./$DRUGNAME.$PROTNAME.$RPL/structure-prep/
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/fixing_AMB.tcl ./$DRUGNAME.$PROTNAME.$RPL/structure-prep/
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/simprep_NAMD3_ampho.sh ./$DRUGNAME.$PROTNAME.$RPL/
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/FIXING_ALL_DERIVATIVES-0.tcl ./$DRUGNAME.$PROTNAME.$RPL/structure-prep/
##################################################################################################


read -p "Do you have a starting XPLOR strucutre (y/n) `echo $'\n> '`" CONT
if [ "$CONT" = "y" ]; then
  
  echo ""
  read -e -p "Input location of your starting XPLOR strucutre `echo $'\n> '`" AHH 
  
else
  echo "If you don't go get them"
  echo "Good bye"
  exit 1;
fi

#########################################################################
##### MODIFYING FILES ###################################################

TRAJECTORY=$PARF
echo "Copying files"
#cd ./$DRUGNAME.$PROTNAME/reference.files
cp $AHH ./$DRUGNAME.$PROTNAME.$RPL/structure-prep/NMR_sponge.pdb

cd ./$DRUGNAME.$PROTNAME.$RPL/structure-prep/

#NEED A STEP TO FIX THE STEROLS

#sed -i -e "s/SPONGE/$PROTNAME/g" ./MERGING_AMBnSTER.tcl
mv FIXING_ALL_DERIVATIVES-0.tcl 0-FIXING_DERIVATIVES.tcl
mv finalFINAL_STEROL_FIXER.tcl 1-STEROL_FIXER.tcl
mv MERGING_AMBnERGOSTER.tcl 2-MERGE_AMPHOnSTER.tcl
FILE=./$DRUGNAME.$PROTNAME.$RPL/structure-prep/mergedAMB.pdb

sed -i -e "s/AMB.prm/$PROTNAME.prm/g" 2-MERGE_AMPHOnSTER.tcl
sed -i -e "s/AMB.str/$PROTNAME.str/g" 2-MERGE_AMPHOnSTER.tcl
sed -i -e "s/REPLACE/$PROTNAME/g" 0-FIXING_DERIVATIVES.tcl

if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist in structure_prep, if you've prepared an AMB sponge use mergedAMB.pdb along with FIXING_ALL_DERIVATIVES script :)"
fi

#vmd64 -dispdev text -e ./FIXING_ALL_DERIVATIVES-0.tcl
#vmd64 -dispdev text -e ./MERGING_AMBnSTER.tcl

exit 



