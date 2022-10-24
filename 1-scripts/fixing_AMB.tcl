#######
#Title

######
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

mol load pdb ./NMR_sponge.pdb
set midlist {}
set nseg 1
set list [lsort -u [[atomselect top "resname AMFB"] get residue]]
#puts $list
#set list "1"
foreach var $list {
  #puts $var
  #puts "HERe?"
  	set sel [atomselect 0 "resname AMFB and residue $var"]
  	$sel set resid $var
  	#puts "sERe?"
  	set selE [atomselect 0 "residue $var and resname AMFB"]
  	#set selE [atomselect top "resid 1 and resname ERG and name C1 C2 C3 C4 C5 C6 C7 C8 C9 C10"]
  	mol load pdb /Scr/arango/ergosterol-amb/structure_files/AMB.pdb 
  	
    
    

  	set sel2 [atomselect top "resname AMB"]
  	set selC [atomselect top "resname AMB"]


    set listE [$selE get name]
    set coords {}

    foreach varx $listE {
      #set selC [atomselect top "name \"C*.\" and not name C27 C26 C25 C24 C23 C22 C21 C20 C18"]
      set selCc [atomselect top "name $varx"]
      set selT [atomselect 0 "residue $var and resname AMFB and name $varx"]
      set selX [atomselect top "resname AMB and name $varx"]
      set inC [$selCc get index]
      set inT [$selT get index]
      lappend coords $inC
    
    
    # Moving each atom one at a time
    set poss [$selT get {x y z}]
      set goodlist {O2 O3 H42 H48 H39 H44 H50 H6 H12 H4 H3 H7 O1 O13 O14 O12 O11 O16 O9 O15 C45 C44 C47 O6 O17 H63 H68 H69 H70 O5 O7 N1 O10 H38 H71 H59 O8 H32 H33 H34 C23 H14 C43 C46 C42 H51 H45 H40 H41 H46 H52 H73 H18 H72 H47 H61 H62 H66 H10 H1 H2 H35 H25 H58 H64 H67 H65 C39 C38 H55 C36 H54}
      set badlist {O60 O61 H26 H28 H25 H27 H29 H19 H20 H18A H18B H14B O59 O51 O52 O53 O54 O55 O56 O64 C35 C34 C40 O57 O58 H34 H40A H40B H40C O63 O65 N O67 H67 H64 H36 O66 H10X H10Y H10Z C106 H101 C38 C39 C36 H2B H4B H6B H6A H4A H2A H58 H57 H55 H54 H38A H38B H39C H12B H17 H16 H24 H23 H33 H35 H39A H39B C32 C31 H31 C30 H30}
 
      set w 0
      foreach gl $goodlist {
        set selg [atomselect top "name $gl"]
        set loc [lindex $badlist $w]
        $selg moveto [lindex [[atomselect 0 "residue $var and resname AMFB and name $loc"] get {x y z}] 0]
        incr w
      }


      #set goodlist {O2 O3 O4 H42 H48 H39 H44 H50 H12 H6 H4 H3 H12 H7 O1 O13 O14 O12 O11 O16 O9 O15 C45 C44 C47 O6 O17 H63 H68 H69 H70 O5 O7 N1 O10 H38 H71 H59 O8 H32 H33 H34 C23 H14 C43 C46 C42 H51 H45 H40 H41 H46 H52 H73 H18 H72 H47 H61 H62 H65 H10 H1 H2}
      #set badlist {O60 O61 O63 H26 H28 H25 H27 H29 H20 H19 H18A H18B H16 H14B O59 O51 O52 O53 O54 O55 O56 O64 C35 C34 C40 O57 O58 H34 H40A H40B H40C O63 O65 N O67 H67 H64 H36 O66 H10X H10Y H10Z C106 H101 C38 C39 C36 H2B H4B H6B H6A H4A H2A H58 H57 H55 H54 H38A H38B H39C H12B H17 H16}
      set goodlist2 {C41 C34 C32 C30 C28 C26 C24 C22 C20 C16 C13 C10 C7 C40 H57 H60 H56 C37 C35 C33 C31 C29 H53 C27 C25 C21 C17 C14 C11 C9 C6 C8 C4 C2 C5 C1 H9 H5 H8 H11 H13 H15 H20 H24 C19 H28 C22 H22 C18 C15 H19 C12}
      set badlist2 {C33 C29 C28 C27 C26 C25 C24 C24 C23 C22 C21 C20 C19 C37 H37 H38C H32 C1 C2 C3 C4 C5 H53 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C41 C17 H60 H15 H14A H12A H11 H21 H22 H105 C105 H104 C104 H103 C103 C102 H102 C101}
 
      set w2 0
      foreach gl $goodlist2 {
        set selg [atomselect top "name $gl"]
        set loc [lindex $badlist2 $w2]
        $selg moveto [lindex [[atomselect 0 "residue $var and resname AMFB and name $loc"] get {x y z}] 0]
        incr w2
      }

      set goodlist3 {C3 H4 H4 H27 H21 H23 H16 H17 H29 H30 H31 O4 H26 H37 H36 H43 H49}
      set badlist3 {C18 H43 H18A H56 H9 H66 H10B H10A HN1 HN2 HN3 O62 H8 H7B H7A H5 H43}
 
      set w3 0
      foreach gl $goodlist3 {
        set selg [atomselect top "name $gl"]
        set loc [lindex $badlist3 $w3]
        $selg moveto [lindex [[atomselect 0 "residue $var and resname AMFB and name $loc"] get {x y z}] 0]
        incr w3
      }

    }

    set listT [$selE get index]
    #molecule you want to replace with
    set listC [$selC get index]
    #puts "LIST T"
    #puts $listT
    #puts "LIST C"
    #puts $listC

    set dalist {}
    foreach vara $listC {
        set ahh [lsearch -exact $coords $vara]
        #puts $ahh
        lappend dalist $ahh
    }

    set selC [atomselect top "resname AMB"]

  	#set transformation_matrix [measure fit $selC $selE order $dalist]
  	#foreach vee [$selC get name] {
  	#	$vee moveto [atomselect 0 ""]
  		#}
  	
  	#$selC lmoveto [lsort -index $dalist [$selE get {x y z}] ]
  	#set transformation_matrix [measure fit $selC $selE]
  	#$sel2 move $transformation_matrix

    $sel2 set segid AMFB 
    $sel2 set segname AMFB
    $sel2 set resid $nseg 
    incr nseg

################
  	$sel2 writepdb ./chl_fold/AMB.$var.pdb
    #for TopoTools
    set mol1 [mol new ./chl_fold/AMB.$var.pdb waitfor all]
    
    lappend midlist $mol1
}  
package require topotools 1.6
set mol [::TopoTools::mergemols $midlist]
animate write pdb mergedAMB.pdb $mol

exit



