#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

# Run
cd /fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/
anvi-get-pn-ps-ratio -V SCVs_RSA.txt -c ./CONTIGS.db --min-departure-from-consensus 0.04 --min-coverage 20 --minimum-num-variants 10 --comparison popular_consensus --pivot -o PNPS 