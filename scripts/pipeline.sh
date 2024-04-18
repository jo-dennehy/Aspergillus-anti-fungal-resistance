#!/bin/sh

# pipeline for differential expression analysis

# fastqc
for i in */*.fq.gz; do fastqc $i; done

# multiQC
# mkdir then mv all fastqc.zip files into the out folder
mkdir fastqc_out_folder
for i in */*.zip; do cp $i fastqc_out_folder/; done
bash ~/aspergillus_project/scripts/multiQC

# Unzip all of the .fq.gz files for cutadapt step
for i in */*.fq.gz; do gunzip $i; done

# CutAdapt
# Quality and adapter trimming
for i in ./*/; do (cd '$i' && cutadapt -a GATCGGAAGAGCACACGTCTGAACTCCAGTCACGGATGACTATCTCGTATGCCGTCTTCTGCTTG -q 30 -O 10 -n 3 -m 25 -o out1_trimmed.fastq -p out2_trimmed.fastq *1.fq *2.fq); done

# FastQC on the trimmed reads
for i in */*_trimmed.fastq; do fastqc $i; done

# Run rename.py so that names don't overwrite themselves in multiQC
python ~/aspergillus_project/scripts/rename.py

# multiQC on the trimmed reads
mkdir trimmed_fastqc_out_folder
for i in */*trimmed_fastqc.zip; do cp $i fastqc_out/trimmed_fastqc_out_folder/; done
bash ~/aspergillus_project/scripts/multiQC

# Hisat2 index reference.fasta files (reference from ensembl)
hisat2-build Aspergillus_fumigatus.ASM265v1.dna_sm.toplevel.fa genomic_ref

# Hisat2 for alignment
#hisat2 -x ../../genomic_ref -1 NaCl_0_NT_A_EKRN230050117-1A_H7MFJDSX7_L3_1.fq -2 NaCl_0_NT_A_EKRN230050117-1A_H7MFJDSX7_L3_2.fq -S alignment.sam
for i in ./*/; do (cd "$i" && [ -e *1_trimmed.fastq ] && [ -e *2_trimmed.fastq ] && hisat2 -x ../../genomic_ref -1 *1_trimmed.fastq -2 *2_trimmed.fastq -S alignment.sam); done


# Samtools to change .sam output to .bam
# get samtools to give some count stats  coverage
samtools view -bS -o alignment.bam alignment.sam
for i in ./*/; do if [ -f "$i/alignment.sam" ]; then (cd "$i" && samtools view -bS -o alignment.bam alignment.sam); fi; done

# Sort .bam file ---optional
for i in ./*/; do if [ -f "$i/alignment.bam" ]; then (cd "$i" && samtools sort -o alignment_sorted.bam alignment.bam); fi; done

# Index bam file
for i in ./*/; do if [ -f "$i/alignment.bam" ]; then (cd "$i" && samtools index alignment_sorted.bam); fi; done

# Get .gtf file from ensembl

# htseq-counts
for i in ./*/; do (cd "$i" && htseq-count -f bam -r pos -s reverse -t exon -i gene_id -a 10 -m union --additional-attr gene_name alignment_sorted.bam ../PATH/TO/REFERENCE.gtf > counts.txt); done



