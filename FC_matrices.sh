#!/bin/bash
#SBATCH --job-name=cifti_correlation
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=128G
#SBATCH --time=12:00:00
#SBATCH --output=cifti_correlation_%A_%a.log
#SBATCH --error=cifti_correlation_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-27  # 14 participants × 2 sessions

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

combination=(${combinations[$SLURM_ARRAY_TASK_ID]})
subject=${combination[0]}
session=${combination[1]}

base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"

# Input normalized CIFTI dtseries
input_rs="$base_path/ciftify_rs/sub-${subject}_ses-${session}/MNINonLinear/Results/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-rsdenoisedmgtr_bold/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-rsdenoisedmgtr_bold_Atlas_s0_smoothed_normalized.dtseries.nii"
input_me="$base_path/ciftify_me/sub-${subject}_ses-${session}/MNINonLinear/Results/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-medenoisedmgtr_bold/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-medenoisedmgtr_bold_Atlas_s0_smoothed_normalized.dtseries.nii"

# New output base directories
out_base="$base_path/functional_connectivity"

out_rs="$out_base/rs/sub-${subject}_ses-${session}"
out_me="$out_base/me/sub-${subject}_ses-${session}"

# Make output directories if they don't exist
mkdir -p "$out_rs"
mkdir -p "$out_me"

# Output FC matrices
output_rs="${out_rs}/sub-${subject}_ses-${session}_rs_smoothed_normalized_FC.dconn.nii"
output_me="${out_me}/sub-${subject}_ses-${session}_me_smoothed_normalized_FC.dconn.nii"

echo "Computing FC matrix for sub-${subject} ses-${session} resting-state..."

if [ -f "$input_rs" ]; then
  singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    wb_command -cifti-correlation \
    "$input_rs" \
    "$output_rs"

  echo "Finished resting-state FC for sub-${subject} ses-${session}"
else
  echo "WARNING: Resting-state normalized CIFTI not found for sub-${subject} ses-${session}, skipping."
fi

echo "Computing FC matrix for sub-${subject} ses-${session} multi-echo..."

if [ -f "$input_me" ]; then
  singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    wb_command -cifti-correlation \
    "$input_me" \
    "$output_me"

  echo "Finished multi-echo FC for sub-${subject} ses-${session}"
else
  echo "WARNING: Multi-echo normalized CIFTI not found for sub-${subject} ses-${session}, skipping."
fi

echo "All FC processing done for sub-${subject} ses-${session}"
