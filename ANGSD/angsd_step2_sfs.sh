#!/bin/bash
#SBATCH --job-name="angsd_sfs"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=120:00:00
#SBATCH --mem=120gb
#SBATCH --output=angsd_sfs.%J.out
#SBATCH --error=angsd_sfs.%J.err

# ===========================================================
# ANGSD Step 2: Estimate the Site Frequency Spectrum (SFS)
# ===========================================================
# Input: .saf.idx file from ANGSD Step 1
# Output: .sfs file containing the site frequency spectrum
# ===========================================================

# Environment
source ${HOME}/.bashrc
source ${HOME}/anaconda3/etc/profile.d/conda.sh
export PATH=$PATH:/calab_data/mirarab/home/dairabel

# Paths
WORKDIR=/scratch03/dairabel/angsd/finch/angsd/certhidea_fusca_espanola
SAF_IDX=${WORKDIR}/cf_espanola_diploid_output_all.saf.idx
OUT_SFS=${WORKDIR}/cf_espanola_diploid_output.sfs

cd $WORKDIR

# -----------------------------------------------------------
# Run realSFS
# -----------------------------------------------------------
/calab_data/mirarab/home/dairabel/angsd/realSFS $SAF_IDX -P 12 > $OUT_SFS

echo "Done! SFS written to: $OUT_SFS"
