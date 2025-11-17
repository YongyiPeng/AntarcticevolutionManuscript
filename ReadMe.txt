# Microbial HGT & Structure-Informed Population Genetics Workflows

This repository contains workflows for **horizontal gene transfer (HGT) analysis** and **structure-informed population genetics** of microbial MAGs.

---

## 1. HGT Analysis

The HGT workflow identifies horizontal gene transfers in microbial MAGs using **MetaCHIP**.

### Scripts

**`HGT_analysis/Metachip_PI.sh`**  
- Runs MetaCHIP’s **Phylogenetic Inference (PI)** module.  
- Tasks:
  - Group input genomes at multiple taxonomic levels.
  - Construct species trees using single-copy genes.
  - Build a genome-wide BLAST database for similarity comparisons.

**`HGT_analysis/Metachip_BP.sh`**  
- Runs MetaCHIP’s **Best-Practice (BP)** module.  
- Tasks:
  - Take BLAST results and PI phylogenies to detect HGT across taxonomic levels.
  - Assign predicted HGT direction using **Best-Match + Ranger-DTL2** (donor → recipient).

---

## 2. Structure-Informed Population Genetics

This workflow uses **Anvi’o** to integrate genomic variants with predicted protein structures.

### Scripts

| Script | Description |
|--------|-------------|
| `1_anvi-gen-contigs-database.sh` | Generate Anvi’o contigs databases (`.db`) from FASTA files. Supports external gene calls (e.g., Prodigal). Can ignore internal stop codons. |
| `2_anvi-export-gene-calls.sh` | Export gene calls from contigs DB for downstream analyses. |
| `3_anvi_bowtie.sh` | Map reads to contigs using Bowtie2 and generate BAM files. `--no-unal` keeps only mapped reads; `samtools view -F 4` filters unmapped reads; initialize BAM for Anvi’o. |
| `4_anvi-profile.sh` | Profile BAM files to generate **single-profile DBs** per sample. Calculates coverage, SNVs, SCVs, SAAVs, and SVs. |
| `5_anvi-merge.sh` | Merge multiple single-profile DBs into a single **merged profile DB**. |
| `6_anvi-gen-variability-profile.sh` | Extract variant information from the merged profile DB. |
| `7_anvi-sum.sh` | Summarize coverage and variant profiles for each genome or collection. |
| `8_anvi-pnps.sh` | Calculate **pN/pS ratios** from SCVs for genes of interest. |
| `9_anvi-structure.sh` | Generate a **structure database** from predicted PDB files. |
| `10_anvi-structure_run.sh` | Run **InteracDome** for ligand-binding predictions, integrate protein structure information, export residue info or ligand-binding distances, and visualize variants on structures. |

---

### Notes
- Scripts are designed to run sequentially from contigs → BAM → profiles → variants → structure.  
- Outputs are compatible with downstream **Python/R analyses** and interactive **Anvi’o visualizations**.  
- For detailed parameter settings, see each script header or inline comments.  
- We appreciate the detailed codebase developed by Anvi’o for structure-informed microbial population genetics.

---

