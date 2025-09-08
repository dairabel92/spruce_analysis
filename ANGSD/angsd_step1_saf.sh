#!/bin/bash
#SBATCH --job-name="angsd_saf"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=80:00:00
#SBATCH --mem=120gb
#SBATCH --output=angsd_saf.%J.out
#SBATCH --error=angsd_saf.%J.err

# ===========================================================
# ANGSD Step 1: Site allele frequency likelihoods
# ===========================================================
# Input: bamlist.txt (sorted + indexed BAM files)
# Reference: cfE7 (Certhidea fusca, Espanola)
# Output: .saf.idx (input for realSFS)
# ===========================================================

# Environment
source ${HOME}/.bashrc
source ${HOME}/anaconda3/etc/profile.d/conda.sh
export PATH=$PATH:/calab_data/mirarab/home/dairabel

# Paths
WORKDIR=/scratch03/dairabel/angsd/finch/angsd/certhidea_fusca_espanola
REF=/scratch00/dairabel/finch/certhidea_fusca/espanola/genomes/cfE7/cfE7.fasta
BAMLIST=$WORKDIR/bamlist.txt

cd $WORKDIR

# -----------------------------------------------------------
# Run ANGSD
# -----------------------------------------------------------
/calab_data/mirarab/home/dairabel/angsd/angsd \
    -b $BAMLIST \                     # bamlist file with absolute paths
    -anc $REF \                       # ancestral/reference genome
    -out cf_espanola_diploid \         # prefix for output files
    -doSaf 1 \                        # calculate SAF
    -GL 1 \                           # genotype likelihood model (SAMtools)
    -doCounts 1 \                     # count data
    -doMajorMinor 1 \                 # infer major/minor alleles
    -uniqueOnly 1 \                   # use only uniquely mapping reads
    -remove_bads 1 \                  # remove bad reads
    -only_proper_pairs 1 \            # keep only properly paired reads
    -minMapQ 20 \                     # minimum mapping quality
    -minQ 20 \                        # minimum base quality
    -P 12                             # number of threads
