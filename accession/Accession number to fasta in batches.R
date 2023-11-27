library(ape)
library(seqinr)
library(janitor)
library(tidyverse)

# Read CSV file into a data frame
df <- read_csv("accession/accession_numbers.csv") %>% 
  clean_names()

# Create a vector to store accession numbers
accession_numbers <- df$coi_acc[!is.na(df$coi_acc)] # excludes NAs

# Define the batch size 
batch_size <- 300

# Calculate the total number of batches
num_batches <- ceiling(length(accession_numbers) / batch_size) 
# ceiling rounds up

# Fetch sequences for each batch and store them in separate FASTA files
for (batch_number in 1:num_batches) {
  # Calculate the indices for the current batch
  start_index <- (batch_number - 1) * batch_size + 1
# ''' Subtracts to adjust for zero-based indexing. Multiply to determine starting
# position in current batch. Add to ensure starting position is inclusive'''
  end_index <- min(batch_number * batch_size, length(accession_numbers))
# ''' Multiply to calculate where the batch would end if the batch is to 
# the specified size. Length is total number of accession numbers. Min 
# selects smaller of two values (ensures last batch does not go beyond)'''
  
  # Extract the accession numbers for the current batch
  current_batch <- accession_numbers[start_index:end_index]
  
  # Fetch sequences from GenBank for the current batch
  coi_sequences <- read.GenBank(current_batch)
# '''Change this to whatever gene you want'''
  
  # Define the output file name for this batch
  output_file <- paste0("coi_batch_", batch_number, ".fasta")
  # '''the batch number will be used for combining the files'''
  
  # Write the sequences to the batch-specific FASTA file
  write.dna(coi_sequences, file = output_file, format = "fasta", append = FALSE)
}
#### Combining files ####

# Create a list of batch FASTA files
#finds files in working directory with the pattern gene name + batch number + .fasta
batch_files <- list.files(pattern = "coi_batch_\\d+\\.fasta")


# Create a new file for the combined sequences
combined_file <- "combined_coi.fasta"

# Open the combined file for writing
combined_file_conn <- file(combined_file, "w")

# Iterate through the batch files and combine them
for (batch_file in batch_files) {
  # Read the content of the batch file
  batch_content <- readLines(batch_file)
  
  # Write the content to the combined file
  writeLines(batch_content, con = combined_file_conn)
}

# Close the combined file
close(combined_file_conn)
# '''combined file will be outputed to working directory. I am working on a way to delete the batch files with the program but havent gotten that far.'''



