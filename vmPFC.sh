#!/bin/bash
#SBATCH --job-name=frontal_extraction
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=30G
#SBATCH --time=2:00:00
#SBATCH --output=frontal_extraction_%A_%a.log
#SBATCH --error=frontal_extraction_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-13  # 14 subjects

# Define subject list
declare -a subjects=(
  "pfm01" "pfm02" "pfm03" "pfm04" "pfm05" "pfm06" "pfm07" "pfm08" "pfm09" "pfm10" "pfm11" "pfm12" "pfm13" "pfm14"
)

subject=${subjects[$SLURM_ARRAY_TASK_ID]}
base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"

# Input files
input_rs_fisher="$base_path/reliability_maps/rs/sub-${subject}/cortex_combined.dscalar.nii"
input_me_fisher="$base_path/reliability_maps/me/sub-${subject}/cortex_combined.dscalar.nii"

# R2 maps (already exist)
input_rs_r2="$base_path/reliability_maps/rs/sub-${subject}/visualization_files/RS_R2_cortex_only.dscalar.nii"
input_me_r2="$base_path/reliability_maps/me/sub-${subject}/visualization_files/ME_R2_cortex_only.dscalar.nii"

# Create output directories
out_rs_frontal="$base_path/reliability_maps/rs/sub-${subject}/frontal_data"
out_me_frontal="$base_path/reliability_maps/me/sub-${subject}/frontal_data"
mkdir -p "$out_rs_frontal"
mkdir -p "$out_me_frontal"

image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

# frontal mask (should already exist)
frontal_mask="$base_path/masks/frontal_mask_fixed.dscalar.nii"

echo "Processing frontal data for subject: $subject"

if [ ! -f "$frontal_mask" ]; then
  echo "ERROR: frontal mask not found at $frontal_mask"
  echo "Please run create_frontal_mask.sh first!"
  exit 1
fi

#######################
# Process RS data
#######################
if [ -f "$input_rs_fisher" ] && [ -f "$input_rs_r2" ]; then
  echo "Processing RS frontal data for sub-${subject}..."
  
  # Apply frontal mask to R2 data (keep this if you want masked R2 maps)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x * mask" "${out_rs_frontal}/RS_R2_frontal_masked.dscalar.nii" \
    -var x "$input_rs_r2" \
    -var mask "$frontal_mask"
  
  # Calculate mean Fisher Z inside frontal ROI without multiplying by mask
  RS_FRONTAL_FISHER_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "$input_rs_fisher" -reduce MEAN -roi "$frontal_mask")
  
  echo "RS frontal Fisher Z mean: ${RS_FRONTAL_FISHER_MEAN}"
else
  echo "WARNING: RS Fisher Z reliability map not found for sub-${subject}"
fi

#######################
# Process ME data
#######################
if [ -f "$input_me_fisher" ] && [ -f "$input_me_r2" ]; then
  echo "Processing ME frontal data for sub-${subject}..."
  
  # Apply frontal mask to R2 data (keep this if you want masked R2 maps)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x * mask" "${out_me_frontal}/ME_R2_frontal_masked.dscalar.nii" \
    -var x "$input_me_r2" \
    -var mask "$frontal_mask"
  
  # Calculate mean Fisher Z inside frontal ROI without multiplying by mask
  ME_FRONTAL_FISHER_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "$input_me_fisher" -reduce MEAN -roi "$frontal_mask")
  
  echo "ME frontal Fisher Z mean: ${ME_FRONTAL_FISHER_MEAN}"
else
  echo "WARNING: ME Fisher Z reliability map not found for sub-${subject}"
fi