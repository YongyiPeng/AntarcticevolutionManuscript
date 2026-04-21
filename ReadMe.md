# Integrated Workflows for HGT, Structure-Informed Population Genetics, and Codon-Based Selection in Microbial MAGs

This repository contains workflows for **horizontal gene transfer (HGT) analysis**, **structure-informed population genetics** and **phylogenetic codon-based selection analysis** of microbial MAGs.

---

## 1. HGT Analysis

The HGT workflow identifies horizontal gene transfers in microbial MAGs using **MetaCHIP**.

### Scripts

**`HGT_analysis/Metachip_PI.sh`**  
- Runs MetaCHIP’s **PI** module.  
- Tasks:
  - Group input genomes at multiple taxonomic levels.
  - Construct species trees using single-copy genes.
  - Build a genome-wide BLAST database for similarity comparisons.

**`HGT_analysis/Metachip_BP.sh`**  
- Runs MetaCHIP’s **BP** module.  
- Tasks:
  - Take BLAST results and PI phylogenies to detect HGT across taxonomic levels.
  - Assign predicted HGT direction using **Best-Match + Ranger-DTL2** (donor → recipient).

---

## 2. Structure-Informed Population Genetics

This workflow uses **Anvi’o** to integrate genomic variants with predicted protein structures.

### Scripts Overview

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
- We appreciate the detailed codebase developed by **Anvi’o** for structure-informed microbial population genetics.

---

### Recommended Workflow

1. **Generate contigs database** → `1_anvi-gen-contigs-database.sh`  
2. **Export gene calls** → `2_anvi-export-gene-calls.sh`  
3. **Map reads and generate BAM** → `3_anvi_bowtie.sh`  
4. **Profile each BAM** → `4_anvi-profile.sh`  
5. **Merge profiles** → `5_anvi-merge.sh`  
6. **Extract variant info** → `6_anvi-gen-variability-profile.sh`  
7. **Summarize coverage/variants** → `7_anvi-sum.sh`  
8. **Calculate pN/pS ratios** → `8_anvi-pnps.sh`  
9. **Generate structure database** → `9_anvi-structure.sh`  
10. **Ligand-binding predictions and visualization** → `10_anvi-structure_run.sh`  

---

## 2. Phylogenetic Codon-based Selection Analysis

This workflow uses **HyPhy** to perform codon-level evolutionary selection analyses (e.g., episodic diversifying selection, relaxed selection, and site-level selection) on microbial genes based on phylogenetic frameworks.

### Scripts Overview

| Script | Description |
|--------|-------------|
| `HyPhy.sh` | Codon-based selection analysis using HyPhy (MEME, FEL, RELAX) on phylogenetic alignments. |

---

### References

- [MetaCHIP Documentation](https://github.com/songweizhi/MetaCHIP)  
- [Anvi’o Structure Module](https://merenlab.org/data/anvio-structure/chapter-III/)  
- [Anvi’o Documentation](https://merenlab.org/software/anvio/)
- [HyPhy Documentation](https://hyphy.org/)

---

### Acknowledgements
We acknowledge the developers of MetaCHIP, Anvi’o, and HyPhy for providing open-source tools and detailed documentation used in this workflow.
