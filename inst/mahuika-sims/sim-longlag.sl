#!/bin/bash -e
#SBATCH --job-name=twoplane_longlag
## Your NeSI project:
#SBATCH --account=uoa00493
## Maximum time for each individual job on each individual core. If
## your job runs for longer it will be TERMINATED. I am asking for two
## days below (HH:MM:SS).
#SBATCH --time=02:00:00
## Amount of memory (RAM) for each individual job on each core (in
## MB).
## You can include the below two lines if you want emails when your
## jobs start/end.
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ben.stevenson@auckland.ac.nz
## Code for array job.
#SBATCH --array=1-40
module load R/3.5.1-gimkl-2017a
module load GSL/2.3-gimkl-2017a
## Running an R script on each job.
srun R --vanilla < sim-longlag.r --args $SLURM_ARRAY_TASK_ID 3300 25
