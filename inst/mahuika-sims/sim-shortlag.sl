#!/bin/bash -e
#SBATCH --job-name=twoplane_shortlag
## Your NeSI project:
#SBATCH --account=uoa00493
## Maximum time for each individual job on each individual core. If
## your job runs for longer it will be TERMINATED. I am asking for two
## days below (HH:MM:SS).
#SBATCH --time=10:00:00
## Amount of memory (RAM) for each individual job on each core.
#SBATCH --mem-per-cpu=2G
## You can include the below two lines if you want emails when your
## jobs start/end.
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ben.stevenson@auckland.ac.nz
## Code for array job.
#SBATCH --array=1-50
module load R/3.5.3-gimkl-2018b 
module load GSL/2.3-gimkl-2017a
## Running an R script on each job.
srun R --vanilla < sim-shortlag.r --args $SLURM_ARRAY_TASK_ID 20
