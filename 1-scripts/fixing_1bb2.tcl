
mol new ../1.psf
mol addfile ../1.pdb waitfor all


#get_cell based on water box, avoiding issues with lipids


#FOR BACKBONE RESTRAINTS 1.0
set selall1 [atomselect top "all"]
$selall1 set beta 0
set sel [atomselect top "noh and name CA or resname AMB and noh and not name C12 O5 O7 C19 C23 C22 O10 C18 N1 C15 O8"]
$sel set beta 1
set selall2 [atomselect top "all"]
$selall2 writepdb ../1.bb2.const.pdb 


exit
