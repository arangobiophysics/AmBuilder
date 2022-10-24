
#########
#VMD script to scrape water and leave only C22 for AMB sponges
#Andres S. Arango
#2022-10-16
#########

set NUM [lindex $argv 0]
mol new /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/$NUM.0/min/1.pdb
mol addfile /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/$NUM.0/min/1.eqnA.dcd waitfor all

set sel [atomselect top "resname AMB and name C22"]
set sel0 [atomselect top "resname AMB and name C22" frame 0]

$sel0 writepdb /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/$NUM.0/min/1.C22.pdb
animate write dcd /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/$NUM.0/min/1.eqnA.C22.dcd beg 1 end -1 skip 1 waitfor -1 sel $sel top

exit
