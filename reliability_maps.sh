#!/bin/bash
#SBATCH --job-name=cifti_reliability
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=6:00:00
#SBATCH --output=cifti_reliability_%A_%a.log
#SBATCH --error=cifti_reliability_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-13  # 14 subjects

# Define subject list
declare -a subjects=(
  "pfm01"
  "pfm02"
  "pfm03"
  "pfm04"
  "pfm05"
  "pfm06"
  "pfm07"
  "pfm08"
  "pfm09"
  "pfm10"
  "pfm11"
  "pfm12"
  "pfm13"
  "pfm14"
)

subject=${subjects[$SLURM_ARRAY_TASK_ID]}
base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"

# Input functional connectivity dconn files
input_rs_a="$base_path/functional_connectivity/rs/sub-${subject}_ses-a/sub-${subject}_ses-a_rs_smoothed_normalized_FC_clean.dconn.nii"
input_rs_b="$base_path/functional_connectivity/rs/sub-${subject}_ses-b/sub-${subject}_ses-b_rs_smoothed_normalized_FC_clean.dconn.nii"

input_me_a="$base_path/functional_connectivity/me/sub-${subject}_ses-a/sub-${subject}_ses-a_me_smoothed_normalized_FC_clean.dconn.nii"
input_me_b="$base_path/functional_connectivity/me/sub-${subject}_ses-b/sub-${subject}_ses-b_me_smoothed_normalized_FC_clean.dconn.nii"

# Output directories
out_rs="$base_path/reliability_maps/rs/sub-${subject}"
out_me="$base_path/reliability_maps/me/sub-${subject}"
mkdir -p "$out_rs"
mkdir -p "$out_me"

# Output reliability maps
output_rs="${out_rs}/sub-${subject}_rs_reliability.dscalar.nii"
output_me="${out_me}/sub-${subject}_me_reliability.dscalar.nii"

image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

echo "Computing RS reliability for sub-${subject}..."

if [ -f "$input_rs_a" ] && [ -f "$input_rs_b" ]; then
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-pairwise-correlation \
    "$input_rs_a" \
    "$input_rs_b" \
    "$output_rs"
  echo "Finished RS reliability for sub-${subject}"
else
  echo "WARNING: Missing RS dconn files for sub-${subject}, skipping RS."
fi

echo "Computing ME reliability for sub-${subject}..."

if [ -f "$input_me_a" ] && [ -f "$input_me_b" ]; then
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-pairwise-correlation \
    "$input_me_a" \
    "$input_me_b" \
    "$output_me"
  echo "Finished ME reliability for sub-${subject}"
else
  echo "WARNING: Missing ME dconn files for sub-${subject}, skipping ME."
fi

echo "All reliability processing done for sub-${subject}"
