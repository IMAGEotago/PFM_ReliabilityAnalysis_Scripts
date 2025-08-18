#!/bin/bash
#SBATCH --job-name=cifti_clean_dconn
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=4:00:00
#SBATCH --output=acifti_clean_dconn_%A_%a.log
#SBATCH --error=acifti_clean_dconn_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-27  # 14 subjects × 2 sessions

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
image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

echo "Cleaning dconn files for sub-${subject} ses-${session}..."

# Clean RS dconn file
rs_input="$base_path/functional_connectivity/rs/sub-${subject}_ses-${session}/sub-${subject}_ses-${session}_rs_smoothed_normalized_FC.dconn.nii"
rs_output="$base_path/functional_connectivity/rs/sub-${subject}_ses-${session}/sub-${subject}_ses-${session}_rs_smoothed_normalized_FC_clean.dconn.nii"

if [ -f "$rs_input" ]; then
  echo "  Cleaning RS dconn file..."
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x" "$rs_output" -fixnan 0 -var x "$rs_input"
  
  # Verify cleaning worked
  echo "  Verifying RS cleaning..."
  mean_check=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "$rs_output" -reduce MEAN 2>&1)
  
  if [[ "$mean_check" == *"-nan"* ]]; then
    echo "  WARNING: RS cleaning failed, still contains NaN values"
  else
    echo "  RS cleaning successful"
  fi
else
  echo "  WARNING: RS input file not found: $rs_input"
fi

# Clean ME dconn file
me_input="$base_path/functional_connectivity/me/sub-${subject}_ses-${session}/sub-${subject}_ses-${session}_me_smoothed_normalized_FC.dconn.nii"
me_output="$base_path/functional_connectivity/me/sub-${subject}_ses-${session}/sub-${subject}_ses-${session}_me_smoothed_normalized_FC_clean.dconn.nii"

if [ -f "$me_input" ]; then
  echo "  Cleaning ME dconn file..."
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x" "$me_output" -fixnan 0 -var x "$me_input"
  
  # Verify cleaning worked
  echo "  Verifying ME cleaning..."
  mean_check=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "$me_output" -reduce MEAN 2>&1)
  
  if [[ "$mean_check" == *"-nan"* ]]; then
    echo "  WARNING: ME cleaning failed, still contains NaN values"
  else
    echo "  ME cleaning successful"
  fi
else
  echo "  WARNING: ME input file not found: $me_input"
fi

echo "Cleaning completed for sub-${subject} ses-${session}"