import MDAnalysis as mda

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from multiprocessing import cpu_count

n_jobs = cpu_count()

u = mda.Universe("/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/CHL.AMB.0/min/1.psf", "/Scr/arango/ergosterol-amb/1-WorkflowDevelopment/5-forpaper/CHL.AMB.0/min/1.eqnA.dcd")
u.trajectory
