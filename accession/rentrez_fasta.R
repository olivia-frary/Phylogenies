# Load required libraries
library(rentrez)
library(seqinr)
library(ape)
library(janitor)
library(tidyverse)

# Function to fetch sequences from GenBank
fetch_sequences <- function(accession_numbers) {
  # Convert the accession numbers to a comma-separated string
  accession_str <- paste(accession_numbers, collapse = ",")
  # redundant code to get the sequence names
  gene_sequences <- read.GenBank(accession_numbers)
  # accession number corresponding to species names/gene
  species_names <- paste(attr(gene_sequences, "species"), names(gene_sequences), sep=" coi ")
  species_names <- species_names[1:length(gene_sequences)]
  # Fetch the sequences from GenBank
  handle <- entrez_fetch(db = "nucleotide", id = accession_str, rettype = "fasta", retmode = "text")
  # Read the sequences
  sequences <- read.fasta(file = textConnection(handle))
  return(list(sequences = sequences, species_names = species_names))
}

# List of accession numbers
df <- read_csv("accession/diptera_accession_numbers.csv") %>% 
  clean_names()
accession_numbers <- df$coi_acc[!is.na(df$coi_acc)]

# Fetch sequences
result <- fetch_sequences(accession_numbers)

# Write sequences to a FASTA file
write.fasta(result$sequences, names = result$species_names, file = "accession/rentrez_output.fasta", open = "w")


# I do not like that both entrez and read.Genbank are being used. I should be 
# able to pull the sequences just from the read.Genbank DNAbin output

# started having connection errors
#### other stuff to try ####
library(refseqR)

save_CDSfasta_from_xms(accession_numbers, "diptera_accession")
