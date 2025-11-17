#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

# Run
cd /fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas

TXT_DIR="/fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/bowtie/"
OUTPUT_DIR="./merge/"

for txt_file in ${TXT_DIR}SRR*.txt; do
    filename=$(basename "$txt_file")
    
    sample_id="${filename%.txt}"

    anvi-gen-variability-profile -c ./prodigal/CONTIGS.db \
                                 -p ./merge/PROFILE.db \
                                 --engine NT \
                                 --include-site-pnps \
                                 -o "${OUTPUT_DIR}SNVs_${sample_id}.txt" \
                                 -C DEFAULT \
                                 --b EVERYTHING \
                                 --samples-of-interest "$txt_file"

    anvi-gen-variability-profile -c ./prodigal/CONTIGS.db \
                                 -p ./merge/PROFILE.db \
                                 --engine AA \
                                 --kiefl-mode \
                                 -o "${OUTPUT_DIR}SAAVs_${sample_id}.txt" \
                                 -C DEFAULT \
                                 --b EVERYTHING \
                                 --samples-of-interest "$txt_file"

    anvi-gen-variability-profile -c ./prodigal/CONTIGS.db \
                                 -p ./merge/PROFILE.db \
                                 --engine CDN \
                                 --include-site-pnps \
                                 --kiefl-mode \
                                 -o "${OUTPUT_DIR}SCVs_${sample_id}.txt" \
                                 -C DEFAULT \
                                 --b EVERYTHING \
                                 --samples-of-interest "$txt_file"

done
