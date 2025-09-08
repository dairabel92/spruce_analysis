#!/bin/bash
#SBATCH --job-name="phyluce_pipeline"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=100:00:00
#SBATCH --mem=120gb
#SBATCH --output=phyluce.%J.out
#SBATCH --error=phyluce.%J.err

# ===========================================================
# PHYLuce pipeline for UCE extraction (Certhidea fusca, Espanola)
# ===========================================================
# Installation with Conda:
#   conda create -n phyluce-1.7.* -c conda-forge -c bioconda phyluce=1.7.*
#   conda activate phyluce-1.7.*
#
# Probe sets (FASTA) can be downloaded from:
#   http://ultraconserved.org
#   For finches: Tetrapods-UCE-5Kv1.fasta
#
# Input:
#   - cfE1–cfE10 genome assemblies (fasta and .2bit format)
#   - probe file: Tetrapods-UCE-5Kv1.fasta
# Output:
#   - UCE contigs with 400 bp and 750 bp flanks
#   - aligned UCEs ready for SPrUCE
# ===========================================================

# -----------------------------------------------------------
# Step 1: Run LASTZ across all genomes
# -----------------------------------------------------------
phyluce_probe_run_multiple_lastzs_sqlite \
    --db /tmp/finch_certhidea_fusca_espanola.sqlite \
    --output espanola-lastz \
    --probefile ../../../Tetrapods-UCE-5Kv1.fasta \
    --scaffoldlist cfE1 cfE2 cfE3 cfE4 cfE5 cfE6 cfE7 cfE8 cfE9 cfE10 \
    --genome-base-path ../genomes \
    --identity 50 \
    --cores 12

# -----------------------------------------------------------
# Step 2: Create scaffold configuration file (certhidea_espanola.conf)
# -----------------------------------------------------------
# Example certhidea_espanola.conf:
#
# [scaffolds]
# cfE1:/scratch00/dairabel/finch/certhidea_fusca/espanola/genomes/cfE1/cfE1.2bit
# cfE2:/scratch00/dairabel/finch/certhidea_fusca/espanola/genomes/cfE2/cfE2.2bit
# ...
# cfE10:/scratch00/dairabel/finch/certhidea_fusca/espanola/genomes/cfE10/cfE10.2bit

# -----------------------------------------------------------
# Step 3: Slice probes with 400 bp and 750 bp flanking regions
# -----------------------------------------------------------
phyluce_probe_slice_sequence_from_genomes \
    --conf certhidea_espanola.conf \
    --lastz espanola-lastz \
    --output espanola-fasta-400 \
    --flank 400 \
    --name-pattern "Tetrapods-UCE-5Kv1.fasta_v_{}.lastz.clean"

phyluce_probe_slice_sequence_from_genomes \
    --conf certhidea_espanola.conf \
    --lastz espanola-lastz \
    --output espanola-fasta-750 \
    --flank 750 \
    --name-pattern "Tetrapods-UCE-5Kv1.fasta_v_{}.lastz.clean"

# -----------------------------------------------------------
# Step 4: Match contigs to probes
# -----------------------------------------------------------
phyluce_assembly_match_contigs_to_probes \
    --contigs espanola-fasta-400 \
    --probes ../../../Tetrapods-UCE-5Kv1.fasta \
    --output /tmp/certhidea_espanola_400_lastz \
    --min-coverage 67

phyluce_assembly_match_contigs_to_probes \
    --contigs espanola-fasta-750 \
    --probes ../../../Tetrapods-UCE-5Kv1.fasta \
    --output /tmp/certhidea_espanola_750_lastz \
    --min-coverage 67

# -----------------------------------------------------------
# Step 5: Create taxon set configuration (taxon-set.conf)
# -----------------------------------------------------------
# Example taxon-set.conf:
#
# [all]
# cfE1
# cfE2
# cfE3
# cfE4
# cfE5
# cfE6
# cfE7
# cfE8
# cfE9
# cfE10

# -----------------------------------------------------------
# Step 6: Get match counts
# -----------------------------------------------------------
phyluce_assembly_get_match_counts \
    --locus-db /tmp/certhidea_espanola_400_lastz/probe.matches.sqlite \
    --taxon-list-config taxon-set.conf \
    --taxon-group 'all' \
    --output ../probe-espanola/taxon-sets/espanola_400.conf \
    --incomplete-matrix

phyluce_assembly_get_match_counts \
    --locus-db /tmp/certhidea_espanola_750_lastz/probe.matches.sqlite \
    --taxon-list-config taxon-set.conf \
    --taxon-group 'all' \
    --output ../probe-espanola/taxon-sets/espanola_750.conf \
    --incomplete-matrix

# -----------------------------------------------------------
# Step 7: Extract FASTAs from match counts
# (must run inside taxon-sets directory)
# -----------------------------------------------------------
phyluce_assembly_get_fastas_from_match_counts \
    --contigs ../espanola-fasta-400 \
    --locus-db /tmp/certhidea_espanola_400_lastz/probe.matches.sqlite \
    --match-count-output espanola_400.conf \
    --output espanola_400.fasta \
    --incomplete-matrix espanola_400.incomplete

phyluce_assembly_get_fastas_from_match_counts \
    --contigs ../espanola-fasta-750 \
    --locus-db /tmp/certhidea_espanola_750_lastz/probe.matches.sqlite \
    --match-count-output espanola_750.conf \
    --output espanola_750.fasta \
    --incomplete-matrix espanola_750.incomplete

# -----------------------------------------------------------
# Step 8: Align with MAFFT
# -----------------------------------------------------------
# Note: phyluce_align_seqcap_align aligns UCE loci with MAFFT.
#   By default, edge trimming is done.
# -----------------------------------------------------------

phyluce_align_seqcap_align \
    --input espanola_400.fasta \
    --output espanola-mafft-400 \
    --taxa 10 \
    --incomplete-matrix \
    --cores 8 \
    --output-format fasta

phyluce_align_seqcap_align \
    --input espanola_750.fasta \
    --output espanola-mafft-750 \
    --taxa 10 \
    --incomplete-matrix \
    --cores 8 \
    --output-format fasta

# ===========================================================
# YAY! now we have UCE alignments with 400 bp and 750 bp flanks.
# These MAFFT alignments are the inputs to SPrUCE.
# ===========================================================

