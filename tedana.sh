#!/bin/bash
#SBATCH --job-name=tedana_proc
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=25G
#SBATCH --time=36:00:00
#SBATCH --output=tedana_proc_%A_%a.log
#SBATCH --error=tedana_proc_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-27  # All 28 (14 participants with 2 sessions each)

export PATH=$PATH:/home/dumbr174/.local/bin

# Load necessary modules
module avail fsl
module load apptainer/FSL/6.0.7

# Define all subject/session combinations
declare -a combinations=(
  "pfm01 a"
  "pfm01 b"
  "pfm02 a"
  "pfm02 b"
  "pfm03 a"
  "pfm03 b"
  "pfm04 a"
  "pfm04 b"
  "pfm05 a"
  "pfm05 b"
  "pfm06 a"
  "pfm06 b"
  "pfm07 a"
  "pfm07 b"
  "pfm08 a"
  "pfm08 b"
  "pfm09 a"
  "pfm09 b"
  "pfm10 a"
  "pfm10 b"
  "pfm11 a"
  "pfm11 b"
  "pfm12 a"
  "pfm12 b"
  "pfm13 a"
  "pfm13 b"
  "pfm14 a"
  "pfm14 b"
)

# Get the current combination
combination=(${combinations[$SLURM_ARRAY_TASK_ID]})
subject=${combination[0]}
session=${combination[1]}

base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"

# Define input files
func_data=(
    "$base_path/fmriprep/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_run-001_echo-1_desc-preproc_bold.nii.gz"
    "$base_path/fmriprep/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_run-001_echo-2_desc-preproc_bold.nii.gz"
    "$base_path/fmriprep/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_run-001_echo-3_desc-preproc_bold.nii.gz"
    "$base_path/fmriprep/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_run-001_echo-4_desc-preproc_bold.nii.gz"
    "$base_path/fmriprep/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_run-001_echo-5_desc-preproc_bold.nii.gz"
)

# Extract EchoTime from json files
echo_times=()
for file in "${func_data[@]}"; do
    echo_time=$(/usr/bin/jq -r '.EchoTime' < "${file%.nii.gz}.json")
    echo_times+=("$echo_time")
done

# Define mask and output directory
mask="$base_path/fmriprep/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_run-001_desc-brain_mask.nii.gz"
output_dir="$base_path/tedana/sub-${subject}/ses-${session}"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Run tedana command
echo "Running tedana for sub-${subject} ses-${session}"
tedana -d "${func_data[@]}" -e "${echo_times[@]}" --out-dir "$output_dir" --mask "$mask" --tedpca aic --n-threads 4 --combmode t2s --convention bids

echo "Tedana processing complete for sub-${subject} ses-${session}"
