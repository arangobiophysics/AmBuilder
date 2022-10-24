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
import glob
import os
font = {'family' : 'normal',
        'weight' : 'normal',
        'size'   : 18}

matplotlib.rc('font', **font)
cmap="Spectral"

resi = ["CHL.219", "CHL.243", "CHL.AMB", "CHL.EPI", "ERG.219", "ERG.243", "ERG.AMB", "ERG.EPI"]
fig, ax = plt.subplots(2,4,sharex=True,sharey=True,constrained_layout=True,)
for i, res in enumerate(resi):
	f=os.path.join("/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/3-analysis/", "Phii1."+str(res)+".*.csv")
	files = glob.glob(f)	
	df1 = pd.concat(map(pd.read_csv, files), ignore_index=True).iloc[1:,:] #[times, 2]: col0->time & col1->dihed
	#print(df1)	
	f2=os.path.join("/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/3-analysis/", "Phii2."+str(res)+".*.csv")
	files2 = glob.glob(f2)
	df2 = pd.concat(map(pd.read_csv, files2), ignore_index=True).iloc[1:,:]	#[times, 2]: col0->time & col1->dihed
	
	###trying df
	#df1 = pd.DataFrame(new_list)
	#df2 = pd.DataFrame(new_list2)
	
	#bataN = df1.T
	#bataM = bataN.assign(mean=bataN.mean(axis=1))
	#a = bataM[0:len(bataM)].values.ravel()
	
	#dataN = df2.T
	#dataM = dataN.assign(mean=dataN.mean(axis=1))
	#b = dataM[0:len(dataM)].values.ravel()
	
	df = pd.concat((df1, df2), axis=1) #[times, 4]
	df = df.iloc[:,[1,3]].apply(lambda inp: inp%360)

	#data_1 = a%360
	#data_2 = b%360
	
	
	
	#data_proj = np.vstack((data_1,data_2)).T
	data_proj = df.values #numpy ; [times, 2]
	pyemma.plots.plot_free_energy(                        
	    *data_proj.T,
	    kT=0.616,
	    vmin=0,
	    #vmax=6,
	    ax=ax.flatten()[i],
	    legacy=False)

#fig.supxlabel('C19-O-C1′-C2′ (°)', fontsize=18)
#fig.supylabel('C20-C19-O-C1′ (°)', fontsize=18)
ax.flatten()[2].set_xlabel('C19-O-C1′-C2′ (°)', fontsize=18)
ax.flatten()[2].set_ylabel('C20-C19-O-C1′ (°)', fontsize=18)	
#plt.xlabel()
#plt.ylabel()
#plt.xticks(np.arange(0, 200+1, 50))
#plt.yticks(np.arange(-50, 150+1, 50))
plt.show()
#plt.savefig('tic1_tic2.pdf')
#savefig(str(res)+"-FE-customized.png", dpi=600)
#plt.savefig(str(res)+"-FE-customized.png", dpi=600)

