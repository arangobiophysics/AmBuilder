
mol load pdb ./NMR_sponge.pdb
set midlist {}
set nseg 1
set list [lsort -u [[atomselect top "resname ERG"] get residue]]
puts $list
#set list "1"
foreach var $list {
  puts $var
  puts "HERe?"
  	set sel [atomselect 0 "resname ERG and residue $var"]
  	puts "sERe?"
  	set selE [atomselect 0 "residue $var and resname ERG and name C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17"]
  	mol load pdb /Scr/arango/ergosterol-amb/structure_files/converting_ERG2CHL/CHL1.pdb 
  	
    

  	set sel2 [atomselect top "resname CHL1"]
  	set selC [atomselect top "name C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17"]


    set listE [$selE get name]
    set coords {}

    foreach varx $listE {
      set selCc [atomselect top "name $varx"]
      set selT [atomselect 0 "residue $var and resname ERG and name $varx"]
      set inC [$selCc get index]
      set inT [$selT get index]
      lappend coords $inC
    
      puts "Name $varx ERG $inT CHL $inC"

    }

    set listT [$selE get index]
    set listC [$selC get index]
    puts "LIST T"
    puts $listT
    puts "LIST C"
    puts $listC

    set dalist {}
    foreach vara $listC {
        set ahh [lsearch -exact $coords $vara]
        puts $ahh
        lappend dalist $ahh
    }

    set selC [atomselect top "name C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17"]

  	set transformation_matrix [measure fit $selC $selE order $dalist]

  	#set transformation_matrix [measure fit $selC $selE]
  	$sel2 move $transformation_matrix

    $sel2 set segname "MEMB"
    $sel2 set resid $var
    incr nseg
  	$sel2 writepdb ./chl_fold/CHL.$var.pdb
    #for TopoTools
    set mol1 [mol new ./chl_fold/CHL.$var.pdb waitfor all]
    
    lappend midlist $mol1
}  
#set mola [mol new ./mergedAMB.pdb waitfor all]
#lappend midlist $mola

package require topotools 1.6
set mol [::TopoTools::mergemols $midlist]
animate write pdb CHL_127_only_CHL.pdb $mol

puts $list


exit
