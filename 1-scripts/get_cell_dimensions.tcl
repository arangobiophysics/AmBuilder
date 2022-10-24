
mol new ../1.psf
mol addfile ../1.pdb waitfor all


#get_cell based on water box, avoiding issues with lipids
set molid "top"
 set all [atomselect $molid "water"]
 set minmax [measure minmax $all]
 set vec [vecsub [lindex $minmax 1] [lindex $minmax 0]]

 set cellBasisVector1 "cellBasisVector1 [lindex $vec 0] 0 0"
 set cellBasisVector2 "cellBasisVector2 0 [lindex $vec 1] 0"
 set cellBasisVector3 "cellBasisVector3 0 0 [lindex $vec 2]"
 set center [measure center $all]
 set cellBasisVectorO "cellOrigin $center"
 $all delete




 exec sed -i "s/CELL1/$cellBasisVector1/g" ../eqnA.namd
 exec sed -i "s/CELL2/$cellBasisVector2/g" ../eqnA.namd
 exec sed -i "s/CELL3/$cellBasisVector3/g" ../eqnA.namd
 exec sed -i "s/CELLO/$cellBasisVectorO/g" ../eqnA.namd

 exec sed -i "s/CELL1/$cellBasisVector1/g" ../eqnB.namd
 exec sed -i "s/CELL2/$cellBasisVector2/g" ../eqnB.namd
 exec sed -i "s/CELL3/$cellBasisVector3/g" ../eqnB.namd
 exec sed -i "s/CELLO/$cellBasisVectorO/g" ../eqnB.namd

 exec sed -i "s/CELL1/$cellBasisVector1/g" ../eqnC.namd
 exec sed -i "s/CELL2/$cellBasisVector2/g" ../eqnC.namd
 exec sed -i "s/CELL3/$cellBasisVector3/g" ../eqnC.namd
 exec sed -i "s/CELLO/$cellBasisVectorO/g" ../eqnC.namd

 exec sed -i "s/CELL1/$cellBasisVector1/g" ../min.namd
 exec sed -i "s/CELL2/$cellBasisVector2/g" ../min.namd
 exec sed -i "s/CELL3/$cellBasisVector3/g" ../min.namd
 exec sed -i "s/CELLO/$cellBasisVectorO/g" ../min.namd

set selall1 [atomselect top "all"]
$selall1 set beta 0
set sel2 [atomselect top "(resname AMB or resname ERG or resname CHL1)"]
$sel2 set beta 3
set selall3 [atomselect top "all"]
$selall3 writepdb ../1.bbA.const.pdb 

set selall2 [atomselect top "all"]
$selall2 set beta 0
set sel [atomselect top "noh and (resname AMB or resname ERG or resname CHL1) and noh and not ((resname AMB and name C12 O5 O7 C19 C23 C22 O10 C18 N1 C15 O8 O144 O143 C140 C141 C142 O3 C5 N21 N138 C139) or (resname ERG and name C25 C27 C25 C26 C24 C23 C28 C21 C20 C22) or (resname CHL1 and name C20 C21 C22 C23 C24 C25 C26 C27))"]
$sel set beta 3
set selall2 [atomselect top "all"]
$selall2 writepdb ../1.bbC.const.pdb 

set sel2 [atomselect top "noh and (resname AMB or resname ERG or resname CHL1)"]
$sel2 set beta 3
set selall3 [atomselect top "all"]
$selall3 writepdb ../1.bbB.const.pdb 


exit
