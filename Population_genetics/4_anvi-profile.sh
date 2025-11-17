#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

## FILE PATHWAYS
# Enter file pathways and output directory
SAM_dir=/fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/bowtie_all

# Run
for file in /fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/SRA/bbduk/*_1.fq.gz
do
forward=$file
reverse=${forward/_1/_2}
base="$(basename -- $forward | sed 's/_.*//')"
anvi-profile --sample-name $base --output-dir ./profile/$base -i $SAM_dir/$base'.bam-sorted.bam' -c ../prodigal/CONTIGS.db -T 20 --overwrite-output-destinations --profile-SCVs --write-buffer-size-per-thread 2000
done
