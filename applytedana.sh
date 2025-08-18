#!/bin/bash
#SBATCH --job-name=me_denoise
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=36:00:00
#SBATCH --output=me_denoise_%A_%a.log
#SBATCH --error=me_denoise_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-27  # 14 participants × 2 sessions

export PATH=$PATH:/home/dumbr174/.local/bin

# Load necessary modules
module load apptainer/FSL/6.0.7
module load apptainer/fMRIPrep/23.2.3

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

# Input files
preproc_t1w="$base_path/fmriprep/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_run-001_space-T1w_desc-preproc_bold.nii.gz"
mixing_tsv="$base_path/tedana/sub-${subject}/ses-${session}/desc-ICA_mixing.tsv"
comp_table="$base_path/tedana/sub-${subject}/ses-${session}/desc-ICA_status_table.tsv"

# Output directory
output_dir="$base_path/completed_multiecho/sub-${subject}/ses-${session}"
mkdir -p "$output_dir"

# Working directory for temporary files
work_dir="$output_dir/temp_$$"
mkdir -p "$work_dir"

echo "Processing multi-echo denoising for sub-${subject} ses-${session} ..."

# Check if input files exist
if [[ ! -f "$preproc_t1w" ]]; then
    echo "Error: Preprocessed T1w file not found: $preproc_t1w"
    exit 1
fi

if [[ ! -f "$mixing_tsv" ]]; then
    echo "Error: Mixing matrix not found: $mixing_tsv"
    exit 1
fi

if [[ ! -f "$comp_table" ]]; then
    echo "Error: Component table not found: $comp_table"
    exit 1
fi

# Extract rejected component indices (0-based) from the final column
echo "Extracting rejected components..."
rejected_comps=$(awk -F'\t' 'NR>1 && $NF=="rejected" {gsub(/ICA_/, "", $1); print $1}' "$comp_table" | tr '\n' ',' | sed 's/,$//')

if [[ -z "$rejected_comps" ]]; then
    echo "No rejected components found. Copying original file..."
    cp "$preproc_t1w" "$output_dir/sub-${subject}_ses-${session}_desc-medenoised_space-T1w_bold.nii.gz"
else
    echo "Rejected components: $rejected_comps"
    
    # Prepare mixing matrix (remove header)
    echo "Preparing mixing matrix..."
    tail -n +2 "$mixing_tsv" > "$work_dir/mixing_noheader.txt"
    
    # Create rejected components design matrix
    echo "Creating rejected components design matrix..."
    IFS=',' read -ra COMP_ARRAY <<< "$rejected_comps"
    
    # Extract rejected component columns (add 1 to convert from 0-based to 1-based for awk)
    first_comp=true
    for comp in "${COMP_ARRAY[@]}"; do
        # Remove leading zeros to avoid octal interpretation
        comp_num=$(echo "$comp" | sed 's/^0*//')
        if [[ -z "$comp_num" ]]; then comp_num=0; fi
        comp_col=$((comp_num + 1))  # Convert to 1-based indexing for awk
        if [[ "$first_comp" == true ]]; then
            awk -v col="$comp_col" '{print $col}' "$work_dir/mixing_noheader.txt" > "$work_dir/rejected_mixing.txt"
            first_comp=false
        else
            awk -v col="$comp_col" '{print $col}' "$work_dir/mixing_noheader.txt" > "$work_dir/temp_col.txt"
            paste "$work_dir/rejected_mixing.txt" "$work_dir/temp_col.txt" > "$work_dir/rejected_mixing_temp.txt"
            mv "$work_dir/rejected_mixing_temp.txt" "$work_dir/rejected_mixing.txt"
            rm "$work_dir/temp_col.txt"
        fi
    done
    
    # Use fsl_glm to fit rejected components and get residuals
    echo "Fitting rejected components using fsl_glm..."
    apptainer run /opt/apptainer_img/fsl-6.0.7.12.sif \
    fsl_glm -i "$preproc_t1w" \
            -d "$work_dir/rejected_mixing.txt" \
            -o "$work_dir/component_fits.nii.gz" \
            --out_res="$output_dir/sub-${subject}_ses-${session}_desc-medenoised_space-T1w_bold.nii.gz"
fi

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf "$work_dir"

echo "Multi-echo denoising completed for sub-${subject} ses-${session}"
echo "Output file: $output_dir/sub-${subject}_ses-${session}_desc-medenoised_space-T1w_bold.nii.gz"