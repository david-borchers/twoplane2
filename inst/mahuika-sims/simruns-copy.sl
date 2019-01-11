#!/bin/bash -e
#SBATCH --job-name=twoplane_shortlag
## Your NeSI project:
#SBATCH --account=uoa00493
## Maximum time for each individual job on each individual core. If
## your job runs for longer it will be TERMINATED. I am asking for two
## days below (HH:MM:SS).
#SBATCH --time=50:00:00
## Amount of memory (RAM) for each individual job on each core.
#SBATCH --mem-per-cpu=2G
## You can include the below two lines if you want emails when your
## jobs start/end.
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ben.stevenson@auckland.ac.nz
module load R/3.5.1-gimkl-2017a
module load GSL/2.3-gimkl-2017a
## Running an R script on each job.
srun R --vanilla < simruns-copy.r
