#!/bin/bash
#SBATCH --job-name="angsd_mapping"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --time=48:00:00
#SBATCH --mem=80gb
#SBATCH --output=angsd_mapping.%J.out
#SBATCH --error=angsd_mapping.%J.err

# ===========================================================
# ANGSD pipeline: Map trimmed reads to reference (finches)
# ===========================================================
# Population: Certhidea fusca (Espanola, n=10)
# Reference: cfE7
#
# Steps:
#   1. Index reference genome
#   2. Map paired-end trimmed reads with BWA mem
#   3. Convert SAM → BAM
#   4. Sort BAMs
#   5. Create bamlist.txt with absolute paths
# ===========================================================

# Paths
REF=/scratch00/dairabel/finch/certhidea_fusca/espanola/genomes/cfE7/cfE7.fasta
READ_DIR=/scratch00/dairabel/finch/certhidea_fusca/espanola
OUT_DIR=/scratch03/dairabel/angsd/finch/reads_mapped/certhidea_fusca_espanola

mkdir -p $OUT_DIR

# -----------------------------------------------------------
# Step 1: Index the reference genome
# -----------------------------------------------------------
echo "Indexing reference genome..."
bwa index $REF
samtools faidx $REF

# -----------------------------------------------------------
# Step 2–4: Map reads, convert SAM → BAM, sort BAM
# -----------------------------------------------------------
for srr in SRR1607346 SRR1607350 SRR1607351 SRR1607354 SRR1607356 SRR1607357 SRR1607359 SRR1607361 SRR1607363 SRR1607348
do
    echo "Processing $srr..."

    fq1=${READ_DIR}/${srr}/*_1_trimmed.fastq.gz
    fq2=${READ_DIR}/${srr}/*_2_trimmed.fastq.gz

    SAM=${OUT_DIR}/${srr}_mapped.sam
    BAM=${OUT_DIR}/${srr}_mapped.bam
    SORTED_BAM=${OUT_DIR}/${srr}_mapped.sorted.bam

    # Map with BWA MEM
    bwa mem -t 8 $REF $fq1 $fq2 > $SAM

    # Convert SAM → BAM
    samtools view -bS $SAM > $BAM

    # Sort BAM
    samtools sort -o $SORTED_BAM $BAM

    # Index sorted BAM
    samtools index $SORTED_BAM

done

# -----------------------------------------------------------
# Step 5: Create bamlist.txt with absolute paths
# -----------------------------------------------------------
echo "Creating bamlist.txt..."
(
    cd $OUT_DIR
    ls $PWD/*_mapped.sorted.bam > bamlist.txt
)

echo "All done! BAMs and bamlist ready for ANGSD."
