library(ape)
library(seqinr)
library(janitor)
library(tidyverse)

# read in your file of accession numbers to feed into script
df <- read_csv("accession/accession_numbers.csv") %>% 
  clean_names()

gene_accession_numbers <- df$coi_acc[!is.na(df$coi_acc)]

# Fetching the sequences from GenBank
gene_sequences <- read.GenBank(gene_accession_numbers)
# creates a list of DNAbin 

# accession number corresponding to species names/gene
gene_sequences_GenBank_IDs <- paste(attr(gene_sequences, "species"), names(gene_sequences), sep=" coi ")
# this is creating a list that is too long to match the accession number list

# Write the sequences to a FASTA file 
write.dna(gene_sequences, file = "accession/coi.fasta", format = "fasta", append = FALSE)

# Read the sequences from the FASTA file
gene_seq_format <- read.FASTA(file = "accession/coi.fasta")

# Modify the names of the sequences
names(gene_seq_format) <- gene_sequences_GenBank_IDs

# Write sequences to a new FASTA file 
write.FASTA(gene_seq_format, file = "accession/coi_seq_format.fasta")

# this output a nice multi fasta, I just don't know for sure if I have all the species I'm aiming for

