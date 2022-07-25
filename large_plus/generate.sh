#!/bin/bash

#-------------------------------------------------------------------

function modify_ups() {
  ups=$1
  num_timesteps=$2
  L0_resolution=$3
  L0_patches=$4
  perl -pi -w -e "s/<<num_timesteps>>/$num_timesteps/" $INPUT_DIR/$ups
  perl -pi -w -e "s/<<L0_resolution>>/$L0_resolution/"       $INPUT_DIR/$ups
  perl -pi -w -e "s/<<L0_patches>>/$L0_patches/"       $INPUT_DIR/$ups
}
#-------------------------------------------------------------------
PROJECT="TGV0001"
SUS="sus"
OUTPUT_DIR="outputs"
INPUT_DIR="inputs"

CORES="1024 2048 4096"
# CORES="2 4 8 16 32 64 128 256 512 1024"
#CORES="64 128 256 512"
# CORES="2"
# MEMORY=":mem=110GB"      # use 128GB nodes

JOB="large_plus"
THREADS="1"

#__________________________________
# common to all input files
num_timesteps="100"
# with problem size we increase the resolution by a 
# factor of two in all directions
L0_resolution="[256,256,256]"

#__________________________________
# 2 cores
ups="2.ups"
L0_patches="[2,1,1]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 4 cores
ups="4.ups"
L0_patches="[2,2,1]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 8 cores
ups="8.ups"
L0_patches="[2,2,2]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 16 cores
ups="16.ups"
L0_patches="[4,2,2]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 32 cores
ups="32.ups"
L0_patches="[4,4,2]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 64 cores
ups="64.ups"
L0_patches="[4,4,4]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 128 cores
ups="128.ups"
L0_patches="[8,4,4]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 256 cores
ups="256.ups"
L0_patches="[8,8,4]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 512 cores
ups="512.ups"
L0_patches="[8,8,8]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 1024 cores
ups="1024.ups"
L0_patches="[16,8,8]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 2048 cores
ups="2048.ups"
L0_patches="[16,16,8]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches

#__________________________________
# 4096 cores
ups="4096.ups"
L0_patches="[16,16,16]"
cp ../taylor-green-vortex-3d.ups $INPUT_DIR/$ups
modify_ups $ups $num_timesteps $L0_resolution $L0_patches


for cores in $CORES; do
    
    size=`expr $cores \* 1` # if using nodes instead of CORES #36 is the number of cores per node` 
    ups=$cores.ups
    
    if [ $cores -lt 128 ]; then
      TIME=00:30:00
    elif [ $cores -lt 256 ]; then
      TIME=00:20:00
    elif [ $cores -lt 512 ]; then
      TIME=00:15:00
    else
      TIME=00:30:00
    fi

    if [ $THREADS -eq 1 ]; then
      procs=$size
      threads=1
    else
      procs=$cores
      threads=$THREADS
    fi 

    export JOB
    export ups
    export size
    export procs
    export threads
    export nodes
    export SUS
    export OUTPUT_DIR
    export INPUT_DIR
    export TIME
    
    echo "$JOB.$nodes.$size ../runsus.sh"
    # ../runsus.sh" # uncomment if you want to test locally
    sbatch -t $TIME --ntasks=$procs --job-name=$JOB.$nodes.$size ../runsus.sh
    
done
