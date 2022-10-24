package require solvate
package require autoionize
package require psfgen

topology ../../par/par_heme_ions.prm 
topology ../../par/stream/prot/toppar_all36_prot_heme.str 
topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/par_heme_ions.prm
topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/stream/prot/toppar_all36_prot_heme.str
topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/par_all36_lipid.prm

topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/par_all36m_prot.prm
topology /Scr/arango/membrane_AA/sepehr_build_fep/template_FEP/run/toppar/MZP.str
topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/par_all36_cgenff.prm
topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/top_all36_lipid.rtf
topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/top_all36_prot.rtf
topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/top_all36_cgenff.rtf
topology /Scr/arango/Aditi-Files/forJustin/simulating.drugs/par/toppar_water_ions_namd.str
topology /Scr/arango/membrane_AA/sepehr_build_fep/template_FEP/run/toppar/toppar_all36_lipid_cholesterol.str

topology /Scr/arango/ergosterol-amb/flooding_simulations/POPC.80.ERG.1.AMB.8/namd/toppar/toppar_all36_lipid_cholesterol.str
topology /Scr/arango/ergosterol-amb/flooding_simulations/POPC.80.ERG.1.AMB.8/namd/toppar/toppar_all36_lipid_miscellaneous.str
topology /Scr/arango/ergosterol-amb/weighted_ensemble/template_WESTPA/toppar/toppar_all36_lipid_cholesterol.str

topology /Scr/arango/ergosterol-amb/weighted_ensemble/template_WESTPA/toppar/toppar_all36_lipid_cholesterol.str
topology /Scr/arango/ergosterol-amb/weighted_ensemble/Distance_8AMB_1ERG_WESTPA2/par/stream/lipid/toppar_all36_lipid_cholesterol.str 
topology /Scr/arango/ergosterol-amb/weighted_ensemble/template_WESTPA/toppar/toppar_all36_lipid_sphingo.str

topology /Scr/arango/ergosterol-amb/weighted_ensemble/template_WESTPA/toppar/par_all36_lipid.prm
#topology /Scr/arango/ergosterol-amb/weighted_ensemble/template_WESTPA/toppar/amb/amb.prm  
topology /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/0-template_structures/AMB.str
topology /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/0-template_structures/AMB.prm
#pdbalias DRUG AMB
pdbalias residue HIS HSD
pdbalias atom ILE CD1 CD

#set what "CDL2"
#set id "test"

#Solvates and ionized the system
#foreach id {3251 7630 11498 17576 20687} {
    #mol new $id.protein.$what.psf
    mol new Simulation.ref.pdb
    readpsf Simulation.ref.psf
    coordpdb Simulation.ref.pdb
    #mol addfile $id.protein.$what.pdb waitfor all
    
    writepsf ref.removed.psf
    writepdb ref.removed.pdb
    solvate ref.removed.psf ref.removed.pdb -t 20 -o ref.sol
    autoionize -psf ref.sol.psf -pdb ref.sol.pdb -sc 0.15 -o reference.sNi
    mol delete all
#}
exit

