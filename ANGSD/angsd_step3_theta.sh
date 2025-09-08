#!/bin/bash
#SBATCH --job-name="sfs_saf2theta"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=120:00:00
#SBATCH --mem=120gb
#SBATCH --output=saf2theta.%J.out
#SBATCH --error=saf2theta.%J.err

# ===========================================================
# ANGSD Step 3: Convert SAF + SFS → per-site theta estimates
# ===========================================================
# Input:
#   - .saf.idx (from Step 1)
#   - .sfs (from Step 2)
#
# Output (with prefix cf_crist_diploid_thetas):
#   - cf_crist_diploid_thetas.thetas.idx   # index for theta
#   - cf_crist_diploid_thetas.thetas.gz    # compressed theta values
#   - cf_crist_diploid_thetas.thetas.pos.gz # genomic positions for theta
# ===========================================================

# Environment
source ${HOME}/.bashrc
source ${HOME}/anaconda3/etc/profile.d/conda.sh
export PATH=$PATH:/calab_data/mirarab/home/dairabel

# Paths
WORKDIR=/scratch03/dairabel/angsd/finch/angsd/certhidea_fusca_espanola
SAF_IDX=${WORKDIR}/cf_espnola_diploid_output_all.saf.idx
SFS=${WORKDIR}/cf_espanola_diploid_output.sfs
ANC=/scratch03/dairabel/angsd/finch/reference/cfE7.fasta
OUT_PREFIX=${WORKDIR}/cf_espanola_diploid_thetas

cd $WORKDIR

# -----------------------------------------------------------
# Run realSFS → theta
# -----------------------------------------------------------
/calab_data/mirarab/home/dairabel/angsd/realSFS saf2theta $SAF_IDX \
    -sfs $SFS \
    -anc $ANC \
    -outname $OUT_PREFIX

echo "Done! Theta files written with prefix: $OUT_PREFIX"
