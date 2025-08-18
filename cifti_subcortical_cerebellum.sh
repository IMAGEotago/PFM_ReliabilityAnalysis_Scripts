#!/bin/bash
#SBATCH --job-name=cifti_region_averages2
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=6:00:00
#SBATCH --output=cifti_region_averages2_%A_%a.log
#SBATCH --error=cifti_region_averages2_%A_%a.err
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

input_rs="$base_path/reliability_maps/rs/sub-${subject}/sub-${subject}_rs_fisher_z.dscalar.nii"
input_me="$base_path/reliability_maps/me/sub-${subject}/sub-${subject}_me_fisher_z.dscalar.nii"

out_rs="$base_path/reliability_maps/rs/sub-${subject}"
out_me="$base_path/reliability_maps/me/sub-${subject}"

image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

echo "Processing subject: $subject"

#######################
# Process RS map
#######################
if [ -f "$input_rs" ]; then
  echo "Processing RS Fisher Z reliability map for sub-${subject}..."

  # Extract each subcortical volume (excluding cerebellum)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "ACCUMBENS_LEFT" "${out_rs}/RS_subc_ACCUMBENS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "ACCUMBENS_RIGHT" "${out_rs}/RS_subc_ACCUMBENS_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "AMYGDALA_LEFT" "${out_rs}/RS_subc_AMYGDALA_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "AMYGDALA_RIGHT" "${out_rs}/RS_subc_AMYGDALA_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "BRAIN_STEM" "${out_rs}/RS_subc_BRAIN_STEM.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "CAUDATE_LEFT" "${out_rs}/RS_subc_CAUDATE_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "CAUDATE_RIGHT" "${out_rs}/RS_subc_CAUDATE_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "DIENCEPHALON_VENTRAL_LEFT" "${out_rs}/RS_subc_DIENCEPHALON_VENTRAL_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "DIENCEPHALON_VENTRAL_RIGHT" "${out_rs}/RS_subc_DIENCEPHALON_VENTRAL_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "HIPPOCAMPUS_LEFT" "${out_rs}/RS_subc_HIPPOCAMPUS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "HIPPOCAMPUS_RIGHT" "${out_rs}/RS_subc_HIPPOCAMPUS_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "PALLIDUM_LEFT" "${out_rs}/RS_subc_PALLIDUM_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "PALLIDUM_RIGHT" "${out_rs}/RS_subc_PALLIDUM_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "PUTAMEN_LEFT" "${out_rs}/RS_subc_PUTAMEN_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "PUTAMEN_RIGHT" "${out_rs}/RS_subc_PUTAMEN_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "THALAMUS_LEFT" "${out_rs}/RS_subc_THALAMUS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "THALAMUS_RIGHT" "${out_rs}/RS_subc_THALAMUS_RIGHT.nii.gz"

  # Merge subcortical volumes
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -volume-merge "${out_rs}/RS_subcortical_merged.nii.gz" \
    -volume "${out_rs}/RS_subc_ACCUMBENS_LEFT.nii.gz" \
    -volume "${out_rs}/RS_subc_ACCUMBENS_RIGHT.nii.gz" \
    -volume "${out_rs}/RS_subc_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_rs}/RS_subc_AMYGDALA_RIGHT.nii.gz" \
    -volume "${out_rs}/RS_subc_BRAIN_STEM.nii.gz" \
    -volume "${out_rs}/RS_subc_CAUDATE_LEFT.nii.gz" \
    -volume "${out_rs}/RS_subc_CAUDATE_RIGHT.nii.gz" \
    -volume "${out_rs}/RS_subc_DIENCEPHALON_VENTRAL_LEFT.nii.gz" \
    -volume "${out_rs}/RS_subc_DIENCEPHALON_VENTRAL_RIGHT.nii.gz" \
    -volume "${out_rs}/RS_subc_HIPPOCAMPUS_LEFT.nii.gz" \
    -volume "${out_rs}/RS_subc_HIPPOCAMPUS_RIGHT.nii.gz" \
    -volume "${out_rs}/RS_subc_PALLIDUM_LEFT.nii.gz" \
    -volume "${out_rs}/RS_subc_PALLIDUM_RIGHT.nii.gz" \
    -volume "${out_rs}/RS_subc_PUTAMEN_LEFT.nii.gz" \
    -volume "${out_rs}/RS_subc_PUTAMEN_RIGHT.nii.gz" \
    -volume "${out_rs}/RS_subc_THALAMUS_LEFT.nii.gz" \
    -volume "${out_rs}/RS_subc_THALAMUS_RIGHT.nii.gz"

  RS_SUBCORTICAL_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" fslstats "${out_rs}/RS_subcortical_merged.nii.gz" -M)
  echo "RS subcortical mean Fisher z: ${RS_SUBCORTICAL_MEAN}"

  # Extract and merge cerebellum volumes
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "CEREBELLUM_LEFT" "${out_rs}/RS_cereb_CEREBELLUM_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_rs" COLUMN -volume "CEREBELLUM_RIGHT" "${out_rs}/RS_cereb_CEREBELLUM_RIGHT.nii.gz"

  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -volume-merge "${out_rs}/RS_cerebellum_merged.nii.gz" \
    -volume "${out_rs}/RS_cereb_CEREBELLUM_LEFT.nii.gz" \
    -volume "${out_rs}/RS_cereb_CEREBELLUM_RIGHT.nii.gz"

  RS_CEREBELLUM_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" fslstats "${out_rs}/RS_cerebellum_merged.nii.gz" -M)
  echo "RS cerebellum mean Fisher z: ${RS_CEREBELLUM_MEAN}"

else
  echo "WARNING: RS Fisher Z reliability map not found for sub-${subject}"
fi

#######################
# Process ME map
#######################
if [ -f "$input_me" ]; then
  echo "Processing ME Fisher Z reliability map for sub-${subject}..."

  # Extract each subcortical volume (excluding cerebellum)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "ACCUMBENS_LEFT" "${out_me}/ME_subc_ACCUMBENS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "ACCUMBENS_RIGHT" "${out_me}/ME_subc_ACCUMBENS_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "AMYGDALA_LEFT" "${out_me}/ME_subc_AMYGDALA_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "AMYGDALA_RIGHT" "${out_me}/ME_subc_AMYGDALA_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "BRAIN_STEM" "${out_me}/ME_subc_BRAIN_STEM.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "CAUDATE_LEFT" "${out_me}/ME_subc_CAUDATE_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "CAUDATE_RIGHT" "${out_me}/ME_subc_CAUDATE_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "DIENCEPHALON_VENTRAL_LEFT" "${out_me}/ME_subc_DIENCEPHALON_VENTRAL_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "DIENCEPHALON_VENTRAL_RIGHT" "${out_me}/ME_subc_DIENCEPHALON_VENTRAL_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "HIPPOCAMPUS_LEFT" "${out_me}/ME_subc_HIPPOCAMPUS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "HIPPOCAMPUS_RIGHT" "${out_me}/ME_subc_HIPPOCAMPUS_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "PALLIDUM_LEFT" "${out_me}/ME_subc_PALLIDUM_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "PALLIDUM_RIGHT" "${out_me}/ME_subc_PALLIDUM_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "PUTAMEN_LEFT" "${out_me}/ME_subc_PUTAMEN_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "PUTAMEN_RIGHT" "${out_me}/ME_subc_PUTAMEN_RIGHT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "THALAMUS_LEFT" "${out_me}/ME_subc_THALAMUS_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "THALAMUS_RIGHT" "${out_me}/ME_subc_THALAMUS_RIGHT.nii.gz"

  # Merge subcortical volumes
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -volume-merge "${out_me}/ME_subcortical_merged.nii.gz" \
    -volume "${out_me}/ME_subc_ACCUMBENS_LEFT.nii.gz" \
    -volume "${out_me}/ME_subc_ACCUMBENS_RIGHT.nii.gz" \
    -volume "${out_me}/ME_subc_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_me}/ME_subc_AMYGDALA_RIGHT.nii.gz" \
    -volume "${out_me}/ME_subc_BRAIN_STEM.nii.gz" \
    -volume "${out_me}/ME_subc_CAUDATE_LEFT.nii.gz" \
    -volume "${out_me}/ME_subc_CAUDATE_RIGHT.nii.gz" \
    -volume "${out_me}/ME_subc_DIENCEPHALON_VENTRAL_LEFT.nii.gz" \
    -volume "${out_me}/ME_subc_DIENCEPHALON_VENTRAL_RIGHT.nii.gz" \
    -volume "${out_me}/ME_subc_HIPPOCAMPUS_LEFT.nii.gz" \
    -volume "${out_me}/ME_subc_HIPPOCAMPUS_RIGHT.nii.gz" \
    -volume "${out_me}/ME_subc_PALLIDUM_LEFT.nii.gz" \
    -volume "${out_me}/ME_subc_PALLIDUM_RIGHT.nii.gz" \
    -volume "${out_me}/ME_subc_PUTAMEN_LEFT.nii.gz" \
    -volume "${out_me}/ME_subc_PUTAMEN_RIGHT.nii.gz" \
    -volume "${out_me}/ME_subc_THALAMUS_LEFT.nii.gz" \
    -volume "${out_me}/ME_subc_THALAMUS_RIGHT.nii.gz"

  ME_SUBCORTICAL_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" fslstats "${out_me}/ME_subcortical_merged.nii.gz" -M)
  echo "ME subcortical mean Fisher z: ${ME_SUBCORTICAL_MEAN}"

  # Extract and merge cerebellum volumes
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "CEREBELLUM_LEFT" "${out_me}/ME_cereb_CEREBELLUM_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -cifti-separate "$input_me" COLUMN -volume "CEREBELLUM_RIGHT" "${out_me}/ME_cereb_CEREBELLUM_RIGHT.nii.gz"

  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" wb_command -volume-merge "${out_me}/ME_cerebellum_merged.nii.gz" \
    -volume "${out_me}/ME_cereb_CEREBELLUM_LEFT.nii.gz" \
    -volume "${out_me}/ME_cereb_CEREBELLUM_RIGHT.nii.gz"

  ME_CEREBELLUM_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" fslstats "${out_me}/ME_cerebellum_merged.nii.gz" -M)
  echo "ME cerebellum mean Fisher z: ${ME_CEREBELLUM_MEAN}"

else
  echo "WARNING: ME Fisher Z reliability map not found for sub-${subject}"
fi

echo "Subcortical and cerebellum averages done for sub-${subject}"
