#!/bin/bash
# ===========================================================
# Prepare FASTA files from MEGAHIT assemblies for UCE pipeline
# -----------------------------------------------------------
# Converts *.final.contigs.fa -> *.fasta
#   - strips "name" and "description" fields from headers
#   - keeps only clean IDs
#
# Requires:
#   - Python with Biopython
#   - faToTwoBit for conversion
# ===========================================================

PYTHON=/calab_data/mirarab/home/dairabel/anaconda3/envs/uce_prep39/bin/python

# Certhidea fusca (Espanola) SRR IDs
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

# Loop through each assembly and rewrite FASTA
for srr in "${SAMPLES[@]}"; do
  echo "Processing ${srr}.final.contigs.fa -> ${srr}.fasta"
  $PYTHON - <<EOF
from Bio import SeqIO

with open("${srr}.final.contigs.fa", "rU") as infile, open("${srr}.fasta", "w") as outf:
    for seq in SeqIO.parse(infile, "fasta"):
        seq.name = ""
        seq.description = ""
        outf.write(seq.format("fasta"))
EOF
done

# -----------------------------------------------------------
# Convert cleaned .fasta files to .2bit (faToTwoBit)
# -----------------------------------------------------------
cd /scratch00/dairabel/finch/certhidea_fusca/espanola/genomes

for fasta in *.fasta; do
  critter="${fasta%.*}"
  echo "Converting $fasta -> $critter.2bit"
  faToTwoBit "$critter/$critter.fasta" "$critter/${critter}.2bit"
done
