#!/bin/bash
#!/usr/bin/env bash
####
################################## START OF EMBEDDED PBS COMMANDS ##########################
######## Common options ########
#PBS -S /bin/bash  #### Default Shell to be Used
#PBS -N Generate-H5_Sample_Visualization  #### Job Name to be listed in qstat
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
####PBS -p -100 #### [-1024, 1023]; higher number means faster/higher priority.
####PBS -l nodes=1:ppn=1:gpus=1,mem=8gb,walltime=15:00:00 #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
#PBS -l nodes=1:ppn=2 #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
#PBS -l mem=36gb #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
#PBS -l walltime=2:00:00 #### 1 node, 1 processor, 1 gpu, 8GB of memory, 15 hours of wall time requests
################################## END OF EMBEDDED PBS COMMANDS ##########################

SINGLE_SUBJECT_FLAG=1; #0 or 1
git_dir="/scratch/hasm/git/WUSTL_2021A_ESE_5934_XNet_Atlas_Data";
lesion_dir="/scratch/hasm/Data/Lesion";
# data_dir="${lesion_dir}/ATLAS_R1.1/Subset_Symlink";
data_dir="${lesion_dir}/ATLAS_R1.1/Only_Data"
# csv_path="${lesion_dir}/ATLAS_R1.1_Lists/Data_subset.csv";
csv_path="${lesion_dir}/ATLAS_R1.1_Lists/Sample_Visualization_Site_ID_Timepoint.csv";
output_dir="${lesion_dir}/ATLAS_R1.1/Sample_Visualization";
# num_subject=56;
# num_subject=1;

#sanity checks
if [ ! -e "${csv_path}" ];
then
  echo -e "csv_path (${csv_path}) does not exist.";
  exit 1;
fi;

if [ ! -d "${data_dir}" ];
then
  echo -e "data_dir (${data_dir}) does not exist.";
  exit 1;
fi;

if [ ! -d "${output_dir}" ];
then
  echo -e "output_dir (${output_dir}) does not exist.";
  exit 1;
fi;

if [ ! -d "${git_dir}" ];
then
  echo -e "git_dir (${git_dir}) does not exist.";
  exit 1;
fi;

num_subject=`cat /scratch/hasm/Data/Lesion/ATLAS_R1.1_Lists/Sample_Visualization_Site_ID_Timepoint.csv | wc -l`;

#printout variables
echo -e "csv_path: ( ${csv_path} )";
echo -e "num_subject: ( ${num_subject} )";
echo -e "data_dir: ( ${data_dir} )";
echo -e "SINGLE_SUBJECT_FLAG: ( ${SINGLE_SUBJECT_FLAG} )";

echo -e "\n\n \
source activate py3_8_conda_forge_pytorch_tensorflow;";
source activate py3_8_conda_forge_pytorch_tensorflow;

echo -e "\n\n \
cd ${git_dir}";
cd "${git_dir}";

echo -e "\n\n \
export HDF5_USE_FILE_LOCKING='FALSE';";
export HDF5_USE_FILE_LOCKING='FALSE';

if [ "${SINGLE_SUBJECT_FLAG}" == 0 ];
then
  echo -e "\n\n \
  python generate_h5.py \
  --dataset-path \"${data_dir}\" \
  --csv-path \"${csv_path}\" \
  --num_subject ${num_subject} \
  --output-directory \"${output_dir}\";";

  python generate_h5.py \
  --dataset-path "${data_dir}" \
  --csv-path "${csv_path}" \
  --num_subject ${num_subject} \
  --output-directory "${output_dir}";
else
  #generate temp csv
  for i in ((i = 0; i <= ${num_subject}; i++));
  do
    temp_csv_path="${output_dir}/Sample_Visualization_Site_ID_Timepoint_${i}.csv";
    sed -n "${i}p" "${csv_path}" > "${temp_csv_path}";
    site=`sed -n "${i}p" "${csv_path}" | cut -d, -f1`;
    id=`sed -n "${i}p" "${csv_path}" | cut -d, -f2`;
    timepoint=`sed -n "${i}p" "${csv_path}" | cut -d, -f3`;

    echo -e "${i}\t|\t${num_subject} - ${site} | ${id} | ${timepoint} (${temp_csv_path}";
    outdir="${output_dir}/${site}/${id}/${timepoint}";
    mkdiv -pv "${outdir}";

    echo -e "\n\n \
    python generate_h5.py \
    --dataset-path \"${data_dir}\" \
    --csv-path \"${temp_csv_path}\" \
    --num_subject 1 \
    --output-directory \"${outdir}\";";

    python generate_h5.py \
    --dataset-path "${data_dir}" \
    --csv-path "${temp_csv_path}" \
    --num_subject 1 \
    --output-directory "${outdir}";

    echo -e "\n\n \
    rm \"${temp_csv_path}\";";
    rm "${temp_csv_path}";
  done;
fi;