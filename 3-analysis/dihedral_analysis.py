import MDAnalysis as mda
from MDAnalysis.analysis.dihedrals import Dihedral
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import cm

def dihe(ag):
    a = ag.dihedral
    b = ag.value()
    return b

names = ["EPI.ERG", "EPI.CHL", "AMB.ERG", "AMB.CHL"]
for i, name in enumerate(names): 
    result = []
    for e in range(1):
        result.append("/Scr/arango/ergosterol-amb/dgx_runs/compound_screen/"+str(name)+".fep/run/f"+str(e)+"/f"+str(e)+".dcd")
        
    
    u = mda.Universe("/Scr/arango/ergosterol-amb/sponge_simulations/copy/"+str(name)+"/1.psf", result)
    
    # selection of atomgroups
    #resids for central AMBs
    # 
    reslist = [10, 11, 12, 123, 124, 125, 26, 27, 28, 32, 33, 34, 37, 38, 39, 4, 5, 54, 55, 56, 59, 6, 60, 61, 65, 66, 67]
    #print(len())
    
    psi_list1 = []
    psi_list2 = []
    psi_list3 = []
    for res in reslist:
        psi_anglex = u.atoms.select_atoms('resname AMB and resid '+str(res)+' and name C7 O5 C12 C15')
        psi_anglex = psi_anglex.dihedral # convert AtomGroup to Dihedral object
        psi_angley = u.select_atoms('resname AMB and resid '+str(res)+' and  name C7 O5 C12 C10')
        psi_angley = psi_angley.dihedral # convert AtomGroup to Dihedral object
        psi_anglez = u.select_atoms('resname AMB and resid '+str(res)+' and  name C8 C6 C4 C2')
        psi_anglez = psi_anglez.dihedral # convert AtomGroup to Dihedral object
        for ts in u.trajectory:
            psi_list1.append(dihe(psi_anglex))
            psi_list2.append(dihe(psi_angley))
            psi_list3.append(dihe(psi_anglez))
        #print(psi_list)
    
    df1 = pd.DataFrame(psi_list1)
    df2 = pd.DataFrame(psi_list2)
    df3 = pd.DataFrame(psi_list3)
    with open(f"file1{name}.txt", "w") as output:
        output.write(psi_list1)
    with open(f"file2{name}.txt", "w") as output:
        output.write(psi_list2)
    with open(f"file3{name}.txt", "w") as output:
        output.write(psi_list3)
    np.save(f"file1{name}.npy", df1)
    np.save(f"file2{name}.npy", df2)
    np.save(f"file3{name}.npy", df3)
