#!/bin/bash
#SBATCH --job-name=mean_exclude_zero
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --time=01:00:00
#SBATCH --output=mean_exclude_zero_%A_%a.log
#SBATCH --error=mean_exclude_zero_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-13  # 14 subjects

declare -a subjects=(
  "pfm01" "pfm02" "pfm03" "pfm04" "pfm05" "pfm06" "pfm07"
  "pfm08" "pfm09" "pfm10" "pfm11" "pfm12" "pfm13" "pfm14"
)

# This shell script is important for the removal of zeros from cortical data when calculating the mean. I decided to include this for the sake of consistency, and because the cortex_combined data appeared to be impacted by zero values. The addition of this step is your choice to make based on your own data.


subject=${subjects[$SLURM_ARRAY_TASK_ID]}

base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"
image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

input_rs="$base_path/reliability_maps/rs/sub-${subject}/sub-${subject}_rs_fisher_z.dscalar.nii"
mask_rs="$base_path/reliability_maps/rs/sub-${subject}/sub-${subject}_rs_nonzero_mask.dscalar.nii"

input_me="$base_path/reliability_maps/me/sub-${subject}/sub-${subject}_me_fisher_z.dscalar.nii"
mask_me="$base_path/reliability_maps/me/sub-${subject}/sub-${subject}_me_nonzero_mask.dscalar.nii"

# Create mask for RS (1 where != 0, 0 where == 0)
if [ -f "$input_rs" ]; then
  echo "Creating nonzero mask for RS sub-${subject}..."
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x != 0" "$mask_rs" -var x "$input_rs"
  
  # Calculate mean only over nonzero voxels using the mask as ROI
  RS_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "$input_rs" -reduce MEAN -roi "$mask_rs")
  
  echo "RS whole brain mean excluding zeros: $RS_MEAN"
else
  echo "WARNING: RS input file not found for sub-${subject}"
fi

# Create mask for ME (1 where != 0, 0 where == 0)
if [ -f "$input_me" ]; then
  echo "Creating nonzero mask for ME sub-${subject}..."
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x != 0" "$mask_me" -var x "$input_me"
  
  # Calculate mean only over nonzero voxels using the mask as ROI
  ME_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "$input_me" -reduce MEAN -roi "$mask_me")
  
  echo "ME whole brain mean excluding zeros: $ME_MEAN"
else
  echo "WARNING: ME input file not found for sub-${subject}"
fi

echo "Finished zero-excluded mean calculation for sub-${subject}"

input_rs_cortex="$base_path/reliability_maps/rs/sub-${subject}/cortex_combined.dscalar.nii"
mask_rs_cortex="$base_path/reliability_maps/rs/sub-${subject}/cortex_nonzero_mask.dscalar.nii"

input_me_cortex="$base_path/reliability_maps/me/sub-${subject}/cortex_combined.dscalar.nii"
mask_me_cortex="$base_path/reliability_maps/me/sub-${subject}/cortex_nonzero_mask.dscalar.nii"

# RS cortex mean excluding zeros
if [ -f "$input_rs_cortex" ]; then
  echo "Creating nonzero mask for RS cortex sub-${subject}..."
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x != 0" "$mask_rs_cortex" -var x "$input_rs_cortex"

  RS_CORTEX_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "$input_rs_cortex" -reduce MEAN -roi "$mask_rs_cortex")

  echo "RS cortex mean excluding zeros: $RS_CORTEX_MEAN"
else
  echo "WARNING: RS cortex input file not found for sub-${subject}"
fi

# ME cortex mean excluding zeros
if [ -f "$input_me_cortex" ]; then
  echo "Creating nonzero mask for ME cortex sub-${subject}..."
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x != 0" "$mask_me_cortex" -var x "$input_me_cortex"

  ME_CORTEX_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "$input_me_cortex" -reduce MEAN -roi "$mask_me_cortex")

  echo "ME cortex mean excluding zeros: $ME_CORTEX_MEAN"
else
  echo "WARNING: ME cortex input file not found for sub-${subject}"
fi

echo "Finished zero-excluded cortex mean calculation for sub-${subject}"


frontal_mask="$base_path/masks/frontal_mask_fixed.dscalar.nii"

combined_mask_rs_frontal="$base_path/reliability_maps/rs/sub-${subject}/frontal_nonzero_mask.dscalar.nii"
combined_mask_me_frontal="$base_path/reliability_maps/me/sub-${subject}/frontal_nonzero_mask.dscalar.nii"

if [ ! -f "$frontal_mask" ]; then
  echo "WARNING: frontal mask not found at $frontal_mask"
else

  # RS frontal nonzero mask
  if [ -f "$input_rs_cortex" ]; then
    echo "Creating combined frontal + nonzero mask for RS frontal cortex sub-${subject}..."
    
    singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
      wb_command -cifti-math "x != 0" "$base_path/reliability_maps/rs/sub-${subject}/nonzero_mask.dscalar.nii" -var x "$input_rs_cortex"

    singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
      wb_command -cifti-math "mask1 * mask2" "$combined_mask_rs_frontal" \
      -var mask1 "$frontal_mask" \
      -var mask2 "$base_path/reliability_maps/rs/sub-${subject}/nonzero_mask.dscalar.nii"

    RS_FRONTAL_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
      wb_command -cifti-stats "$input_rs_cortex" -reduce MEAN -roi "$combined_mask_rs_frontal")

    echo "RS frontal cortex mean excluding zeros: $RS_FRONTAL_MEAN"
  else
    echo "WARNING: RS cortex input file not found for sub-${subject}"
  fi

  # ME frontal nonzero mask
  if [ -f "$input_me_cortex" ]; then
    echo "Creating combined frontal + nonzero mask for ME frontal cortex sub-${subject}..."
    
    singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
      wb_command -cifti-math "x != 0" "$base_path/reliability_maps/me/sub-${subject}/nonzero_mask.dscalar.nii" -var x "$input_me_cortex"

    singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
      wb_command -cifti-math "mask1 * mask2" "$combined_mask_me_frontal" \
      -var mask1 "$frontal_mask" \
      -var mask2 "$base_path/reliability_maps/me/sub-${subject}/nonzero_mask.dscalar.nii"

    ME_FRONTAL_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
      wb_command -cifti-stats "$input_me_cortex" -reduce MEAN -roi "$combined_mask_me_frontal")

    echo "ME frontal cortex mean excluding zeros: $ME_FRONTAL_MEAN"
  else
    echo "WARNING: ME cortex input file not found for sub-${subject}"
  fi

fi

echo "Finished zero-excluded frontal cortex mean calculation for sub-${subject}"


