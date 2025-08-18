#!/bin/bash
#SBATCH --job-name=fix_frontal_mask
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=0:30:00
#SBATCH --output=fix_frontal_mask_%j.log
#SBATCH --error=fix_frontal_mask_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz

base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"
image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

# Original mask (59412 vertices - cortex only)
original_mask="$base_path/masks/frontal_mask.dscalar.nii"

# Reference file with correct dimensions (64984 vertices - cortex + subcortex)
reference_file="$base_path/reliability_maps/rs/sub-pfm01/cortex_combined.dscalar.nii"

# New mask with correct dimensions
fixed_mask="$base_path/masks/frontal_mask_fixed.dscalar.nii"

echo "Fixing frontal mask dimensions..."

# Check if reference file exists
if [ ! -f "$reference_file" ]; then
    echo "ERROR: Reference file not found: $reference_file"
    echo "Please use any of your existing .dscalar.nii files as reference"
    exit 1
fi

# Check if original mask exists
if [ ! -f "$original_mask" ]; then
    echo "ERROR: Original mask not found: $original_mask"
    exit 1
fi

echo "Original mask: $original_mask (59412 vertices)"
echo "Reference file: $reference_file (64984 vertices)"
echo "Output mask: $fixed_mask"

# Method 1: Use cifti-create-dense-from-template to match structure
# First, let's try the simpler approach - create a template with the right structure
singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-create-dense-from-template "$reference_file" "$fixed_mask" \
    -cifti "$original_mask"

if [ $? -eq 0 ]; then
    echo "✓ Mask resampled successfully!"
    
    # Verify the dimensions match now
    echo "Checking dimensions..."
    singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
        wb_command -file-information "$fixed_mask"
    
    echo "✓ Fixed mask created: $fixed_mask"
    echo "You can now use this mask in your extraction script"
else
    echo "✗ ERROR: Failed to resample mask"
    exit 1
fi