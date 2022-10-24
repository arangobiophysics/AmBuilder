
mol load pdb ./NMR_sponge.pdb
set midlist {}
set nseg 1
set list [lsort -u [[atomselect top "resname ERG"] get residue]]
puts $list
#set list "1"
foreach var $list {
  puts $var
  	set sel [atomselect 0 "resname ERG and residue $var"]
  	set selE [atomselect 0 "residue $var and resname ERG"]
  	mol load pdb /Scr/arango/ergosterol-amb/structure_files/ERG.pdb
  	
    

  	set sel2 [atomselect top "resname ERG"]
  	set selC [atomselect top "resname ERG"]


    set listE [$selE get name]
    set listD [$sel2 get name]
    set coords {}

    foreach varx $listE {
      set selCc [atomselect top "name $varx"]
      set selT [atomselect 0 "residue $var and resname ERG and name $varx"]
      set inC [$selCc get index]
      set inT [$selT get index]
      lappend coords $inC
    
      puts "Name $varx ERG $inT ERG $inC"

    }

    set listT [$selE get index]
    set listC [$sel2 get index]
    puts "LIST T"
    puts $listT
    puts "LIST C"
    puts $listC

#list C is top (single ERG)

    set dalist {}
    foreach vara $listD {
        set ahh [lsearch -exact $listE $vara]
        puts $ahh
        lappend dalist $ahh
	set selg [atomselect top "name $vara"]
	set loc [lindex $listD $ahh]
        $selg moveto [lindex [[atomselect 0 "residue $var and resname ERG and name $vara"] get {x y z}] 0]
    }

  	#set transformation_matrix [measure fit $selC $selE]

    $sel2 set segname "MEMB"
    $sel2 set resid $var
    incr nseg
  	$sel2 writepdb ./chl_fold/ERG.$var.pdb
    #for TopoTools
    set mol1 [mol new ./chl_fold/ERG.$var.pdb waitfor all]
    
    lappend midlist $mol1
}  
#set mola [mol new ./mergedAMB.pdb waitfor all]
#lappend midlist $mola

package require topotools 1.6
set mol [::TopoTools::mergemols $midlist]
animate write pdb mergedERG.pdb $mol




exit
