#!/bin/bash
#SBATCH --job-name=cifti_region_averages
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=6:00:00
#SBATCH --output=cifti_region_averages_%A_%a.log
#SBATCH --error=cifti_region_averages_%A_%a.err
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

# Input Fisher Z-transformed reliability maps (assuming these already exist)
input_rs="$base_path/reliability_maps/rs/sub-${subject}/sub-${subject}_rs_fisher_z.dscalar.nii"
input_me="$base_path/reliability_maps/me/sub-${subject}/sub-${subject}_me_fisher_z.dscalar.nii"

# Output directories for ROI files
out_rs="$base_path/reliability_maps/rs/sub-${subject}"
out_me="$base_path/reliability_maps/me/sub-${subject}"

image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

# Process RS reliability map
if [ -f "$input_rs" ]; then
  echo "Processing RS Fisher Z reliability map for sub-${subject}..."

  # Extract cortical data (left and right hemispheres)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs" COLUMN \
    -metric CORTEX_LEFT "${out_rs}/temp_cortex_left.func.gii" \
    -metric CORTEX_RIGHT "${out_rs}/temp_cortex_right.func.gii"

  # Create a combined cortical CIFTI file
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-create-dense-scalar "${out_rs}/cortex_combined.dscalar.nii" \
    -left-metric "${out_rs}/temp_cortex_left.func.gii" \
    -right-metric "${out_rs}/temp_cortex_right.func.gii"

  # Calculate cortex average directly (no ROI needed!)
  RS_CORTEX_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "${out_rs}/cortex_combined.dscalar.nii" -reduce MEAN)

  echo "RS cortex mean Fisher z-transformed r: ${RS_CORTEX_MEAN}"

  # Extract all subcortical volume structures and calculate mean
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs" COLUMN -volume-all "${out_rs}/subcortical_vol.nii.gz"

  # Calculate mean across all subcortical structures
  RS_SUBCORTICAL_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    fslstats "${out_rs}/subcortical_vol.nii.gz" -M)

  echo "RS subcortical mean Fisher z-transformed r: ${RS_SUBCORTICAL_MEAN}"

  # Clean up temporary files
  rm -f "${out_rs}/temp_cortex_left.func.gii" "${out_rs}/temp_cortex_right.func.gii"

else
  echo "WARNING: RS Fisher Z reliability map not found for sub-${subject}"
fi

# Process ME reliability map
if [ -f "$input_me" ]; then
  echo "Processing ME Fisher Z reliability map for sub-${subject}..."

  # Extract cortical data (left and right hemispheres)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me" COLUMN \
    -metric CORTEX_LEFT "${out_me}/temp_cortex_left.func.gii" \
    -metric CORTEX_RIGHT "${out_me}/temp_cortex_right.func.gii"

  # Create a combined cortical CIFTI file
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-create-dense-scalar "${out_me}/cortex_combined.dscalar.nii" \
    -left-metric "${out_me}/temp_cortex_left.func.gii" \
    -right-metric "${out_me}/temp_cortex_right.func.gii"

  # Calculate cortex average directly (no ROI needed!)
  ME_CORTEX_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "${out_me}/cortex_combined.dscalar.nii" -reduce MEAN)

  echo "ME cortex mean Fisher z-transformed r: ${ME_CORTEX_MEAN}"

  # For subcortical structures
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me" COLUMN -volume-all "${out_me}/subcortical_vol.nii.gz"

  # Calculate stats on the volume
  ME_SUBCORTICAL_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    fslstats "${out_me}/subcortical_vol.nii.gz" -M)

  echo "ME subcortical mean Fisher z-transformed r: ${ME_SUBCORTICAL_MEAN}"

  # Clean up temporary files
  rm -f "${out_me}/temp_cortex_left.func.gii" "${out_me}/temp_cortex_right.func.gii"

else
  echo "WARNING: ME Fisher Z reliability map not found for sub-${subject}"
fi

echo "All regional reliability averaging done for sub-${subject}"