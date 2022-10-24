load /Projects/jribeiro/psfgen_center/psfgen2.0_shared_object/libpsfgen.so
set dir /Scr/arango/ergosterol-amb/structure_files/making_219
#mol load pdb $dir/240_cmr_127_0.sa.full.pdb

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
#MODIGY PARAMETERS BELOW!
topology /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/0-template_structures/AMB.str
topology /Scr/arango/ergosterol-amb/1-WorkflowDevelopment/0-template_structures/AMB.prm
pdbalias residue HIS HSD
pdbalias atom ILE CD1 CD


resetpsf
###################
#Adding in sterols#
###################
pdbalias residue AMFB AMB

segment MEMB { pdb ./ERG_127_only_ERG.pdb}
coordpdb ./ERG_127_only_ERG.pdb MEMB 

regenerate angles dihedrals
guesscoord

##################
#Adding in AMBder#
##################                    

segment AMFB { pdb ./mergedAMB.pdb}
coordpdb ./mergedAMB.pdb AMFB  

regenerate angles dihedrals
guesscoord

writepdb FinalMerged_AMB.pdb
writepsf FinalMerged_AMB.psf

exit
