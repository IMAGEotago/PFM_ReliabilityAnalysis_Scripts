# PFM_ReliablityAnalysis_Scripts
This repository contains a collection of scripts originally developed on Otago On Demand HPC (Aoraki), now maintained on GitHub for version control.

This pipeline allows for a test-retest reliability analysis to be completed on resting-state fMRI data. Specifically, reliability can be compared across session one and session two data by constructing functional connectivity matrices and analysing reliability across each greyordinate point (voxels/vertices). This will allow for the measurement and comparison of reliability across multi-echo and single-echo sequences.

# Analysis Pipeline:

1) RestingSnake
   - Source: https://github.com/MataiMRI/restingSnake
   - An analysis pipeline created by MataiMRI to allow for fMRIPrep to be run
   - T1-weighted outputs are of interest
   - Not included above
  
2) Tedana (Multi-echo)
   - Run tedana.sh: This will run tedana on the fMRIPrep output data (each echo from the multi-echo data)
   - Run applytedana.sh: This will apply the Tedana denoising to the optimally combined T1-weighted multi-echo fMRIPrep output
  
3) Manual ICA (Single-echo)
   - Run melodic_ICA_rs.sh: This will run MELODIC on the single-echo data
   - Manual denosing will then need to be completed. This will involve recording all noise components
   - Run remove_components_rs.sh: Noise components will need to be entered into this script. This will allow for manual denoising to be completed
  
4) Mean Grey Matter Time Series Regression:
   - Run gmtr_me.sh: Will allow for mgtr from multi-echo data
   - Run gmtr_rs.sh: Will allow for mgtr from single-echo data
  
5) CIFTIFY:
   - A Singularity container for CIFTIFY will need to be constructed using Docker: https://github.com/edickie/ciftify/blob/master/docs/01_installation.md
   - Following installation, run ciftify_recon_me.sh and ciftify_recon_rs.sh
   - Run ciftify_subject_fmri_me.sh and ciftify_subject_fmri_rs.sh
   - All fMRI data will now be in CIFTI format (surface cortical, volumetric subcortical)
   - Run cifti_smoothing.sh: Can choose your smoothing parameters as needed

6) Normalisation:
   - Run normalisation.sh: Will normalise all data

7) Functional Connectivity Matrices:
   - Functional connectivity matrices will be made, separately for multi-echo and single-echo data, for each individual
   - Run FC_matrices.sh: This will create all necessary matrices
   - Each matrix will represent the correlation of greyordinates to all other greyordinates
  
8) Reliability Analysis:
   - Run nanfix.sh: Replaces all NaN values with zero values to allow for further analysis
   - Run reliability_maps.sh: Completes pairwise correlation of each greyordinate (across session one and session two data)
  
9) Visualisation and Mean Reliability:
   - Calculating mean reliability and visualising reliability in various brain regions: Wholebrain, Cortex, subcortex, Cerebellum, Cerebellum + Subcortex, Amygdala, vmPFC
   - Run wholebrain_analysis.sh and cifti_subcortical_cerebellum.sh and cortex_subcortex.sh and amygdala.sh
   - Download Glasser Atlas: https://balsa.wustl.edu/file/3VLx
   - Run vmpfc_mask.sh: Create mask for vmPFC from Glasser Atlas
   - Run resample_vmpfc_mask.sh and vmPFC.sh: Resamples mask to match CIFTI files, calculates mean reliability
   - Run visualisation_all.sh: Creates any visual reliability maps that do not already exist from previous scripts
   - Will end up with mean reliability values and visualisations for all individuals and brain regions of interest (for single-echo and multi-echo)
  
10) Exclude Zeros:
    - For the subcortical data, zeros were automatically excluded from mean calculations (as volumetric and calculated with fsl)
    - Run exclude_zeros_final.sh: Allows for zeros to be excluded from mean calculations in cortical data
    - This is an optional step that can be included based on cortical data quality

11) Some extra stuff:
   - A link for doing group-average template overlays/parcellations and instructions: https://github.com/edickie/ciftify/blob/master/ciftify/data/HCP_S1200_GroupAvg_v1/ReleaseNotes_HCP_S1200_GroupAvg_v1.txt
   - HCP S1200 group average dataset:
   https://balsa.wustl.edu/gKm1?version=Z4B15

