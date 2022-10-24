
import itertools
import matplotlib.pyplot as plt
import MDAnalsysis as mda
from MDAnalyais.analysis.distances import distance_array
import numpy as np
import seaborn as sns
import os
import ray
import time

n_jobs = os.cpu_count()

def get_dist_frame(frame_index, CAGroup):
    CAGroup.universe.trajectory[frame_index]
    return distance_array(CAGroup.positions, CAGroup.positions)

@ray.remote
def analyyze_block(blockslice, func, *args, **kwargs):
    result = []
    for ts in u.trajectory[blockslice.strart:blockslice.stop]:
        A = func(ts.frame, *args)
        result.append(A)
    return result

u = mda.Universe('beta_glucose_WT.psf', 'beta_glucose_WT.dcd')
protein = u.select_atoms('name CA')
n_residues = len(protein.positions)

n_frames = u.trajectory.n_frames
n_blocks = n_jobs

#floor divide of the total number of frames to parallize effectively
n_frames_per_block = n_frames // n_blocks
blocks = [range(i * n_frames_per_block, (i + 1) * n_frames_per_block) for i in range(n_blocks - 1)
blocks.append(range((n_blocks - 1) * n_frames_per_block, n_frames))

parameters = list(zip([bs for bs in blocks],
                        itertools.repeat(get_dist_frame),
                        itertools.repeat(protein)))

if __name__ == '__main__':
    ray.init()
    futures = [analyze_block.remote(*par) for par in parameters]
    start_time = time.time()
    results = ray.get(futures)
    duration = time.time() - start_time
    print(f'{duration=}')
    
    result = np.zeros((n_residues, n_residues, len(u.trajectory)))

    i = 0
    for actor in range(len(results)):
        for frame in range(len(results[actor])):
            result[:,:,i] = results[actor][frame]
            i +=1

    aves = np.average(results, axis=2)

    #np.save('rawdata.npy', result)
    #np.save('averages.npy', aves)

    sns.heatmap(data=aves, cmap='inferno')
    plt.show()
