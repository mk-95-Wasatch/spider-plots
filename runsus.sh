#!/bin/bash

#SBATCH --time=$TIME # walltime, abbreviated by -t
#SBATCH --job-name=$JOB.$nodes.$size
#SBATCH -e slurm-%j.err-%n
#SBATCH -o slurm-%j.out-%n
#SBATCH --ntasks=$procs # number of MPI tasks, abbreviated by -n # additional information for allocated clusters

## Ash account
#SBATCH --account=smithp-guest
#SBATCH --partition=ash-guest
#SBATCH-C "c12"

# # notchpeak
## SBATCH --account=saad
## SBATCH --partition=notchpeak-freecycle

#SBATCH --mail-user=karammokbel@gmail.com

export SCI_DEBUG='ComponentTimings:+'

cd $INPUT_DIR

OUT="../$OUTPUT_DIR/$JOB.$nodes.$size.out"
EXE=../../$SUS
MPIRUN="mpirun -np $procs"

echo "---------------------------------"
date
echo "sus=$SUS"
echo "SCRIPT_DIR=$SCRIPT_DIR"
echo "OUTPUT_DIR=$OUTPUT_DIR"
echo "INPUT_DIR=$INPUT_DIR"
echo "ups=$ups"
echo "procs=$procs"
echo "size=$size"
echo "threads=$threads"
echo "nodes=$nodes"
echo "pwd=`pwd`"
echo "---------------------------------"
    
pwd
# export MPICH_MAX_THREAD_SAFETY=multiple
echo "$MPIRUN  $EXE ../inputs/$ups &> $OUT"
$MPIRUN $EXE ../$INPUT_DIR/$ups &> $OUT



