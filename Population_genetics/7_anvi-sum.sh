#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

## FILE PATHWAYS
# Enter file pathways and output directory
export TMPDIR=/fs03/rp24/yongyip/Antarctic_HGT/anvio/Tracegas/tmp
output_dir=/fs03/rp24/yongyip/Antarctic_HGT/anvio/Tracegas

# Run
cd /fs03/rp24/yongyip/Antarctic_HGT/anvio/Tracegas

anvi-summarize -c ./prodigal/CONTIGS.db -p ./merge/PROFILE.db -C DEFAULT -o SUMMARY --init-gene-coverages