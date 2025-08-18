#!/bin/bash
#SBATCH --job-name=remove_components_rs_proc
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=36:00:00
#SBATCH --output=remove_components_rs_proc_%A_%a.log
#SBATCH --error=remove_components_rs_proc_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0  # Just one job for now

# Load necessary modules
module load apptainer/FSL/6.0.7

base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"

# Fill in components for each subject and session


# PFM01-a

# Define input files
melodic_pfm01_a="$base_path/rs_melodic/sub-pfm01/ses-a"
smoothed_pfm01_a="$base_path/fmriprep/sub-pfm01/ses-a/func/sub-pfm01_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm01_a="$base_path/ica_cleaned/resting_state/sub-pfm01/ses-a"
output_file_pfm01_a="$output_dir_pfm01_a/sub-pfm01_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm01_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm01_a} \
                -o ${output_file_pfm01_a} \
                -d ${melodic_pfm01_a}/melodic_mix \
                -f "1,2,3,4,5,7,10,11,12,13,15,18,22,23,25,26,29,31,32,35,38,40,44,47,48,53,56,57,59,64,65,66,69,72,74,75,76,78,79,80,82,83,84,85,86,87,88,89,90"

echo "ICA cleaning completed successfully"

# PFM01-b

# Define input files
melodic_pfm01_b="$base_path/rs_melodic/sub-pfm01/ses-b"
smoothed_pfm01_b="$base_path/fmriprep/sub-pfm01/ses-b/func/sub-pfm01_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm01_b="$base_path/ica_cleaned/resting_state/sub-pfm01/ses-b"
output_file_pfm01_b="$output_dir_pfm01_b/sub-pfm01_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm01_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm01_b} \
                -o ${output_file_pfm01_b} \
                -d ${melodic_pfm01_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,13,14,15,18,21,25,29,30,31,33,37,39,41,44,45,48,49,50,51,53,54,55,60,64,65,66,69,71,73"

echo "ICA cleaning completed successfully"

# PFM02-a

# Define input files
melodic_pfm02_a="$base_path/rs_melodic/sub-pfm02/ses-a"
smoothed_pfm02_a="$base_path/fmriprep/sub-pfm02/ses-a/func/sub-pfm02_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm02_a="$base_path/ica_cleaned/resting_state/sub-pfm02/ses-a"
output_file_pfm02_a="$output_dir_pfm02_a/sub-pfm02_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm02_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm02_a} \
                -o ${output_file_pfm02_a} \
                -d ${melodic_pfm02_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,25,26,28,30,31,35,37,38,39,40,41,42,43,48,49,50,51,52,55,57,58,59,60,62,63,64,66,69,70,71,73,74,76,78,79,80,81,82"

echo "ICA cleaning completed successfully"

# PFM02-b

# Define input files
melodic_pfm02_b="$base_path/rs_melodic/sub-pfm02/ses-b"
smoothed_pfm02_b="$base_path/fmriprep/sub-pfm02/ses-b/func/sub-pfm02_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm02_b="$base_path/ica_cleaned/resting_state/sub-pfm02/ses-b"
output_file_pfm02_b="$output_dir_pfm02_b/sub-pfm02_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm02_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm02_b} \
                -o ${output_file_pfm02_b} \
                -d ${melodic_pfm02_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,10,11,12,14,16,17,18,19,21,22,23,24,27,28,31,33,36,38,42,43,45,47,48,50,51,52,53,54,55,59,62,63,65,66,67,68,70,71,72,73"

echo "ICA cleaning completed successfully"

# PFM03-a

# Define input files
melodic_pfm03_a="$base_path/rs_melodic/sub-pfm03/ses-a"
smoothed_pfm03_a="$base_path/fmriprep/sub-pfm03/ses-a/func/sub-pfm03_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm03_a="$base_path/ica_cleaned/resting_state/sub-pfm03/ses-a"
output_file_pfm03_a="$output_dir_pfm03_a/sub-pfm03_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm03_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm03_a} \
                -o ${output_file_pfm03_a} \
                -d ${melodic_pfm03_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,11,12,13,15,17,19,21,22,25,26,27,28,31,33,34,36,37,38,39,40,42,43,46,49,51,52,54,55,57,58,59,61,62"
                
echo "ICA cleaning completed successfully"

# PFM03-b

# Define input files
melodic_pfm03_b="$base_path/rs_melodic/sub-pfm03/ses-b"
smoothed_pfm03_b="$base_path/fmriprep/sub-pfm03/ses-b/func/sub-pfm03_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm03_b="$base_path/ica_cleaned/resting_state/sub-pfm03/ses-b"
output_file_pfm03_b="$output_dir_pfm03_b/sub-pfm03_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm03_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm03_b} \
                -o ${output_file_pfm03_b} \
                -d ${melodic_pfm03_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,15,17,19,20,23,25,28,29,31,34,35,37,38,39,40,41,42,46,50,52,55,56,57,58,60,61,62,63,64,65,66,67,68,70,71,72,73"

echo "ICA cleaning completed successfully"

# PFM04-a

# Define input files
melodic_pfm04_a="$base_path/rs_melodic/sub-pfm04/ses-a"
smoothed_pfm04_a="$base_path/fmriprep/sub-pfm04/ses-a/func/sub-pfm04_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm04_a="$base_path/ica_cleaned/resting_state/sub-pfm04/ses-a"
output_file_pfm04_a="$output_dir_pfm04_a/sub-pfm04_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm04_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm04_a} \
                -o ${output_file_pfm04_a} \
                -d ${melodic_pfm04_a}/melodic_mix \
                -f "1,2,3,4,5,8,9,11,13,18,20,21,23,24,25,26,27,28,31,33,34,35,40,41,42,43,44,48,49,50,51,52,53,54,55,56,58"

echo "ICA cleaning completed successfully"

# PFM04-b

# Define input files
melodic_pfm04_b="$base_path/rs_melodic/sub-pfm04/ses-b"
smoothed_pfm04_b="$base_path/fmriprep/sub-pfm04/ses-b/func/sub-pfm04_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm04_b="$base_path/ica_cleaned/resting_state/sub-pfm04/ses-b"
output_file_pfm04_b="$output_dir_pfm04_b/sub-pfm04_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm04_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm04_b} \
                -o ${output_file_pfm04_b} \
                -d ${melodic_pfm04_b}/melodic_mix \
                -f "1,2,3,4,6,8,9,10,11,13,15,19,20,21,24,25,26,27,28,29,30,32,33,34,35,38,41,42,44,46,48,49,50,52,55,56,57,59,60,61,62,63,64"

echo "ICA cleaning completed successfully"

# PFM05-a

# Define input files
melodic_pfm05_a="$base_path/rs_melodic/sub-pfm05/ses-a"
smoothed_pfm05_a="$base_path/fmriprep/sub-pfm05/ses-a/func/sub-pfm05_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm05_a="$base_path/ica_cleaned/resting_state/sub-pfm05/ses-a"
output_file_pfm05_a="$output_dir_pfm05_a/sub-pfm05_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm05_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm05_a} \
                -o ${output_file_pfm05_a} \
                -d ${melodic_pfm05_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,13,14,17,18,22,23,24,25,26,28,29,32,33,34,35,36,40,41,42,43,46,47,48,49,50,51,52,53,54,56,57,59,61,62,63,65,66,67,69,71,73,74,75,76,78,80"

echo "ICA cleaning completed successfully"

# PFM05-b

# Define input files
melodic_pfm05_b="$base_path/rs_melodic/sub-pfm05/ses-b"
smoothed_pfm05_b="$base_path/fmriprep/sub-pfm05/ses-b/func/sub-pfm05_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm05_b="$base_path/ica_cleaned/resting_state/sub-pfm05/ses-b"
output_file_pfm05_b="$output_dir_pfm05_b/sub-pfm05_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm05_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm05_b} \
                -o ${output_file_pfm05_b} \
                -d ${melodic_pfm05_b}/melodic_mix \
                -f "1,2,3,6,7,8,9,11,12,15,18,19,24,25,28,30,31,32,33,36,37,40,41,44,49,50,51,52,53,55,56,57,59,60,61,62,63,64"

echo "ICA cleaning completed successfully"

# PFM06-a

# Define input files
melodic_pfm06_a="$base_path/rs_melodic/sub-pfm06/ses-a"
smoothed_pfm06_a="$base_path/fmriprep/sub-pfm06/ses-a/func/sub-pfm06_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm06_a="$base_path/ica_cleaned/resting_state/sub-pfm06/ses-a"
output_file_pfm06_a="$output_dir_pfm06_a/sub-pfm06_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm06_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm06_a} \
                -o ${output_file_pfm06_a} \
                -d ${melodic_pfm06_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,14,16,17,18,19,20,23,27,28,29,31,33,35,36,37,38,39,40,42,45,49,50,55,63,64,66,68,69,70,72,75,76,77,78,79,81,82"

echo "ICA cleaning completed successfully"

# PFM06-b

# Define input files
melodic_pfm06_b="$base_path/rs_melodic/sub-pfm06/ses-b"
smoothed_pfm06_b="$base_path/fmriprep/sub-pfm06/ses-b/func/sub-pfm06_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm06_b="$base_path/ica_cleaned/resting_state/sub-pfm06/ses-b"
output_file_pfm06_b="$output_dir_pfm06_b/sub-pfm06_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm06_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm06_b} \
                -o ${output_file_pfm06_b} \
                -d ${melodic_pfm06_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,21,22,23,24,26,27,29,30,31,34,35,36,37,39,41,42,44,45,46,49,50,51,53,59,60,61,62,63,66,67,69,71,72,74,75,77,83,85,88,91,92,94,97,99,100,101,103,104,105,106,107"

echo "ICA cleaning completed successfully"

# PFM07-a

# Define input files
melodic_pfm07_a="$base_path/rs_melodic/sub-pfm07/ses-a"
smoothed_pfm07_a="$base_path/fmriprep/sub-pfm07/ses-a/func/sub-pfm07_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm07_a="$base_path/ica_cleaned/resting_state/sub-pfm07/ses-a"
output_file_pfm07_a="$output_dir_pfm07_a/sub-pfm07_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm07_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm07_a} \
                -o ${output_file_pfm07_a} \
                -d ${melodic_pfm07_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,12,13,14,15,16,18,19,20,21,22,23,24,25,27,28,30,35,36,37,39,40,41,42,43,44,46,48,49,50,52,53,54,56,57,58,59,60,62,64,65,67,68,69,70,71,72,73,74,75,76,78,79,81,82,83,85,86,87,89,90,91,92,93,94,97,98,99,100,101,102,103,104,105"

echo "ICA cleaning completed successfully"

# PFM07-b

# Define input files
melodic_pfm07_b="$base_path/rs_melodic/sub-pfm07/ses-b"
smoothed_pfm07_b="$base_path/fmriprep/sub-pfm07/ses-b/func/sub-pfm07_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm07_b="$base_path/ica_cleaned/resting_state/sub-pfm07/ses-b"
output_file_pfm07_b="$output_dir_pfm07_b/sub-pfm07_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm07_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm07_b} \
                -o ${output_file_pfm07_b} \
                -d ${melodic_pfm07_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,22,23,24,25,28,29,30,31,33,35,36,37,39,42,44,46,48,49,50,52,53,54,56,58,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,77,78,80,81,82,83,84,85,86,87,88,89,90,91,92,93"

echo "ICA cleaning completed successfully"

# PFM08-a

# Define input files
melodic_pfm08_a="$base_path/rs_melodic/sub-pfm08/ses-a"
smoothed_pfm08_a="$base_path/fmriprep/sub-pfm08/ses-a/func/sub-pfm08_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm08_a="$base_path/ica_cleaned/resting_state/sub-pfm08/ses-a"
output_file_pfm08_a="$output_dir_pfm08_a/sub-pfm08_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm08_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm08_a} \
                -o ${output_file_pfm08_a} \
                -d ${melodic_pfm08_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,21,23,24,26,27,28,29,32,33,34,35,37,42,44,47,50,51,52,56,57,61,62,63,64,67,68,69,70,71,72,74,75,76,77,78,79,80,81,82,83,84,85,86,87,89,90,91,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108"

echo "ICA cleaning completed successfully"

# PFM08-b

# Define input files
melodic_pfm08_b="$base_path/rs_melodic/sub-pfm08/ses-b"
smoothed_pfm08_b="$base_path/fmriprep/sub-pfm08/ses-b/func/sub-pfm08_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm08_b="$base_path/ica_cleaned/resting_state/sub-pfm08/ses-b"
output_file_pfm08_b="$output_dir_pfm08_b/sub-pfm08_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm08_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm08_b} \
                -o ${output_file_pfm08_b} \
                -d ${melodic_pfm08_b}/melodic_mix \
                -f "1,2,3,4,6,7,8,10,11,12,13,15,16,21,22,23,25,27,29,30,31,33,34,35,38,41,44,45,46,47,48,49,51,52,53,55,56,57,58,60,62,63,65,66,68,69,70,72,73,75,76,77,79,80,81"

echo "ICA cleaning completed successfully"

# PFM09-a

# Define input files
melodic_pfm09_a="$base_path/rs_melodic/sub-pfm09/ses-a"
smoothed_pfm09_a="$base_path/fmriprep/sub-pfm09/ses-a/func/sub-pfm09_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm09_a="$base_path/ica_cleaned/resting_state/sub-pfm09/ses-a"
output_file_pfm09_a="$output_dir_pfm09_a/sub-pfm09_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm09_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm09_a} \
                -o ${output_file_pfm09_a} \
                -d ${melodic_pfm09_a}/melodic_mix \
                -f "1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,28,29,30,31,33,34,35,37,38,39,40,42,43,44,45,46,52,54,55,58,59,60,62,64,66,67,70,71,73,74,75,76,78,80,81,82,83,84,85"

echo "ICA cleaning completed successfully"

# PFM09-b

# Define input files
melodic_pfm09_b="$base_path/rs_melodic/sub-pfm09/ses-b"
smoothed_pfm09_b="$base_path/fmriprep/sub-pfm09/ses-b/func/sub-pfm09_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm09_b="$base_path/ica_cleaned/resting_state/sub-pfm09/ses-b"
output_file_pfm09_b="$output_dir_pfm09_b/sub-pfm09_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm09_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm09_b} \
                -o ${output_file_pfm09_b} \
                -d ${melodic_pfm09_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,13,14,15,16,18,19,20,21,22,23,24,26,27,28,31,32,33,35,40,42,49,52,54,55,56,58,59,60,63,65,67,68,70,71,72,75,76,77,78,79"

echo "ICA cleaning completed successfully"

# PFM10-a

# Define input files
melodic_pfm10_a="$base_path/rs_melodic/sub-pfm10/ses-a"
smoothed_pfm10_a="$base_path/fmriprep/sub-pfm10/ses-a/func/sub-pfm10_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm10_a="$base_path/ica_cleaned/resting_state/sub-pfm10/ses-a"
output_file_pfm10_a="$output_dir_pfm10_a/sub-pfm10_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm10_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm10_a} \
                -o ${output_file_pfm10_a} \
                -d ${melodic_pfm10_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,22,24,25,27,30,32,33,36,40,42,43,44,47,48,49,50,52,53,54,55,61,62,63,64,65,66,67,68,69,70,71,72,73,74"

echo "ICA cleaning completed successfully"

# PFM10-b

# Define input files
melodic_pfm10_b="$base_path/rs_melodic/sub-pfm10/ses-b"
smoothed_pfm10_b="$base_path/fmriprep/sub-pfm10/ses-b/func/sub-pfm10_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm10_b="$base_path/ica_cleaned/resting_state/sub-pfm10/ses-b"
output_file_pfm10_b="$output_dir_pfm10_b/sub-pfm10_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm10_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm10_b} \
                -o ${output_file_pfm10_b} \
                -d ${melodic_pfm10_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,13,15,16,18,19,20,22,23,24,25,28,33,34,35,39,44,46,47,48,49,51,52,54,55,57,59,60,61,62,63,64,66,67,68,69"

echo "ICA cleaning completed successfully"

# PFM11-a

# Define input files
melodic_pfm11_a="$base_path/rs_melodic/sub-pfm11/ses-a"
smoothed_pfm11_a="$base_path/fmriprep/sub-pfm11/ses-a/func/sub-pfm11_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm11_a="$base_path/ica_cleaned/resting_state/sub-pfm11/ses-a"
output_file_pfm11_a="$output_dir_pfm11_a/sub-pfm11_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm11_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm11_a} \
                -o ${output_file_pfm11_a} \
                -d ${melodic_pfm11_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,21,24,25,26,29,30,31,32,34,37,41,42,43,44,45,46,47,48,49,50,51,52,54,63,64,66,67,68,69,71,72,73,74,75,76,80"

echo "ICA cleaning completed successfully"

# PFM11-b

# Define input files
melodic_pfm11_b="$base_path/rs_melodic/sub-pfm11/ses-b"
smoothed_pfm11_b="$base_path/fmriprep/sub-pfm11/ses-b/func/sub-pfm11_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm11_b="$base_path/ica_cleaned/resting_state/sub-pfm11/ses-b"
output_file_pfm11_b="$output_dir_pfm11_b/sub-pfm11_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm11_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm11_b} \
                -o ${output_file_pfm11_b} \
                -d ${melodic_pfm11_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,21,22,24,25,26,27,31,35,36,40,41,42,44,46,48,49,51,52,54,55,57,58,59,60,63,66,67,68,69,71,73,74,75,76,77"

echo "ICA cleaning completed successfully"

# PFM12-a

# Define input files
melodic_pfm12_a="$base_path/rs_melodic/sub-pfm12/ses-a"
smoothed_pfm12_a="$base_path/fmriprep/sub-pfm12/ses-a/func/sub-pfm12_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm12_a="$base_path/ica_cleaned/resting_state/sub-pfm12/ses-a"
output_file_pfm12_a="$output_dir_pfm12_a/sub-pfm12_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm12_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm12_a} \
                -o ${output_file_pfm12_a} \
                -d ${melodic_pfm12_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,14,16,17,20,24,25,27,28,30,32,34,35,36,37,39,42,43,44,45,46,47,48,49,50,52,53,54,55,56,59,60,61,62,64,65,66,67,68,69,70,71"

echo "ICA cleaning completed successfully"

# PFM12-b

# Define input files
melodic_pfm12_b="$base_path/rs_melodic/sub-pfm12/ses-b"
smoothed_pfm12_b="$base_path/fmriprep/sub-pfm12/ses-b/func/sub-pfm12_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm12_b="$base_path/ica_cleaned/resting_state/sub-pfm12/ses-b"
output_file_pfm12_b="$output_dir_pfm12_b/sub-pfm12_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm12_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm12_b} \
                -o ${output_file_pfm12_b} \
                -d ${melodic_pfm12_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,12,13,15,17,18,19,21,23,25,26,28,30,32,33,34,38,39,40,42,45,47,49,51,52,53,54,55,56,57,58,59,60,62,63,64,65,66,69,71,72,74,75,76,77,78"

echo "ICA cleaning completed successfully"


# PFM13-a

# Define input files
melodic_pfm13_a="$base_path/rs_melodic/sub-pfm13/ses-a"
smoothed_pfm13_a="$base_path/fmriprep/sub-pfm13/ses-a/func/sub-pfm13_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm13_a="$base_path/ica_cleaned/resting_state/sub-pfm13/ses-a"
output_file_pfm13_a="$output_dir_pfm13_a/sub-pfm13_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm13_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm13_a} \
                -o ${output_file_pfm13_a} \
                -d ${melodic_pfm13_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,14,15,16,17,18,19,20,21,22,23,24,26,27,29,30,32,33,35,37,38,39,40,41,46,47,48,50,51,53,54,57,58,59,60,62,63,64,65,66,68,72,74,75,76,77"

echo "ICA cleaning completed successfully"

# PFM13-b

# Define input files
melodic_pfm13_b="$base_path/rs_melodic/sub-pfm13/ses-b"
smoothed_pfm13_b="$base_path/fmriprep/sub-pfm13/ses-b/func/sub-pfm13_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm13_b="$base_path/ica_cleaned/resting_state/sub-pfm13/ses-b"
output_file_pfm13_b="$output_dir_pfm13_b/sub-pfm13_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm13_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm13_b} \
                -o ${output_file_pfm13_b} \
                -d ${melodic_pfm13_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,14,15,16,18,19,20,21,24,25,26,27,29,32,33,35,36,41,44,48,50,52,54,55,60,61,62,64,67"

echo "ICA cleaning completed successfully"

# PFM14-a

# Define input files
melodic_pfm14_a="$base_path/rs_melodic/sub-pfm14/ses-a"
smoothed_pfm14_a="$base_path/fmriprep/sub-pfm14/ses-a/func/sub-pfm14_ses-a_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm14_a="$base_path/ica_cleaned/resting_state/sub-pfm14/ses-a"
output_file_pfm14_a="$output_dir_pfm14_a/sub-pfm14_ses-a_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm14_a"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm14_a} \
                -o ${output_file_pfm14_a} \
                -d ${melodic_pfm14_a}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,18,19,21,22,23,25,27,28,29,33,34,35,36,38,41,43,46,47,49,50,53,54,56,57,58,59,61,62,63,65,67,68,70,71,72,73,74,75,76,77,78,80,81,82,83,84,85,86"

echo "ICA cleaning completed successfully"

# PFM14-b

# Define input files
melodic_pfm14_b="$base_path/rs_melodic/sub-pfm14/ses-b"
smoothed_pfm14_b="$base_path/fmriprep/sub-pfm14/ses-b/func/sub-pfm14_ses-b_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir_pfm14_b="$base_path/ica_cleaned/resting_state/sub-pfm14/ses-b"
output_file_pfm14_b="$output_dir_pfm14_b/sub-pfm14_ses-b_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"

# Create output directory if it doesn't exist
mkdir -p "$output_dir_pfm14_b"

# Run fsl_regfilt command
echo "Running ICA-based noise removal with fsl_regfilt"
/usr/bin/apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_regfilt -i ${smoothed_pfm14_b} \
                -o ${output_file_pfm14_b} \
                -d ${melodic_pfm14_b}/melodic_mix \
                -f "1,2,3,4,5,6,7,8,9,11,12,13,14,15,17,18,20,21,22,23,24,26,28,30,32,33,41,44,45,49,51,53,54,55,57,59,61,62,63,64,65,67,68,70,73,75,79,80,82,83,84,85,86,87,88,89,90,92,93,94"

echo "ICA cleaning completed successfully"