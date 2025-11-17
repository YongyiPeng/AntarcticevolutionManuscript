#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

## FILE PATHWAYS
# Enter file pathways and output directory
export TMPDIR=/fs03/rp24/yongyip/Antarctic_HGT/anvio/Tracegas/tmp
output_dir=/fs04/scratch2/rp24/yongyip/Antarctic_HGT/anvio/

# Run
cd /fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/prodigal
anvi-gen-contigs-database -f ./combined_676_clean.fa -n Antarctic -o ./CONTIGS.db --external-gene-calls combined_676_new_fixed.tsv -T 18 --ignore-internal-stop-codons
