#!/bin/bash
cd ..
result=${PWD##*/}
cd run
qsub -q dgx -N $result -j y -o ~/Jobs << EOF
cd "$PWD"

/Projects/jmaia/Repo/namd_devel_2/namd/GPU_Replica/charmrun ++local /Scr/jmaia/Binaries/dev_current/namd/Linux-x86_64-icc-sn-netlrts/namd3 +p16 +replicas 16 +devicesperreplica 1 equilibrium_parallel.0.conf +stdout ./f_out_0/f%d.out > ! forward.0.log 

EOF
