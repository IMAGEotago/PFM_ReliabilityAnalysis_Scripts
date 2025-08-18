#!/bin/bash
#SBATCH --job-name=melodic_ICA_rs_proc
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=36:00:00
#SBATCH --output=melodic_ICA_rs_proc_%A_%a.log
#SBATCH --error=melodic_ICA_rs_proc_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-27  # All 28 (14 participants with 2 sessions each)

# Load necessary modules
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
melodic_rs="$base_path/fmriprep/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_run-002_space-T1w_desc-preproc_bold.nii.gz"

# Output file
output_dir="$base_path/rs_melodic/sub-${subject}/ses-${session}"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Run the melodic command through the fMRIPrep container
echo "Running melodic for sub-${subject} ses-${session}"

apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    melodic -i "$melodic_rs" -o "$output_dir" -v --tr=0.735 --report
    
echo "Melodic completed for sub-${subject} ses-${session}"