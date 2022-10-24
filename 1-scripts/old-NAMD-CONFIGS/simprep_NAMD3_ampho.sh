#!/bin/bash

#This script makes the required files for namd3 simulation


PROTNAME="${1}"
DRUGNAME="${2}"





if [ -z "$1" ]; then
  echo "MISSING SYSTEM-NAME:"
  echo "simprep requires 2 arguements SYSTEM-NAME & PROTEIN"
  echo "3 letter names for drug and protein are recommended"
  #This is to avoid selection errors later on
  exit
fi

if [ -z "$2" ]; then
  echo "MISSING PROTEIN:"
  echo "simprep requires 3 arguements SYSTEM-NAME & PROTEIN"
  echo "3 letter names for drug and protein are recommended"
  exit
fi



echo ""
echo "#########################"
echo "#  YOUR DRUG IS $DRUGNAME     #"
echo "#  YOUR PROTEIN IS $PROTNAME  #"
echo "#########################"
echo ""


##################################################################################################
##################################################################################################
##################################################################################################





#Making directories
mkdir -p "min"

mkdir -p "./min/reference.files"
rsync -avt /Projects/arango/par .

##################################################################################################
##################################################################################################
##################################################################################################



read -p "Do you have a PSF and PDB for your system ready in structure prep? (y/n)   `echo $'\n> '`" CONT
if [ "$CONT" = "y" ]; then
  
  echo "Copying files"
  TEST=`pwd`
  STRF=$TEST/structure-prep/FinalMerged_AMB.psf
  PARF=$TEST/structure-prep/FinalMerged_AMB.pdb
  

else
	read -p "Do you have a PSF and PDB for your system ready in structure prep? (y/n)   `echo $'\n> '`" CONT
	if [ "$CONT" = "y" ]; then
  
  		echo "Copying files"
  		read -e -p "Specify the location of your .psf file:  `echo $'\n> '`" STRF
  
  		read -e -p "Specify the location of your .pdb file:  `echo $'\n> '`" PARF
	else
  		echo "If you don't have your psf and pdb files go get them"
  		echo "Good bye"
  		exit 1;
	fi
fi

TRAJECTORY=$PARF
echo "Copying files"

##################################################################################################


#Copying scripts
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/solvateNionze.tcl ./min/reference.files/ 
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/get_cell_dimensions.tcl ./min/reference.files/ 


#Copying config files
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/NAMD-CONFIGS/min.namd ./min/min.namd
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/NAMD-CONFIGS/eqnA.namd ./min/eqnA.namd
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/NAMD-CONFIGS/eqnB.namd ./min/eqnB.namd
cp /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/1-scripts/NAMD-CONFIGS/eqnC.namd ./min/eqnC.namd

##################################################################################################

cp $STRF ./min/reference.files/Simulation.ref.psf
cp $PARF ./min/reference.files/Simulation.ref.pdb


cd ./min/reference.files
#Make sure the system is solvated properly and ionzed well.


sed -i -e "s|AMB.prm|$DRUGNAME.prm|g" solvateNionze.tcl
sed -i -e "s|AMB.str|$DRUGNAME.str|g" solvateNionze.tcl
  vmd64 -dispdev text -e ./solvateNionze.tcl
  #### RUN SOLVATION SCRIPT




echo "creating 1.psf and 1.pdb"

cp ./reference.sNi.pdb ../1.pdb
cp ./reference.sNi.psf ../1.psf

echo "getting cell dimensions and creating restraint file for equilibration: 1.bb.const.pdb"

vmd64 -dispdev text -e ./get_cell_dimensions.tcl
echo "creating restraint files"
cd ../../


##################################################################################################
#vmd64 -dispdev text -e ./reference.files/get_reference_for_sim.tcl -args $POSE

#Chaning file titles and incorporating parameters
sed -i -e "s|PROT|$PROTNAME|g" ./min/min.namd
sed -i -e "s|PROT|$PROTNAME|g" ./min/eqnA.namd
sed -i -e "s|PROT|$PROTNAME|g" ./min/eqnB.namd
sed -i -e "s|PROT|$PROTNAME|g" ./min/eqnC.namd

sed -i -e "s|DRUG|VDN|g" ./min/min.namd
sed -i -e "s|DRUG|VDN|g" ./min/eqnA.namd
sed -i -e "s|DRUG|VDN|g" ./min/eqnB.namd
sed -i -e "s|DRUG|VDN|g" ./min/eqnC.namd


##########


#####CHECKING FOR LIGAND
read -p "Do you have a ligand in your system ($DRUGNAME)? (y/n)   `echo $'\n> '`" CONT
if [ "$CONT" = "y" ]; then
	
	read -e -p "Specify the short name of your drug (parameter files):  `echo $'\n> '`" DRGN
	
	sed -i -e "s|VDN|$DRGN|g" min/eqnA.namd
	sed -i -e "s|VDN|$DRGN|g" min/eqnB.namd
	sed -i -e "s|VDN|$DRGN|g" min/eqnC.namd
	sed -i -e "s|VDN|$DRGN|g" min/min.namd
	
else
	echo "Continuing to membrane check"
	echo ""
fi



#Ask to keep str and par files

echo ""
echo "########################################################################"
echo ""
echo "########################################################################"
echo ""
echo "########################################################################"
echo ""
echo "########################################################################"
echo ""
echo "Before you run your simulation be sure to make sure it looks fine"
echo "Also double check that you have all the needed parameters for you system"
echo "Happy simulating!"

echo ""
echo "########################################################################"
echo ""
echo "########################################################################"
echo ""
echo "########################################################################"
echo ""
echo "########################################################################"
echo ""
exit 




