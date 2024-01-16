#!/bin/sh

# pipeline for differential expression analysis

# fastqc
for i in */*.fq.gz; do fastqc $i; done

# multiQC
# mkdir then mv all fastqc.zip files into the out folder
mkdir fastqc_out_folder
for i in */*.zip; do cp $i fastqc_out_folder/; done
bash ~/aspergillus_project/scripts/multiQC

# CutAdapt
# Quality and adapter trimming
cutadapt -a GATCGGAAGAGCACACGTCTGAACTCCAGTCACGGATGACTATCTCGTATGCCGTCTTCTGCTTG -g AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT -q 30 -O 10 -n 3 -m 25 -o out1.fastq -p out2.fastq *1.fq *2.fq

# FastQC again

# Hisat2 index files
hisat2-build GCF_000002655.1_ASM265v1_genomic.fna genomic_ref

# Hisat2 for alignment
