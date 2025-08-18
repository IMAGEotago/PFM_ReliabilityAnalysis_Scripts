#!/bin/bash
#SBATCH --job-name=ciftify_proc_me
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=48:00:00
#SBATCH --output=ciftify_me_%A_%a.log
#SBATCH --error=ciftify_me_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dumbr174@otago.student.ac.nz
#SBATCH --array=0-27  # All 28 (14 participants with 2 sessions each)

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

# Get the current combination
combination=(${combinations[$SLURM_ARRAY_TASK_ID]})
subject=${combination[0]}
session=${combination[1]}

# Set up directories
base_path="/projects/sciences/psychology/imageotago/dumbr174/PFMtrial1/processed/bids/derivatives"
freesurfer_dir="$base_path/freesurfer"
ciftify_dir="$base_path/ciftify_me"

# Create output directory if it doesn't exist
mkdir -p "$ciftify_dir"

# Check if FreeSurfer recon-all output exists
if [ ! -d "$freesurfer_dir/sub-${subject}_ses-${session}" ]; then
    echo "ERROR: FreeSurfer output not found for sub-${subject}_ses-${session}"
    echo "Expected: $freesurfer_dir/sub-${subject}_ses-${session}"
    exit 1
fi

# Run CIFTIFY recon-all
echo "Running CIFTIFY recon-all for sub-${subject} ses-${session}"

# Set the license environment variable for the container
export SINGULARITYENV_FS_LICENSE=/home/dumbr174/restingSnake/config/license.txt

singularity exec --cleanenv -B /home/dumbr174/restingSnake/config:/home/dumbr174/restingSnake/config /home/dumbr174/my_images/tigrlab_fmriprep_ciftify_v1.3.2-2.3.3-2019-08-16-bf3f7a4da448.simg \
    ciftify_recon_all \
    --ciftify-work-dir "$ciftify_dir" \
    --fs-subjects-dir "$freesurfer_dir" \
    sub-${subject}_ses-${session}

echo "CIFTIFY recon-all completed for sub-${subject} ses-${session}"