#!/bin/sh

# pipeline for differential expression analysis

# fastqc
for i in */*.fq.gz; do fastqc $i; done

# multiQC
# mkdir then mv all fastqc.zip files into the out folder
mkdir fastqc_out_folder
for i in */*.zip; do cp $i fastqc_out_folder/; done
bash ~/aspergillus_project/scripts/multiQC
