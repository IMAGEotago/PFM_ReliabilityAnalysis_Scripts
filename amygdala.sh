#!/bin/bash
#SBATCH --job-name=amygdala_extraction
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=30G
#SBATCH --time=2:00:00
#SBATCH --output=amygdala_extraction_%A_%a.log
#SBATCH --error=amygdala_extraction_%A_%a.err
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

# Input files
input_rs_fisher="$base_path/reliability_maps/rs/sub-${subject}/sub-${subject}_rs_fisher_z.dscalar.nii"
input_me_fisher="$base_path/reliability_maps/me/sub-${subject}/sub-${subject}_me_fisher_z.dscalar.nii"

# R2 maps (already exist)
input_rs_r2="$base_path/reliability_maps/rs/sub-${subject}/sub-${subject}_rs_R2.dscalar.nii"
input_me_r2="$base_path/reliability_maps/me/sub-${subject}/sub-${subject}_me_R2.dscalar.nii"

# Create amygdala_data output directories
out_rs_amyg="$base_path/reliability_maps/rs/sub-${subject}/amygdala_data"
out_me_amyg="$base_path/reliability_maps/me/sub-${subject}/amygdala_data"

mkdir -p "$out_rs_amyg"
mkdir -p "$out_me_amyg"

image="/home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg"

echo "Processing amygdala data for subject: $subject"

#######################
# Process RS data
#######################
if [ -f "$input_rs_fisher" ] && [ -f "$input_rs_r2" ]; then
  echo "Processing RS amygdala data for sub-${subject}..."

  # Copy existing Fisher Z amygdala files to amygdala_data directory
  cp "$base_path/reliability_maps/rs/sub-${subject}/RS_subc_AMYGDALA_LEFT.nii.gz" "${out_rs_amyg}/RS_fisher_AMYGDALA_LEFT.nii.gz"
  cp "$base_path/reliability_maps/rs/sub-${subject}/RS_subc_AMYGDALA_RIGHT.nii.gz" "${out_rs_amyg}/RS_fisher_AMYGDALA_RIGHT.nii.gz"

  # Extract R2 amygdala volumes
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "AMYGDALA_LEFT" "${out_rs_amyg}/RS_R2_AMYGDALA_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_rs_r2" COLUMN -volume "AMYGDALA_RIGHT" "${out_rs_amyg}/RS_R2_AMYGDALA_RIGHT.nii.gz"

  # Merge bilateral amygdala Fisher Z
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_rs_amyg}/RS_fisher_AMYGDALA_bilateral.nii.gz" \
    -volume "${out_rs_amyg}/RS_fisher_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_rs_amyg}/RS_fisher_AMYGDALA_RIGHT.nii.gz"

  # Merge bilateral amygdala R2
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_rs_amyg}/RS_R2_AMYGDALA_bilateral.nii.gz" \
    -volume "${out_rs_amyg}/RS_R2_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_rs_amyg}/RS_R2_AMYGDALA_RIGHT.nii.gz"

  # Calculate Fisher Z mean only (R2 is just for visualization)
  RS_AMYG_FISHER_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" fslstats "${out_rs_amyg}/RS_fisher_AMYGDALA_bilateral.nii.gz" -M)
  
  echo "RS amygdala bilateral Fisher Z mean: ${RS_AMYG_FISHER_MEAN}"

else
  echo "WARNING: RS Fisher Z reliability map not found for sub-${subject}"
fi

#######################
# Process ME data
#######################
if [ -f "$input_me_fisher" ] && [ -f "$input_me_r2" ]; then
  echo "Processing ME amygdala data for sub-${subject}..."

  # Copy existing Fisher Z amygdala files to amygdala_data directory
  cp "$base_path/reliability_maps/me/sub-${subject}/ME_subc_AMYGDALA_LEFT.nii.gz" "${out_me_amyg}/ME_fisher_AMYGDALA_LEFT.nii.gz"
  cp "$base_path/reliability_maps/me/sub-${subject}/ME_subc_AMYGDALA_RIGHT.nii.gz" "${out_me_amyg}/ME_fisher_AMYGDALA_RIGHT.nii.gz"

  # Extract R2 amygdala volumes
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "AMYGDALA_LEFT" "${out_me_amyg}/ME_R2_AMYGDALA_LEFT.nii.gz"
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -cifti-separate "$input_me_r2" COLUMN -volume "AMYGDALA_RIGHT" "${out_me_amyg}/ME_R2_AMYGDALA_RIGHT.nii.gz"

  # Merge bilateral amygdala Fisher Z
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_me_amyg}/ME_fisher_AMYGDALA_bilateral.nii.gz" \
    -volume "${out_me_amyg}/ME_fisher_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_me_amyg}/ME_fisher_AMYGDALA_RIGHT.nii.gz"

  # Merge bilateral amygdala R2
  singularity exec --cleanenv -B "$base_path":"$base_path" "$image" \
    wb_command -volume-merge "${out_me_amyg}/ME_R2_AMYGDALA_bilateral.nii.gz" \
    -volume "${out_me_amyg}/ME_R2_AMYGDALA_LEFT.nii.gz" \
    -volume "${out_me_amyg}/ME_R2_AMYGDALA_RIGHT.nii.gz"

  # Calculate Fisher Z mean only (R2 is just for visualization)
  ME_AMYG_FISHER_MEAN=$(singularity exec --cleanenv -B "$base_path":"$base_path" "$image" fslstats "${out_me_amyg}/ME_fisher_AMYGDALA_bilateral.nii.gz" -M)
  
  echo "ME amygdala bilateral Fisher Z mean: ${ME_AMYG_FISHER_MEAN}"

else
  echo "WARNING: ME Fisher Z reliability map not found for sub-${subject}"
fi

echo "Amygdala data extraction complete for sub-${subject}"