#!/bin/bash
# ===========================================================
# Adapter/quality trimming of WGS reads with bbduk.sh
# Requires skimming_scripts (https://github.com/smirarab/skimming_scripts)
# ===========================================================

BBDUK=~/skimming_scripts/bbmap/bbduk.sh

# List of SRR accessions for Certhidea fusca espanola example
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

# Loop through your SRR ids (or any IDs you reads are in)

for srr in "${SAMPLES[@]}"; do
  echo "Trimming $srr ..."
  $BBDUK \
    in1=${srr}_1.fastq.gz \
    in2=${srr}_2.fastq.gz \
    out1=${srr}_1_trimmed.fastq.gz \
    out2=${srr}_2_trimmed.fastq.gz \
    ref=adapters,phix \
    ktrim=r \
    k=23 \
    mink=11 \
    hdist=1 \
    tpe tbo \
    qtrim=rl \
    trimq=20
done

echo "All samples trimmed ready for next step!"

# filters:
# ref=adapters,phix → remove Illumina adapters + phiX control
# ktrim=r → trim adapters from the right end of reads
# k=23, mink=11 → use 23-mers, allow shorter 11-mers at read ends
# hdist=1 → allow 1 mismatch in kmer matches
# tpe tbo → trim both reads equally + trim based on pair overlap
# qtrim=rl → quality-trim both ends (right & left)
# trimq=20 → clip low-quality tails (bases < Q20)
