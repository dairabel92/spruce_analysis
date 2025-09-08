#!/bin/bash
# ===========================================================
# Assembly QC with BBMap stats.sh
# -----------------------------------------------------------
# This script runs stats.sh on MEGAHIT assemblies (final.contigs.fa)
# to generate summary stats per sample, including:
#   - total contigs
#   - assembly length
#   - N50 / L50
#   - max contig length
#   - GC content
#
# Requires: skimming_scripts (https://github.com/smirarab/skimming_scripts)
# ===========================================================

# List of SRR accessions for Certhidea fusca espanola
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

# Run stats.sh on each assembly
for srr in "${SAMPLES[@]}"; do
  echo "Generating assembly stats for $srr ..."
  /Users/dairabel/skimming_scripts/bbmap/stats.sh \
    ${srr}_out/final.contigs.fa \
    > ${srr}_assembly_stats.txt
done

echo "Assembly stats done"

