#!/bin/bash
#SBATCH --job-name=mgtr_denoise
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=gmtr_denoise_%A_%a.log
#SBATCH --error=gmtr_denoise_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-27  # 14 participants × 2 sessions

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

# Get the current combination from the SLURM array index
combination=(${combinations[$SLURM_ARRAY_TASK_ID]})
subject=${combination[0]}
session=${combination[1]}

base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"

# Input files
me_denoised="$base_path/ica_cleaned/resting_state/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-preprocclean_bold.nii.gz"
gm_probseg="$base_path/fmriprep/sub-${subject}/ses-${session}/anat/sub-${subject}_ses-${session}_run-001_label-GM_probseg.nii.gz"

# Output directory
output_dir="$base_path/completed_preprocessing/singlecho/sub-${subject}/ses-${session}"
mkdir -p "$output_dir"

# Working directory for temporary files
work_dir="$output_dir/temp_mgtr_$$"
mkdir -p "$work_dir"

echo "Processing mean gray matter regression for sub-${subject} ses-${session} ..."

# Check if input files exist
if [[ ! -f "$me_denoised" ]]; then
    echo "Error: ME-denoised file not found: $me_denoised"
    exit 1
fi

if [[ ! -f "$gm_probseg" ]]; then
    echo "Error: Gray matter probability map not found: $gm_probseg"
    exit 1
fi

# Step 1: Resample GM probability map to match BOLD data dimensions
echo "Resampling GM probability map to match BOLD data dimensions..."
apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
flirt -in "$gm_probseg" -ref "$me_denoised" -out "$work_dir/GM_probseg_resampled.nii.gz" -applyxfm -usesqform

# Step 2: Create gray matter mask (20% threshold)
echo "Creating gray matter mask with 20% threshold..."
apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
fslmaths "$work_dir/GM_probseg_resampled.nii.gz" -thr 0.2 -bin "$work_dir/GM_mask.nii.gz"

# Step 3: Extract mean gray matter signal
echo "Extracting mean gray matter signal..."
apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
fslmeants -i "$me_denoised" -m "$work_dir/GM_mask.nii.gz" -o "$work_dir/mean_GM_signal.txt"

# Step 4: Apply mean gray matter regression
echo "Applying mean gray matter regression..."
apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
fsl_regfilt -i "$me_denoised" \
            -d "$work_dir/mean_GM_signal.txt" \
            -o "$output_dir/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-rsdenoisedmgtr_bold.nii.gz" \
            -f "1"

# Optional: Save mean GM signal for QC
echo "Saving mean GM signal for quality control..."
cp "$work_dir/mean_GM_signal.txt" "$output_dir/sub-${subject}_ses-${session}_desc-meanGM_timeseries.txt"

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf "$work_dir"

echo "Mean gray matter regression completed for sub-${subject} ses-${session}"
echo "Output file: $output_dir/sub-${subject}_ses-${session}_space-T1w_desc-medenoisedMGTR_bold.nii.gz"
echo "Mean GM timeseries saved: $output_dir/sub-${subject}_ses-${session}_desc-meanGM_timeseries.txt"