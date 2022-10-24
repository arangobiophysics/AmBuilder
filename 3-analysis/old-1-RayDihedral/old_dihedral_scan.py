import argparse
import MDAnalysis as mda
from MDAnalysis.analysis.dihedrals import Dihedral 
import pandas as pd
import ray
import os
import time
import functools
from typing import *

n_jobs = os.cpu_count()

parser = argparse.ArgumentParser()
parser.add_argument('--psf', type=str, default=None)
parser.add_argument('--trajs', nargs="*", type=str, default=None)
parser.add_argument('--multip', action="store_true", help="enable multiprocessing?")
parser.add_argument('--get_cartesian', type=bool, default=True, help="MDA data extraction")
parser.add_argument('--filename', type=str, default="default.npy") 
parser.add_argument('--data_dir', type=str, default=None)
parser.add_argument('--selections', type=str, default = 'resname AMB and resid 54 and name C7 O5 C12 C10')
args = parser.parse_args()

def dihe_mp(frame_index, ag):
    ag.universe.trajectory[frame_index]
    dihed = ag.dihedral
    a = dihed.dihedral
    b = dihed.value()
    return frame_index, b

@ray.remote(memory=2500 * 1024 * 1024)
def analyze_block(blockslice, func, *args, **kwargs):
    result = []
    for ts in ag.trajectory[blockslice.start:blockslice.stop]:
        A = func(ts.frame, *args)
        result.append(A)
    return result


class DihedralMultipro(object):
    def __init__(self, args: argparse.ArgumentParser):
        #Extracting parsed information from the object
        [setattr(self, key, val) for key, val in args.__dict__.items()]

    
    @staticmethod
    def load_traj(data_dir: str, psf: str, trajs: List[str], selections: str):
        assert psf is not None, "Need psf to continue"
        assert trajs is not None, "DCD(s) must be provided"
        top = psf
        top = os.path.join(data_dir, top)
        trajs = list(map(lambda inp: os.path.join(data_dir, inp), trajs ))
        prot_traj = mda.Universe(top, *trajs, in_memory=False)
        print("MDA Universe is created")
        

        return prot_traj.select_atoms(selections) 
    
    @property
    def calculate_dihe_trajs(self, ):
        s = time.time()
        print(self.__dict__)
        prot_ags = self.load_traj(self.data_dir, self.psf, self.trajs, self.selections)
        times = prot_ags.universe.trajectory.n_frames
        n_frames = prot_ags.trajectory.n_frames
        n_blocks = n_jobs
        n_frames_per_block = n_frames // n_blocks
        blocks = [range(i * n_frames_per_block, (i + 1) * n_frames_per_block) for i in range(n_blocks - 1)]
        blocks.append(range((n_blocks - 1) * n_frames_per_block, n_frames))

        diheds = [dihe_mp(ag=prot_ags, frame_index=frame) for frame in range(times)]
        diheds = [dihe_mp(ag=prot_ags, frame_index=frame) for frame in range(times)]
        #diheds = [dihe_mp.remote(ag=prot_ags, timestep=frame) for frame in range(times)]
        diheds = ray.get(diheds)
        return diheds
    
    def __call__(self, ):
        return self.calculate_dihe_trajs

if __name__ == "__main__":
    s = time.time()
    dihedral = DihedralMultipro(args)
    diheds = dihedral() #dihedral.calculate_dihe_trajs
    print(diheds)
    e = time.time()
    print(f"Took {e-s} seconds")
