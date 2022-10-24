#######
#Title

######


proc moveby {sel offset} {
  set newcoords {}
  foreach coord [$sel get {x y z}] {
    lvarpush newcoords [vecadd $coord $offset]
  }
  $sel set $newcoords
}
proc lsortby {sortf args} {
   set list [lindex $args end] ;# list to be sorted is last
   set args [lrange $args 0 end-1]
   set t {}
   foreach element $list {
       lappend t [list [eval $sortf [list $element]] $element]
   }
   set res {}
   foreach i [eval lsort $args -index 0 [list $t]] {
       lappend res [lindex $i 1]
   }
   set res
}

mol load pdb  /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/0-template_structures/mergedAMB.pdb
set midlist {}
set nseg 1
set list [lsort -u [[atomselect top "resname AMB"] get resid]]
#puts $list
#set list "1"
set wtf 0
foreach var $list {
  puts $wtf
  incr wtf  
  puts $var
  set sel [atomselect 0 "resname AMB and resid $var"]
  #$sel set resid $var
  #puts "sERe?"
  set selE [atomselect 0 "resid $var and resname AMB"]
  #set selE [atomselect top "resid 1 and resname ERG and name C1 C2 C3 C4 C5 C6 C7 C8 C9 C10"]
  #This is the individual AMB derviate you want to use to replace the wild type sponge
  #Replace this
  mol load pdb /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/0-template_structures/REPLACE_template.pdb 
  	
  set sel2 [atomselect top "resname AMB"]
  set selC [atomselect top "resname AMB"]


  set selC [atomselect top "resname AMB and name C1 C2 O1 C3 C4 C5 C7 C8"]
  set selE [atomselect 0 "resid $var and resname AMB and name C1 C2 O1 C3 C4 C5 C7 C8"]
   	
  #$selC lmoveto [lsort -index $dalist [$selE get {x y z}] ]
  set transformation_matrix [measure fit $selC $selE]
  $sel2 move $transformation_matrix

  $sel2 set segid B
  $sel2 set resid $nseg 
  incr nseg
  	

################
  $sel2 writepdb ./chl_fold/AMF.$var.pdb
    #for TopoTools
  set mol1 [mol new ./chl_fold/AMF.$var.pdb waitfor all]
    
  lappend midlist $mol1
}  
#set mola [mol new ./fixed_structure_AMFB.pdb waitfor all]
#lappend midlist $mola

package require topotools 1.6
set mol [::TopoTools::mergemols $midlist]
animate write pdb mergedAMB.pdb $mol

#puts $dalist
#puts $transformation_matrix

#puts $dalist
#puts $listE
#puts [$selC get name]
exit



