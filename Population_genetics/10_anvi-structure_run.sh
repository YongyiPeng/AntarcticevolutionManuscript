#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

# Run
cd /fs03/rp24/yongyip/Antarctic_HGT/anvio/Tracegas
anvi-run-interacdome -c ./prodigal/CONTIGS.db --min-binding-frequency 0.5 -O ./Structure/nife_metachip/INTERACDOME --just-do-it

anvi-export-misc-data -c ./prodigal/CONTIGS.db -t amino_acids  -D InteracDome -o binding_freqs.txt

anvi-display-structure -c ./prodigal/CONTIGS.db -p PROFILE.db -s ./Structure/nife_metachip/STRUCTURE.db --gene-caller-ids 316595 --SCVs-only --samples-of-interest soi
