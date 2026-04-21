#!/bin/bash
set -euo pipefail

# =========================================================
# Phylogenetic Codon-based Selection Analysis Pipeline
# Workflow: sequence curation → alignment → filtering → tree → codon alignment → HyPhy
# =========================================================

# ------------------------------
# ENVIRONMENT SETUP (edit as needed)
# ------------------------------
module load anaconda
source activate hyphy_env

PAL2NAL=pal2nal.pl
THREADS=12

# ------------------------------
# INPUT FILES (user-defined)
# ------------------------------
PROTEIN_REF_FASTA=protein_reference.faa
NUCLEOTIDE_REF_FASTA=cds_reference.ffn
PRODIGAL_DIR=prodigal_outputs/

# OUTPUT PREFIX
PREFIX=gene_selection_analysis

# =========================================================
# STEP 1: Extract and curate ortholog sequences
# =========================================================

# (User-defined filtering step for selecting target gene IDs)
# Output: curated protein + nucleotide datasets

awk '
BEGIN {
    while ((getline < "target_ids.txt") > 0) ids[$1]=1
}
/^>/ {
    header = substr($0,2)
    split(header, a, " ")
    keep = (a[1] in ids)
}
keep { print }
' ${PROTEIN_REF_FASTA} > ${PREFIX}_filtered.faa

# Combine nucleotide sources (reference + predicted genes)
cat ${NUCLEOTIDE_REF_FASTA} \
    ${PRODIGAL_DIR}/*.ffn > ${PREFIX}_combined.ffn

awk '
BEGIN {
    while ((getline < "target_ids.txt") > 0) ids[$1]=1
}
/^>/ {
    header = substr($0,2)
    split(header, a, " ")
    id = a[1]
    keep = (id in ids)
    if (keep && seen[id]++) keep=0
}
keep { print }
' ${PREFIX}_combined.ffn > ${PREFIX}_filtered.ffn

# =========================================================
# STEP 2: Remove redundancy
# =========================================================
conda activate seqkit

seqkit rmdup -s ${PREFIX}_filtered.faa \
    -o ${PREFIX}_nr.faa

seqkit grep -r -n -f <(grep "^>" ${PREFIX}_nr.faa | cut -d' ' -f1 | sed 's/>//') \
    ${PREFIX}_filtered.ffn \
    -o ${PREFIX}_nr.ffn

# =========================================================
# STEP 3: Protein alignment
# =========================================================
conda activate mafft_env

mafft --auto ${PREFIX}_nr.faa > ${PREFIX}_aligned.faa

# =========================================================
# STEP 4: Alignment trimming
# =========================================================
trimal -in ${PREFIX}_aligned.faa \
       -out ${PREFIX}_trimmed.faa \
       -automated1

# =========================================================
# STEP 5: Coverage filtering
# =========================================================
awk '
BEGIN {min_cov=50}
/^>/ {
    if(seq!="") {
        cov = 100 * (non_gap/len)
        if(cov >= min_cov) {
            print header
            print seq
        }
    }
    header=$0; seq=""; len=0; non_gap=0
    next
}
{
    seq = seq $0
    len += length($0)
    non_gap += gsub(/[^-]/,"")
}
END {
    if(seq!="") {
        cov = 100 * (non_gap/len)
        if(cov >= min_cov) {
            print header
            print seq
        }
    }
}
' ${PREFIX}_trimmed.faa > ${PREFIX}_filtered.faa

# filter matching nucleotide sequences
seqkit grep -r -n -f <(grep "^>" ${PREFIX}_filtered.faa | cut -d' ' -f1 | sed 's/>//') \
    ${PREFIX}_filtered.ffn \
    -o ${PREFIX}_filtered.ffn

# =========================================================
# STEP 6: Re-alignment after filtering
# =========================================================
mafft --auto ${PREFIX}_filtered.faa > ${PREFIX}_final_aligned.faa
trimal -in ${PREFIX}_final_aligned.faa \
       -out ${PREFIX}_final_trimmed.faa \
       -automated1

# =========================================================
# STEP 7: Phylogenetic tree inference
# =========================================================
iqtree2 -s ${PREFIX}_final_trimmed.faa \
        -m MFP \
        -T ${THREADS} \
        -redo

TREE=${PREFIX}_final_trimmed.faa.treefile

# optional: label branches (test vs reference)
python label_tree.py \
    -i ${TREE} \
    -o ${PREFIX}_labeled.nwk

# =========================================================
# STEP 8: Codon alignment (PAL2NAL)
# =========================================================
perl ${PAL2NAL} \
    ${PREFIX}_filtered.faa \
    ${PREFIX}_filtered.ffn \
    -output fasta > ${PREFIX}_codon.aln

# =========================================================
# STEP 9: HyPhy selection analyses
# =========================================================

source activate hyphy_env

# RELAX (selection intensity)
hyphy relax \
    --alignment ${PREFIX}_codon.aln \
    --tree ${PREFIX}_labeled.nwk \
    --test test \
    --reference reference \
    > ${PREFIX}_RELAX.out

# MEME (episodic positive selection)
hyphy meme \
    --alignment ${PREFIX}_codon.aln \
    --tree ${PREFIX}_labeled.nwk \
    > ${PREFIX}_MEME.out

# FEL (site-level pervasive selection)
hyphy fel \
    --alignment ${PREFIX}_codon.aln \
    --tree ${PREFIX}_labeled.nwk \
    > ${PREFIX}_fel.out