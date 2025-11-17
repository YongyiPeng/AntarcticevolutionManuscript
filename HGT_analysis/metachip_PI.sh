#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

## FILE PATHWAYS
# Enter file pathways and output directory

# Run
/home/yongyip/.local/bin/MetaCHIP PI -p Antarctic -r pcofg -t 36 -o /fs04/scratch2/rp24/yongyip/Antarctic_HGT/metachip/output -i /fs04/scratch2/rp24/yongyip/Antarctic_HGT/dRep_bins_99/dereplicated_genomes -x fa -taxon ./GTDB_classifications.tsv -force

