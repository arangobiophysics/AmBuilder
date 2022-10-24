import argparse
import MDAnalysis as mda
from MDAnalysis.analysis.dihedrals import Dihedral 
import pandas as pd
import ray
import os
import time
import functools
from typing import *
import itertools
import argparse
import pickle

parser = argparse.ArgumentParser()
parser.add_argument('--residues', type=int, default=54) #Residue being analyzed, may be faster to do all at once
parser.add_argument('--dcdnum', type=int, default=0) #List of dcds
parser.add_argument('--selection', type=str, default="C7 O5 C12 C10") #Atoms for dihedrals
parser.add_argument('--complex', type=str, default="CHL.219") #Atoms for dihedrals
parser.add_argument('--resname', type=str, default="AMB") #Atoms for dihedrals
args = parser.parse_args()
res = args.residues
n_jobs = os.cpu_count()


def dihe_mp(frame_index, ag):
    ag.universe.trajectory[frame_index]
    dihed = ag.dihedral
    #a = dihed.dihedral
    a = dihed
    b = dihed.value()
    return frame_index, b

@ray.remote(memory=2500 * 1024 * 1024)
def analyze_block(blockslice, func, *args, **kwargs):
    result = []
    for ts in ag.trajectory[blockslice.start:blockslice.stop]:
        A = func(ts.frame, *args)
        result.append(A)
    return result

#ag = mda.Universe("/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/CHL.AMB.0/min/1.psf", "/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/CHL.AMB.0/min/1.eqnA.dcd")
#protein = ag.select_atoms('resname AMB and resid 54 and name C7 O5 C12 C10')
#
#n_frames = ag.trajectory.n_frames
#n_blocks = n_jobs
#
##floor divide the total number of frames to parallize
#n_frames_per_block = n_frames // n_blocks
#
#blocks = [range(i * n_frames_per_block, (i + 1) * n_frames_per_block) for i in range(n_blocks - 1)]
#blocks.append(range((n_blocks - 1) * n_frames_per_block, n_frames))
#
#
#
#
#parameters = list(zip([bs for bs in blocks],
#                        itertools.repeat(dihe_mp),
#                        itertools.repeat(protein)))
                    
if __name__ == "__main__":
    ray.init()
    #FOR TESTING
    #ag = mda.Universe("/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/CHL.AMB.0/min/1.psf", "/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/CHL.AMB.0/min/1.eqnA.dcd")
    ag = mda.Universe("/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/"+str(args.complex)+".0/min/1.psf", "/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/"+str(args.complex)+".0/run/f"+str(args.dcdnum)+"/f"+str(args.dcdnum)+".dcd")
    protein = ray.put(ag.select_atoms('resname '+str(args.resname)+' and resid '+str(args.residues)+' and name '+str(args.selection)))
    n_frames = ag.trajectory.n_frames
    n_blocks = n_jobs
        #floor divide the total number of frames to parallize
    n_frames_per_block = n_frames // n_blocks
    blocks = [range(i * n_frames_per_block, (i + 1) * n_frames_per_block) for i in range(n_blocks - 1)]
    blocks.append(range((n_blocks - 1) * n_frames_per_block, n_frames))
    parameters = list(zip([bs for bs in blocks],
                            itertools.repeat(dihe_mp),
                            itertools.repeat(protein)))
        #ray.init(local_mode=True)
    futures = [analyze_block.remote(*par) for par in parameters]
    s = time.time()
    results = ray.get(futures)
    f = open(str(args.complex)+"."+str(args.dcdnum)+"."+str(args.residues)+".npy", "wb")
    pickle.dump(results, f) 
    e = time.time()
    print(f"Took {e-s} seconds")
    
