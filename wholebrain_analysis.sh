#!/bin/bash
#SBATCH --job-name=cifti_wholebrain
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=6:00:00
#SBATCH --output=cifti_wholebrain_%A_%a.log
#SBATCH --error=cifti_wholebrain_%A_%a.err
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

# Input reliability maps (already created)
input_rs="$base_path/reliability_maps/rs/sub-${subject}/sub-${subject}_rs_reliability.dscalar.nii"
input_me="$base_path/reliability_maps/me/sub-${subject}/sub-${subject}_me_reliability.dscalar.nii"

# Output directories
out_rs="$base_path/reliability_maps/rs/sub-${subject}"
out_me="$base_path/reliability_maps/me/sub-${subject}"

image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

# Process RS reliability map
if [ -f "$input_rs" ]; then
  echo "Processing RS reliability map for sub-${subject}..."

  # Step 1: Convert reliability (r) to R-squared (R2)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x^2" "${out_rs}/sub-${subject}_rs_R2.dscalar.nii" -var x "$input_rs"

  # Step 2: clip values (input must be the original reliability map)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
  wb_command -cifti-math "min(max(x, -0.999999), 0.999999)" \
  "${out_rs}/sub-${subject}_rs_clipped.dscalar.nii" -var x "$input_rs"

  # Step 3: apply Fisher Z-transform (input must be clipped output)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "0.5 * ln((1 + x) / (1 - x))" \
    "${out_rs}/sub-${subject}_rs_fisher_z.dscalar.nii" -var x "${out_rs}/sub-${subject}_rs_clipped.dscalar.nii"

  # Step 4: Calculate whole brain average
  RS_WHOLE_BRAIN_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "${out_rs}/sub-${subject}_rs_fisher_z.dscalar.nii" -reduce MEAN)

  echo "RS whole brain mean Fisher z-transformed r: ${RS_WHOLE_BRAIN_MEAN}"
else
  echo "WARNING: RS reliability map not found for sub-${subject}"
fi

# Process ME reliability map
if [ -f "$input_me" ]; then
  echo "Processing ME reliability map for sub-${subject}..."

  # Step 1: Convert reliability (r) to R-squared (R2)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "x^2" "${out_me}/sub-${subject}_me_R2.dscalar.nii" -var x "$input_me"

  # Step 2: clip values (input must be the original reliability map)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
  wb_command -cifti-math "min(max(x, -0.999999), 0.999999)" \
  "${out_me}/sub-${subject}_me_clipped.dscalar.nii" -var x "$input_me"

  # Step 3: apply Fisher Z-transform (input must be clipped output)
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-math "0.5 * ln((1 + x) / (1 - x))" \
    "${out_me}/sub-${subject}_me_fisher_z.dscalar.nii" -var x "${out_me}/sub-${subject}_me_clipped.dscalar.nii"

  # Step 4: Calculate whole brain average
  ME_WHOLE_BRAIN_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-stats "${out_me}/sub-${subject}_me_fisher_z.dscalar.nii" -reduce MEAN)

  echo "ME whole brain mean Fisher z-transformed r: ${ME_WHOLE_BRAIN_MEAN}"
else
  echo "WARNING: ME reliability map not found for sub-${subject}"
fi

echo "All reliability processing done for sub-${subject}"