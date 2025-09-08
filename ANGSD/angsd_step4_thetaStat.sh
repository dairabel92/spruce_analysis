#!/bin/bash
#SBATCH --job-name="thetaStat"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=24:00:00
#SBATCH --mem=40gb
#SBATCH --output=thetaStat.%J.out
#SBATCH --error=thetaStat.%J.err

# ===========================================================
# ANGSD Step 4: Summarize theta estimates with thetaStat
# ===========================================================
# Input:
#   - cf_espanola_diploid_thetas.thetas.idx
#
# Output:
#   - cf_espanola_diploid_thetas.thetas.idx.pestPG   # site-wise theta stats
#   - Global average Tajima's Pi (from awk command)
#   - cf_espanola_thetas_windows.pestPG              # windowed estimates
# ===========================================================

# Environment
source ${HOME}/.bashrc
source ${HOME}/anaconda3/etc/profile.d/conda.sh
export PATH=$PATH:/calab_data/mirarab/home/dairabel

# Paths
WORKDIR=/scratch03/dairabel/angsd/finch/angsd/certhidea_fusca_espanola
IDX=${WORKDIR}/cf_espanola_diploid_thetas.thetas.idx

cd $WORKDIR

# -----------------------------------------------------------
# 1. Global stats across all sites
# -----------------------------------------------------------
# We follow this approach because it uses ALL sites together.
# This avoids biases that can arise when data are partitioned
# into arbitrary windows.
#
/calab_data/mirarab/home/dairabel/angsd/thetaStat do_stat $IDX

# This produces:
#   cf_espanola_diploid_thetas.thetas.idx.pestPG

# Calculate average Tajima's Pi (column 5) across all sites
awk '{if (NR>1) {sum+=$5; totalSites+=$NF}} \
     END {print "Average Tajima Pi (diploid, Certhidea fusca, Espanola):", sum/totalSites}' \
     cf_espanola_diploid_thetas.thetas.idx.pestPG

###YAY tis the output we desire and one we utilize in manuscript
#
#
# -----------------------------------------------------------
# 2. Windowed estimates (optional)
# -----------------------------------------------------------
# Window-based estimates (-win / -step) can be useful for
# local patterns, but depending on window and step size,
# you may see different values. This is because ANGSD
# discards contigs shorter than the window size, which
# effectively removes data.
#
/calab_data/mirarab/home/dairabel/angsd/thetaStat do_stat $IDX \
    -win 50000 -step 10000 \
    -outnames cf_espanola_thetas_windows

# This produces:
#   cf_espanola_thetas_windows.pestPG   # window-based estimates of theta

