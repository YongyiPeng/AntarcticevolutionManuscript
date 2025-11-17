#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

# Run
export PATH=/fs04/rp24/yongyip/miniconda/conda/envs/dssp/bin:$PATH
export LD_LIBRARY_PATH=/fs04/rp24/yongyip/miniconda/conda/envs/dssp/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/fs04/rp24/yongyip/Database/boost_1_73_0/stage/lib/:$LD_LIBRARY_PATH

cd /fs03/rp24/yongyip/Antarctic_HGT/anvio/Tracegas
anvi-gen-structure-database -c ./prodigal/CONTIGS.db --external-structures ./Structure/nife_metachip/nife_structure_metachip.txt --num-threads 12 -o ./Structure/nife_metachip/STRUCTURE.db
