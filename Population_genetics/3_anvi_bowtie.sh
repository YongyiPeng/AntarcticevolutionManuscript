#!/bin/bash

# Load in modules or activate suitable conda environment
module load anaconda/2019.03-Python3.7-gcc5
export CONDA_ENVS=/fs04/rp24/yongyip/miniconda/conda/envs
source activate $CONDA_ENVS/anvio-8

## FILE PATHWAYS
# Enter file pathways and output directory
output_dir=/fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/bowtie_all
prodigal_dir=/fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/prodigal

# Run
cd /fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/prodigal

bowtie2-build $prodigal_dir/combined_676_clean.fa ./combined_676_clean.fa

for file in /fs04/scratch2/rp24/oldscratch/yongyip/Antarctic_HGT/anvio/Tracegas/SRA/bbduk/*_processed_1.fq.gz
do
forward=$file
reverse=${forward/_1/_2}
base="$(basename -- $forward | sed 's/_.*//')"
bowtie2 --no-unal -p 18 -x ./combined_676_clean.fa -1 $forward -2 $reverse > $output_dir/"$base".sam
samtools view -@ 66 -F 4 -b $output_dir/"$base".sam -o $output_dir/"$base".bam
anvi-init-bam $output_dir/"$base".bam -T 18
done
