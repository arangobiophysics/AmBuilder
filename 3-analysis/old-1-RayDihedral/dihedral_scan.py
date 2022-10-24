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

n_jobs = os.cpu_count()


def dihe_mp(frame_index, ag):
    ag.universe.trajectory[frame_index]
    dihed = ag.dihedral
    a = dihed.dihedral
    #a = dihed
    b = dihed.value()
    return frame_index, b

@ray.remote#(memory=2500 * 1024 * 1024)
def analyze_block(blockslice, func, atomsel, *args, **kwargs):
    result = []
    for ts in ag.trajectory[blockslice.start:blockslice.stop]:
        A = func(ts.frame, atomsel)
        result.append(A)
    return result

ag = mda.Universe("/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/CHL.AMB.0/min/1.psf", "/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/CHL.AMB.0/min/1.eqnA.dcd")
protein = ag.select_atoms('resname AMB and resid 54 and name C7 O5 C12 C10')

n_frames = ag.trajectory.n_frames
n_blocks = n_jobs

#floor divide the total number of frames to parallize
n_frames_per_block = n_frames // n_blocks

blocks = [range(i * n_frames_per_block, (i + 1) * n_frames_per_block) for i in range(n_blocks - 1)]
blocks.append(range((n_blocks - 1) * n_frames_per_block, n_frames))


#parameters = list(zip([bs for bs in blocks],
#                        itertools.repeat(dihe_mp),
#                        itertools.repeat(protein)))
parameters = []
for bs in blocks:
    parameters.append([bs, dihe_mp, protein])

if __name__ == "__main__":
    ray.init()
    futures = [analyze_block.remote(*par) for par in parameters]
    print(futures)
    s = time.time()
    results = ray.get(futures)
    e = time.time()
    print(f"Took {e-s} seconds")
    print(results)
