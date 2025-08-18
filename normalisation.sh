#!/bin/bash
#SBATCH --job-name=cifti_normalization
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=36G
#SBATCH --time=36:00:00
#SBATCH --output=cifti_normalization_%A_%a.log
#SBATCH --error=cifti_normalization_%A_%a.err
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

# Get the current combination from the SLURM array index
combination=(${combinations[$SLURM_ARRAY_TASK_ID]})
subject=${combination[0]}
session=${combination[1]}

base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"

# Normalize rs data
ciftify_dir1="$base_path/ciftify_rs"
smoothed_cifti1="$ciftify_dir1/sub-${subject}_ses-${session}/MNINonLinear/Results/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-rsdenoisedmgtr_bold/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-rsdenoisedmgtr_bold_Atlas_s0_smoothed.dtseries.nii"

echo "Normalizing rs data for sub-${subject} ses-${session}..."

# Check if smoothed file exists
if [ ! -f "$smoothed_cifti1" ]; then
    echo "ERROR: Smoothed file not found: $smoothed_cifti1"
    exit 1
fi

# Step 1: Calculate mean across time for each vertex/voxel
echo "  Computing mean across time..."
singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    wb_command -cifti-reduce \
    "$smoothed_cifti1" \
    MEAN \
    "${smoothed_cifti1%.dtseries.nii}_mean.dscalar.nii" \
    -direction ROW

# Step 2: Calculate standard deviation across time for each vertex/voxel
echo "  Computing standard deviation across time..."
singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    wb_command -cifti-reduce \
    "$smoothed_cifti1" \
    STDEV \
    "${smoothed_cifti1%.dtseries.nii}_stdev.dscalar.nii" \
    -direction ROW

# Step 3: Z-score normalize - FIXED: Changed variable names to avoid underscores
echo "  Applying z-score normalization..."
singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    wb_command -cifti-math \
    "(x - meandata) / stdevdata" \
    "${smoothed_cifti1%.dtseries.nii}_normalized.dtseries.nii" \
    -fixnan 0 \
    -var x "$smoothed_cifti1" \
    -var meandata "${smoothed_cifti1%.dtseries.nii}_mean.dscalar.nii" -select 1 1 -repeat \
    -var stdevdata "${smoothed_cifti1%.dtseries.nii}_stdev.dscalar.nii" -select 1 1 -repeat

# Clean up temporary files
echo "  Cleaning up temporary files..."
rm "${smoothed_cifti1%.dtseries.nii}_mean.dscalar.nii"
rm "${smoothed_cifti1%.dtseries.nii}_stdev.dscalar.nii"

echo "Normalization completed for rs data: sub-${subject} ses-${session}"

# Normalize me data
ciftify_dir2="$base_path/ciftify_me"
smoothed_cifti2="$ciftify_dir2/sub-${subject}_ses-${session}/MNINonLinear/Results/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-medenoisedmgtr_bold/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-medenoisedmgtr_bold_Atlas_s0_smoothed.dtseries.nii"

echo "Normalizing me data for sub-${subject} ses-${session}..."

# Check if smoothed file exists
if [ ! -f "$smoothed_cifti2" ]; then
    echo "ERROR: Smoothed file not found: $smoothed_cifti2"
    exit 1
fi

# Step 1: Calculate mean across time for each vertex/voxel
echo "  Computing mean across time..."
singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    wb_command -cifti-reduce \
    "$smoothed_cifti2" \
    MEAN \
    "${smoothed_cifti2%.dtseries.nii}_mean.dscalar.nii" \
    -direction ROW

# Step 2: Calculate standard deviation across time for each vertex/voxel
echo "  Computing standard deviation across time..."
singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    wb_command -cifti-reduce \
    "$smoothed_cifti2" \
    STDEV \
    "${smoothed_cifti2%.dtseries.nii}_stdev.dscalar.nii" \
    -direction ROW

# Step 3: Z-score normalize - FIXED: Changed variable names to avoid underscores
echo "  Applying z-score normalization..."
singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    wb_command -cifti-math \
    "(x - meandata) / stdevdata" \
    "${smoothed_cifti2%.dtseries.nii}_normalized.dtseries.nii" \
    -fixnan 0 \
    -var x "$smoothed_cifti2" \
    -var meandata "${smoothed_cifti2%.dtseries.nii}_mean.dscalar.nii" -select 1 1 -repeat \
    -var stdevdata "${smoothed_cifti2%.dtseries.nii}_stdev.dscalar.nii" -select 1 1 -repeat

# Clean up temporary files
echo "  Cleaning up temporary files..."
rm "${smoothed_cifti2%.dtseries.nii}_mean.dscalar.nii"
rm "${smoothed_cifti2%.dtseries.nii}_stdev.dscalar.nii"

echo "Normalization completed for me data: sub-${subject} ses-${session}"
echo "All processing completed for sub-${subject} ses-${session}"