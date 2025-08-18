#!/bin/bash

#SBATCH --job-name=r2_visualization
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=28G
#SBATCH --time=3:00:00
#SBATCH --output=r2_visualization_%A_%a.log
#SBATCH --error=r2_visualization_%A_%a.err
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

# Input R2 files
input_rs_r2="$base_path/reliability_maps/rs/sub-${subject}/sub-${subject}_rs_R2.dscalar.nii"
input_me_r2="$base_path/reliability_maps/me/sub-${subject}/sub-${subject}_me_R2.dscalar.nii"

# Create visualization_files output directories
out_rs_vis="$base_path/reliability_maps/rs/sub-${subject}/visualization_files"
out_me_vis="$base_path/reliability_maps/me/sub-${subject}/visualization_files"

mkdir -p "$out_rs_vis"
mkdir -p "$out_me_vis"

image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

echo "Creating R2 visualization files for subject: $subject"

#######################
# Process RS R2 data
#######################
if [ -f "$input_rs_r2" ]; then
  echo "Creating RS R2 visualization files for sub-${subject}..."

  # Extract cortex (surfaces)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -metric CORTEX_LEFT "${out_rs_vis}/RS_R2_CORTEX_LEFT.func.gii"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -metric CORTEX_RIGHT "${out_rs_vis}/RS_R2_CORTEX_RIGHT.func.gii"

  # Create cortex-only dense scalar file
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-create-dense-scalar "${out_rs_vis}/RS_R2_cortex_only.dscalar.nii" \
    -left-metric "${out_rs_vis}/RS_R2_CORTEX_LEFT.func.gii" \
    -right-metric "${out_rs_vis}/RS_R2_CORTEX_RIGHT.func.gii"

  # Extract cerebellum
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "CEREBELLUM_LEFT" "${out_rs_vis}/RS_R2_CEREBELLUM_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "CEREBELLUM_RIGHT" "${out_rs_vis}/RS_R2_CEREBELLUM_RIGHT.nii.gz"

  # Merge cerebellum bilateral
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_rs_vis}/RS_R2_CEREBELLUM_bilateral.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_CEREBELLUM_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_CEREBELLUM_RIGHT.nii.gz"

  # Extract all subcortical structures (excluding cerebellum)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "ACCUMBENS_LEFT" "${out_rs_vis}/RS_R2_ACCUMBENS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "ACCUMBENS_RIGHT" "${out_rs_vis}/RS_R2_ACCUMBENS_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "AMYGDALA_LEFT" "${out_rs_vis}/RS_R2_AMYGDALA_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "AMYGDALA_RIGHT" "${out_rs_vis}/RS_R2_AMYGDALA_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "BRAIN_STEM" "${out_rs_vis}/RS_R2_BRAIN_STEM.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "CAUDATE_LEFT" "${out_rs_vis}/RS_R2_CAUDATE_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "CAUDATE_RIGHT" "${out_rs_vis}/RS_R2_CAUDATE_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "DIENCEPHALON_VENTRAL_LEFT" "${out_rs_vis}/RS_R2_DIENCEPHALON_VENTRAL_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "DIENCEPHALON_VENTRAL_RIGHT" "${out_rs_vis}/RS_R2_DIENCEPHALON_VENTRAL_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "HIPPOCAMPUS_LEFT" "${out_rs_vis}/RS_R2_HIPPOCAMPUS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "HIPPOCAMPUS_RIGHT" "${out_rs_vis}/RS_R2_HIPPOCAMPUS_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "PALLIDUM_LEFT" "${out_rs_vis}/RS_R2_PALLIDUM_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "PALLIDUM_RIGHT" "${out_rs_vis}/RS_R2_PALLIDUM_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "PUTAMEN_LEFT" "${out_rs_vis}/RS_R2_PUTAMEN_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "PUTAMEN_RIGHT" "${out_rs_vis}/RS_R2_PUTAMEN_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "THALAMUS_LEFT" "${out_rs_vis}/RS_R2_THALAMUS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "THALAMUS_RIGHT" "${out_rs_vis}/RS_R2_THALAMUS_RIGHT.nii.gz"

  # Merge subcortical structures (excluding cerebellum)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_rs_vis}/RS_R2_subcortical_no_cerebellum.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_ACCUMBENS_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_ACCUMBENS_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_AMYGDALA_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_BRAIN_STEM.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_CAUDATE_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_CAUDATE_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_DIENCEPHALON_VENTRAL_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_DIENCEPHALON_VENTRAL_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_HIPPOCAMPUS_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_HIPPOCAMPUS_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_PALLIDUM_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_PALLIDUM_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_PUTAMEN_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_PUTAMEN_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_THALAMUS_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_THALAMUS_RIGHT.nii.gz"

  # Merge subcortical structures (including cerebellum)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_rs_vis}/RS_R2_subcortical_with_cerebellum.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_ACCUMBENS_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_ACCUMBENS_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_AMYGDALA_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_BRAIN_STEM.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_CAUDATE_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_CAUDATE_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_DIENCEPHALON_VENTRAL_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_DIENCEPHALON_VENTRAL_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_HIPPOCAMPUS_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_HIPPOCAMPUS_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_PALLIDUM_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_PALLIDUM_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_PUTAMEN_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_PUTAMEN_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_THALAMUS_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_THALAMUS_RIGHT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_CEREBELLUM_LEFT.nii.gz" \
    -volume "${out_rs_vis}/RS_R2_CEREBELLUM_RIGHT.nii.gz"

  echo "RS R2 visualization files created"

else
  echo "WARNING: RS R2 map not found for sub-${subject}"
fi

#######################
# Process ME R2 data
#######################
if [ -f "$input_me_r2" ]; then
  echo "Creating ME R2 visualization files for sub-${subject}..."

  # Extract cortex (surfaces)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -metric CORTEX_LEFT "${out_me_vis}/ME_R2_CORTEX_LEFT.func.gii"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -metric CORTEX_RIGHT "${out_me_vis}/ME_R2_CORTEX_RIGHT.func.gii"

  # Create cortex-only dense scalar file
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-create-dense-scalar "${out_me_vis}/ME_R2_cortex_only.dscalar.nii" \
    -left-metric "${out_me_vis}/ME_R2_CORTEX_LEFT.func.gii" \
    -right-metric "${out_me_vis}/ME_R2_CORTEX_RIGHT.func.gii"

  # Extract cerebellum
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "CEREBELLUM_LEFT" "${out_me_vis}/ME_R2_CEREBELLUM_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "CEREBELLUM_RIGHT" "${out_me_vis}/ME_R2_CEREBELLUM_RIGHT.nii.gz"

  # Merge cerebellum bilateral
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_me_vis}/ME_R2_CEREBELLUM_bilateral.nii.gz" \
    -volume "${out_me_vis}/ME_R2_CEREBELLUM_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_CEREBELLUM_RIGHT.nii.gz"

  # Extract all subcortical structures (excluding cerebellum)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "ACCUMBENS_LEFT" "${out_me_vis}/ME_R2_ACCUMBENS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "ACCUMBENS_RIGHT" "${out_me_vis}/ME_R2_ACCUMBENS_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "AMYGDALA_LEFT" "${out_me_vis}/ME_R2_AMYGDALA_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "AMYGDALA_RIGHT" "${out_me_vis}/ME_R2_AMYGDALA_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "BRAIN_STEM" "${out_me_vis}/ME_R2_BRAIN_STEM.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "CAUDATE_LEFT" "${out_me_vis}/ME_R2_CAUDATE_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "CAUDATE_RIGHT" "${out_me_vis}/ME_R2_CAUDATE_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "DIENCEPHALON_VENTRAL_LEFT" "${out_me_vis}/ME_R2_DIENCEPHALON_VENTRAL_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "DIENCEPHALON_VENTRAL_RIGHT" "${out_me_vis}/ME_R2_DIENCEPHALON_VENTRAL_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "HIPPOCAMPUS_LEFT" "${out_me_vis}/ME_R2_HIPPOCAMPUS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "HIPPOCAMPUS_RIGHT" "${out_me_vis}/ME_R2_HIPPOCAMPUS_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "PALLIDUM_LEFT" "${out_me_vis}/ME_R2_PALLIDUM_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "PALLIDUM_RIGHT" "${out_me_vis}/ME_R2_PALLIDUM_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "PUTAMEN_LEFT" "${out_me_vis}/ME_R2_PUTAMEN_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "PUTAMEN_RIGHT" "${out_me_vis}/ME_R2_PUTAMEN_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "THALAMUS_LEFT" "${out_me_vis}/ME_R2_THALAMUS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "THALAMUS_RIGHT" "${out_me_vis}/ME_R2_THALAMUS_RIGHT.nii.gz"

  # Merge subcortical structures (excluding cerebellum)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_me_vis}/ME_R2_subcortical_no_cerebellum.nii.gz" \
    -volume "${out_me_vis}/ME_R2_ACCUMBENS_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_ACCUMBENS_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_AMYGDALA_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_BRAIN_STEM.nii.gz" \
    -volume "${out_me_vis}/ME_R2_CAUDATE_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_CAUDATE_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_DIENCEPHALON_VENTRAL_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_DIENCEPHALON_VENTRAL_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_HIPPOCAMPUS_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_HIPPOCAMPUS_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_PALLIDUM_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_PALLIDUM_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_PUTAMEN_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_PUTAMEN_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_THALAMUS_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_THALAMUS_RIGHT.nii.gz"

  # Merge subcortical structures (including cerebellum)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_me_vis}/ME_R2_subcortical_with_cerebellum.nii.gz" \
    -volume "${out_me_vis}/ME_R2_ACCUMBENS_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_ACCUMBENS_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_AMYGDALA_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_BRAIN_STEM.nii.gz" \
    -volume "${out_me_vis}/ME_R2_CAUDATE_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_CAUDATE_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_DIENCEPHALON_VENTRAL_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_DIENCEPHALON_VENTRAL_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_HIPPOCAMPUS_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_HIPPOCAMPUS_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_PALLIDUM_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_PALLIDUM_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_PUTAMEN_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_PUTAMEN_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_THALAMUS_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_THALAMUS_RIGHT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_CEREBELLUM_LEFT.nii.gz" \
    -volume "${out_me_vis}/ME_R2_CEREBELLUM_RIGHT.nii.gz"

  echo "ME R2 visualization files created"

else
  echo "WARNING: ME R2 map not found for sub-${subject}"
fi

echo "R2 visualization files creation complete for sub-${subject}"