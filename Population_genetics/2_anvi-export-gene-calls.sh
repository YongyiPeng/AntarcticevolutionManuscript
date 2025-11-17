#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

## FILE PATHWAYS
# Enter file pathways and output directory
export TMPDIR=/fs03/rp24/yongyip/Antarctic_HGT/anvio
output_dir=/fs03/rp24/yongyip/Antarctic_HGT/anvio

# Run
cd /fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/prodigal
anvi-export-gene-calls -c CONTIGS.db  -o gene_calls.txt --gene-caller prodigal
