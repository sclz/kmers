# Load the tidyr library for data manipulation
library(tidyr)

get_nreads_from_bam_folder <- function(input_folder) {
  # Get a list of all BAM files in the folder
  files_bam <- list.files(path = input_folder, pattern = "\\.bam$", full.names = TRUE)
  
  nreads <- numeric(0)
  
  # Loop through the BAM files
  for (file_bam in files_bam) {
    # Build the SAMtools command for the current file
    comando_samtools <- paste("samtools view -c", shQuote(file_bam))
    
    # Execute the command using system()
    nread <- system(comando_samtools, intern = TRUE)
    
    # Extract the number of reads from the result and add it to the nreads list
    nreads <- c(nreads, as.integer(nread))
  }
  
  return(nreads)
}

# Function for normalization
normalization <- function(kmers_table, nreads) {
  samples <- ncol(kmers_table)
  
  for (i in 2:samples) {
    # Normalize each column (sample) of kmers by dividing by the corresponding nreads value
    kmers_table[, i] <- round(kmers_table[, i] / nreads[i - 1] * 10000000)
  }
  
  return(kmers_table)
}


# Check if a command-line argument for the directory has been provided
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("You must specify the directory as a command-line argument.")
}

# Get the directory from the command-line argument
directory <- args[1]

# Get a list of files in the directory with a .txt extension
file_list <- list.files(path = directory, pattern = "\\.txt$", full.names = TRUE)

# Initialize an empty list to store data from all files
data_list <- list()

# Read and process data from each file
for (file in file_list) {
  # Read the file into a dataframe
  data <- read.table(file, header = FALSE, col.names = c("Kmer", "Counts"))
  
  # Add the file name as a column
  data$File <- sub("\\.bam_unmapped_kmers\\.txt$", "", basename(file))
  
  # Add the dataframe to the list
  data_list[[length(data_list) + 1]] <- data
}

# Combine all the data into a single dataframe
combined_data <- do.call(rbind, data_list)

# Fill missing values with 0
combined_data_filled <- pivot_wider(combined_data, names_from = File, values_from = Counts, values_fill = 0)

# Sort rows based on Kmer
combined_data_filled <- combined_data_filled[order(combined_data_filled$Kmer),]

write.table(combined_data_filled, file = "output/kmers.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

# Filter by excluding kmers that do not appear in all samples
#kmers <- combined_data_filled[rowSums(combined_data_filled != 0) == ncol(combined_data_filled), ]

# Copy the dataframe to unique_kmers
unique_kmers <- combined_data_filled

# Filter rows where the count is present in only one sample and 0 in all others (excluding the first column)
unique_kmers <- unique_kmers[rowSums(unique_kmers[, -1] != 0) == 1, ]

# Sort the dataframe based on counts (excluding the first column)
unique_kmers <- unique_kmers[order(rowSums(unique_kmers[, -1]), decreasing = TRUE), ]


# Write the 'kmers' dataframe to a tab-separated table
write.table(unique_kmers, file = "output/unique_kmers.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

# Usa la funzione specificando la directory dei file BAM
input_folder <- file.path(directory, "../input/")

nreads <- get_nreads_from_bam_folder(input_folder)

normalized_kmers <- normalization(combined_data_filled, nreads)

# Write the 'kmers' dataframe to a tab-separated table
write.table(normalized_kmers, file = "output/normalized_kmers.tsv", sep = "\t", quote = FALSE, row.names = FALSE)