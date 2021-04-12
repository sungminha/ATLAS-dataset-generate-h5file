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
#PBS -o /scratch/hasm/Data/Lesion/X-net_Test/logs/\${PBS_JOBNAME}_\${PBS_JOBID}.stdout  #### stdout default path
#PBS -e /scratch/hasm/Data/Lesion/X-net_Test/logs/\${PBS_JOBNAME}_\${PBS_JOBID}.stderr  #### stderr default path
######## Email Options ########
#PBS -M sungminha@wustl.edu  #### email address to nofity with following options/scenarios
#PBS -m ae ####abort, end notifications - see below lines for more options
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
#PBS -l nodes=1:ppn=4 #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
#PBS -l mem=48gb #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
#PBS -l walltime=2:00:00 #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
################################## END OF EMBEDDED PBS COMMANDS ##########################

data_dir="/scratch/hasm/Data/Lesion/ATLAS_R1.1/Subset_Symlink";
csv_path="/scratch/hasm/Data/Lesion/ATLAS_R1.1_Lists/Data_subset.csv";
num_subject=56;
echo -e "\n\n \
source activate py3_8_conda_forge_pytorch_tensorflow;";
source activate py3_8_conda_forge_pytorch_tensorflow;

echo -e "\n\n \
cd /scratch/hasm/Data/Lesion/X-net_Test/ATLAS-dataset-generate-h5file";
cd /scratch/hasm/Data/Lesion/X-net_Test/ATLAS-dataset-generate-h5file;

echo -e "\n\n \
export HDF5_USE_FILE_LOCKING='FALSE';";
export HDF5_USE_FILE_LOCKING='FALSE';

echo -e "\n\n \
python generate_h5.py --dataset-path \"${data_dir}\" --csv-path \"${csv_path}\" --num_subject ${num_subject}";
python generate_h5.py --dataset-path "${data_dir}" --csv-path "${csv_path}" --num_subject ${num_subject};