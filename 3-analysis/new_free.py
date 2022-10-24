import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
import mdshare
import pyemma
from pyemma.util.contexts import settings
import matplotlib.pyplot as plt
import numpy as np
import mdshare
import pyemma
import mdtraj
import matplotlib
from ast import literal_eval
import pandas as pd
font = {'family' : 'normal',
        'weight' : 'normal',
        'size'   : 18}

matplotlib.rc('font', **font)
cmap="RdBu_r"

resi = ["EPI.WAT"]
fig, ax = plt.subplots(1,1,sharex=True,sharey=True,constrained_layout=True,)
for i, res in enumerate(resi):
	f=open("/Scr/arango/ergosterol-amb/dgx_runs/analysis/file1.txt",'r')
	
	for line in f:
	    new_list = literal_eval(line)
	f.close()
	
	old_data_1 = np.array(new_list)
	
	f=open("/Scr/arango/ergosterol-amb/dgx_runs/analysis/file2.txt",'r')
	
	for line in f:
	    new_list2 = literal_eval(line)
	f.close()
	old_data_2 = np.array(new_list2)
	
	###trying df
	df1 = pd.DataFrame(new_list)
	df2 = pd.DataFrame(new_list2)
	
	bataN = df1.T
	bataM = bataN.assign(mean=bataN.mean(axis=1))
	a = bataM[0:len(bataM)].values.ravel()
	
	dataN = df2.T
	dataM = dataN.assign(mean=dataN.mean(axis=1))
	b = dataM[0:len(dataM)].values.ravel()
	
	data_1 = a%360
	data_2 = b
	
	
	
	data_proj = np.vstack((data_1,data_2)).T
	pyemma.plots.plot_free_energy(                        
	    *data_proj.T,
	    kT=0.616,
	    vmin=0,
	    #vmax=6,
	    ax=ax,
	    legacy=False)

#fig.supxlabel('C19-O-C1′-C2′ (°)', fontsize=18)
#fig.supylabel('C20-C19-O-C1′ (°)', fontsize=18)
ax.set_xlabel('C19-O-C1′-C2′ (°)', fontsize=18)
ax.set_ylabel('C20-C19-O-C1′ (°)', fontsize=18)	
#plt.xlabel()
#plt.ylabel()
#plt.xticks(np.arange(0, 200+1, 50))
#plt.yticks(np.arange(-50, 150+1, 50))
plt.show()
#plt.savefig('tic1_tic2.pdf')
#savefig(str(res)+"-FE-customized.png", dpi=600)
#plt.savefig(str(res)+"-FE-customized.png", dpi=600)

