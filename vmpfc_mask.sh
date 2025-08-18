#!/bin/bash
#SBATCH --job-name=create_frontal_mask
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=0:30:00
#SBATCH --output=create_frontal_mask_%j.log
#SBATCH --error=create_frontal_mask_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz

base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"
image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

# Atlas and mask paths
atlas_path="$base_path/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors.32k_fs_LR.dlabel.nii"
mask_dir="$base_path/masks"
frontal_mask="$mask_dir/frontal_mask.dscalar.nii"

echo "Creating frontal mask from Glasser atlas..."
mkdir -p "$mask_dir"

# Create individual ROI masks and combine them
temp_dir="${mask_dir}/temp_mask_creation"
mkdir -p "$temp_dir"

# Define frontal parcel keys (10v, 10r, 10d, 9m, 25, s32, a24, p24, p32, d32 - bilateral)
frontal_keys=(88 65 72 69 164 165 61 180 64 62 268 245 252 249 344 345 241 360 244 242)

# Create individual masks
roi_files=()
for key in "${frontal_keys[@]}"; do
  roi_file="${temp_dir}/roi_${key}.dscalar.nii"
  echo "Creating ROI for key $key..."
  
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-label-to-roi "$atlas_path" "$roi_file" -key "$key"
  
  if [ $? -eq 0 ]; then
    roi_files+=("$roi_file")
  else
    echo "Warning: Failed to create ROI for key $key"
  fi
done

# Combine all ROI masks using cifti-math
if [ ${#roi_files[@]} -gt 0 ]; then
  echo "Combining ${#roi_files[@]} ROI masks..."
  
  # Create math expression for combining masks
  math_expr="("
  var_options=""
  for i in "${!roi_files[@]}"; do
    if [ $i -gt 0 ]; then
      math_expr="${math_expr} + "
    fi
    math_expr="${math_expr}roi${i}"
    var_options="${var_options} -var roi${i} ${roi_files[$i]}"
  done
  math_expr="${math_expr}) > 0"
  
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "$math_expr" "$frontal_mask" $var_options
  
  if [ $? -eq 0 ]; then
    echo "frontal mask created successfully!"
    rm -rf "$temp_dir"
  else
    echo "ERROR: Failed to create frontal mask"
    rm -rf "$temp_dir"
    exit 1
  fi
else
  echo "ERROR: No valid ROI files created"
  rm -rf "$temp_dir"
  exit 1
fi

echo "frontal mask creation complete: $frontal_mask"