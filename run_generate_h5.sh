#!/bin/bash
#!/usr/bin/env bash
####
################################## START OF EMBEDDED PBS COMMANDS ##########################
######## Common options ########
#PBS -S /bin/bash  #### Default Shell to be Used
#PBS -N Generate-H5  #### Job Name to be listed in qstat
####PBS -d /scratch/$USER ####run the job in the provided working directory path (will be HOME if the option is not called)
####PBS -D ####run the job in root dir
######## Logging Options ########
#PBS -o /scratch/hasm/pbs_job_output/$PBS_JOBNAME_$PBS_JOBID.stdout  #### stdout default path
#PBS -e /scratch/hasm/pbs_job_output/$PBS_JOBNAME_$PBS_JOBID.stderr  #### stderr default path
######## Email Options ########
#PBS -M sungminha@wustl.edu  #### email address to nofity with following options/scenarios
#PBS -m a ####abort, end notifications - see below lines for more options
####PBS -m a #### send mail in case the job is aborted
####PBS -m b #### send mail when job begins
####PBS -m e #### send mail when job ends
######## Job Related Options ########
####PBS -j oe join #### merge stdout and stderr to a single file at -o path
####PBS -W depend=afterok:$JOBID1:$JOBID2 #### only start executation after the completion of the jobs with JOBID1 and JOBID2
####PBS -I interactive job #### start an interactive session
####PBS -terse #### print only job id - use this as pipe output of qsub to a variable in bash to use this job id as prerequisite for another job following this job
######## Job Resources Options ########
####PBS -p priority #### [-1024, 1023]; higher number means faster/higher priority.
#PBS -p -100 #### [-1024, 1023]; higher number means faster/higher priority.
####PBS -l nodes=1:ppn=1:gpus=1,mem=8gb,walltime=15:00:00 #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
#PBS -l nodes=1:ppn=8 #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
#PBS -l mem=128gb #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
#PBS -l walltime=4:00:00 #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests

source activate /scratch/hasm/conda/py3_7_conda_forge_pytorch;
cd /home/hasm/comp_space/Data/Lesion/ATLAS-dataset-generate-h5file;
export HDF5_USE_FILE_LOCKING='FALSE';
python generate_h5.py --dataset-path /scratch/hasm/Data/Lesion/ATLAS_R1.1/;
