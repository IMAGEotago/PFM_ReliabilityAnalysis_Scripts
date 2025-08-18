#!/bin/bash
#SBATCH --job-name=cifti_smoothing
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=36G
#SBATCH --time=36:00:00
#SBATCH --output=cifti_smoothing_%A_%a.log
#SBATCH --error=cifti_smoothing_%A_%a.err
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

# Add smoothing step for rs
ciftify_dir1="$base_path/ciftify_rs"
output_cifti1="$ciftify_dir1/sub-${subject}_ses-${session}/MNINonLinear/Results/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-rsdenoisedmgtr_bold/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-rsdenoisedmgtr_bold_Atlas_s0.dtseries.nii"
surfaces_dir1="$ciftify_dir1/sub-${subject}_ses-${session}/MNINonLinear/fsaverage_LR32k"

    echo "Applying geodesic and Euclidean smoothing to rs (σ = 2.55mm)..."
    singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
        wb_command -cifti-smoothing \
        "$output_cifti1" \
        2.55 \
        2.55 \
        COLUMN \
        "${output_cifti1%.dtseries.nii}_smoothed.dtseries.nii" \
        -left-surface "$surfaces_dir1/sub-${subject}_ses-${session}.L.midthickness.32k_fs_LR.surf.gii" \
        -right-surface "$surfaces_dir1/sub-${subject}_ses-${session}.R.midthickness.32k_fs_LR.surf.gii"
    echo "Smoothing completed for sub-${subject} ses-${session}"
    
# Add smoothing step for me
ciftify_dir2="$base_path/ciftify_me"
output_cifti2="$ciftify_dir2/sub-${subject}_ses-${session}/MNINonLinear/Results/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-medenoisedmgtr_bold/sub-${subject}_ses-${session}_task-rest_space-T1w_desc-medenoisedmgtr_bold_Atlas_s0.dtseries.nii"
surfaces_dir2="$ciftify_dir2/sub-${subject}_ses-${session}/MNINonLinear/fsaverage_LR32k"

    echo "Applying geodesic and Euclidean smoothing to me (σ = 2.55mm)..."
    singularity exec --cleanenv -B "$base_path":"$base_path" /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
        wb_command -cifti-smoothing \
        "$output_cifti2" \
        2.55 \
        2.55 \
        COLUMN \
        "${output_cifti2%.dtseries.nii}_smoothed.dtseries.nii" \
        -left-surface "$surfaces_dir2/sub-${subject}_ses-${session}.L.midthickness.32k_fs_LR.surf.gii" \
        -right-surface "$surfaces_dir2/sub-${subject}_ses-${session}.R.midthickness.32k_fs_LR.surf.gii"
    echo "Smoothing completed for sub-${subject} ses-${session}"