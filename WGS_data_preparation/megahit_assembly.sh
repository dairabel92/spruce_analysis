#!/bin/bash
#SBATCH --job-name="megahit"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=80:00:00
#SBATCH --mem=120gb
#SBATCH --output=megahit.%J.out
#SBATCH --error=megahit.%J.err

# ===========================================================
# Assembly of WGS reads with MEGAHIT
# -----------------------------------------------------------
# Install MEGAHIT:
#   GitHub: https://github.com/voutcn/megahit
#     git clone https://github.com/voutcn/megahit
#     cd megahit && make
#
#   OR via Conda:
#     conda install -c bioconda megahit
# ===========================================================

# Load conda environment
source ${HOME}/.bashrc
source ${HOME}/anaconda3/etc/profile.d/conda.sh
conda activate mega

# Move to working directory
cd /scratch01/dairabel/certhidea_fusca/genomes

# List of SRR accessions for Certhidea fusca
SAMPLES=(
  SRR1607346
  SRR1607350
  SRR1607351
  SRR1607354
  SRR1607356
  SRR1607357
  SRR1607359
  SRR1607361
  SRR1607363
  SRR1607348
)

# Run MEGAHIT on each trimmed pair
for srr in "${SAMPLES[@]}"; do
  echo "Assembling $srr ..."
  megahit \
    -1 ${srr}_1_trimmed.fastq.gz \
    -2 ${srr}_2_trimmed.fastq.gz \
    -o ${srr}_out
done


# filters:
# -1/-2 → paired-end input reads (trimmed with bbduk)
# -o ${srr}_out → each sample’s assembly is written into its own folder
