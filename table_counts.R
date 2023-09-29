# Load the tidyr library for data manipulation
library(tidyr)

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
  data$File <- basename(file)
  
  # Add the dataframe to the list
  data_list[[length(data_list) + 1]] <- data
}

# Combine all the data into a single dataframe
combined_data <- do.call(rbind, data_list)

# Fill missing values with 0
combined_data_filled <- pivot_wider(combined_data, names_from = File, values_from = Counts, values_fill = 0)

# Sort rows based on Kmer
combined_data_filled <- combined_data_filled[order(combined_data_filled$Kmer),]

# Filter by excluding kmers that do not appear in all samples
#kmers <- combined_data_filled[rowSums(combined_data_filled != 0) == ncol(combined_data_filled), ]

# Copy the dataframe to unique_kmers
unique_kmers <- combined_data_filled

# Filter rows where the count is present in only one sample and 0 in all others (excluding the first column)
unique_kmers <- unique_kmers[rowSums(unique_kmers[, -1] != 0) == 1, ]

# Sort the dataframe based on counts (excluding the first column)
unique_kmers <- unique_kmers[order(rowSums(unique_kmers[, -1]), decreasing = TRUE), ]


# Write the 'kmers' dataframe to a tab-separated table
write.table(unique_kmers, file = "output/unique_table.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

