# spruce_analysis

This repository contains the data processing workflows and analysis scripts used in the SPrUCE manuscript. It documents the steps required to reproduce the analyses presented in the study, including whole genome sequencing (WGS) data preparation, ultraconserved element (UCE) extraction, genome-wide nucleotide diversity estimation using ANGSD, SPrUCE-based nucleotide diversity analyses, and generation of manuscript figures.

This repository focuses on documenting and organizing the processing steps used in the manuscript. Raw sequencing data are not stored here.

## Repository Structure

- WGS_data_preparation/
  Contains scripts and workflows used to prepare whole genome sequencing data, including read preprocessing and UCE extraction.

- ANGSD/
  Contains the full ANGSD workflow used to compute genome-wide nucleotide diversity estimates. The pipeline includes:
  - SAF generation
  - Site Frequency Spectrum (SFS) estimation
  - Theta calculation
  - Theta statistics

- spruce/
  Contains scripts used to run SPrUCE and compute UCE-based nucleotide diversity estimates.

- R_figures/
  Contains R scripts used to generate manuscript figures, including correlation analyses between ANGSD and SPrUCE diversity estimates.

## Reproducing the Analyses

To reproduce the analyses described in the manuscript:

1. Prepare WGS data using scripts in WGS_data_preparation/
2. Run the ANGSD workflow in ANGSD/ to obtain genome-wide nucleotide diversity estimates
3. Run SPrUCE analyses using scripts in spruce/
4. Generate figures using scripts in R_figures/

File paths and sample names may need to be adjusted depending on your computing environment.
