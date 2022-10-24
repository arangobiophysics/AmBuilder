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
cmap="RdBu_r"

resi = ["EPI.ERG", "EPI.CHL", "AMB.ERG", "AMB.CHL"]
fig, ax = plt.subplots(2,2,sharex=True,sharey=True,constrained_layout=True,)
for i, res in enumerate(resi):
	f=os.path.join("/Scr/arango/ergosterol-amb/dgx_runs/compound_screen/analysis/", "out1."+str(res)+".0.csv")
	files = glob.glob(f)	
	df1 = pd.concat(map(pd.read_csv, files), ignore_index=True).iloc[1:,:] #[times, 2]: col0->time & col1->dihed
	#print(df1)	
	f2=os.path.join("/Scr/arango/ergosterol-amb/dgx_runs/compound_screen/analysis/", "out2."+str(res)+".0.csv")
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




################################### Time series 

from statistics import mean
from statistics import stdev

a = [energy1[0:5000],energy2[0:5000],energy3[0:5000]]


b = np.array([*map(mean, zip(*a))])
c = np.array([*map(stdev, zip(*a))])
fig, ax = plt.subplots()
ax.plot(x, b, 'orangered')

ax.fill_between(x, b - c,  
                 b + c, color="#3F5D7D")  

#ax.grid(True)
#ax.set_xlim([0, 100])
#ax.set_ylim([0.6, 3.1])
ax.set_xlabel('Time (ns)', fontsize=10)
ax.set_ylabel('RMSD ($\AA$)', fontsize=10)
#ax.set_xmargin(100)
#ax.set_xmargin(.5)
#ax.margins(0.5) # 5% padding in all directions
#plt.axis('tight')
#plt.subplots_adjust(left=0.4, right=0.5)

#plt.show()
#fig.savefig('RMSD_tetramer_average.png', dpi=fig.dpi)
#fig.savefig('RMSD_tetramer_average.pdf', dpi=fig.dpi)
#plt.xlabel()
#plt.ylabel()
#plt.xticks(np.arange(0, 200+1, 50))
#plt.yticks(np.arange(-50, 150+1, 50))
plt.show()
#plt.savefig('tic1_tic2.pdf')
#savefig(str(res)+"-FE-customized.png", dpi=600)
#plt.savefig(str(res)+"-FE-customized.png", dpi=600)

