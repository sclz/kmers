# K-mer count Script Documentation

## Introduction

The provided BASH script allows you to perform K-mer analysis on BAM (.bam) data files located in a specified folder. K-mer analysis is a common operation in bioinformatics used to count the occurrences of K-mers in genomic data.

## Usage

```
./kmers_count.sh <kmer> <input_folder> <output_folder> <temp_dir>
```

- `<kmer>`: The desired length of K-mers to count.
- `<input_folder>`: The folder containing the BAM files to be analyzed.
- `<output_folder>`: The folder where the analysis results will be saved.
- `<temp_dir>`: A temporary directory used for internal processing.

## Requirements

- Docker must be installed and configured correctly.
- The KMC (K-mer Counter) Docker image must be downloaded and available. You can pull the image with the following command: 

```
docker pull quay.io/biocontainers/kmc:3.0.0--2
```
- The bedtools Docker image must be downloaded and available. You can pull the image with the following command: 

```
docker pull quay.io/biocontainers/bedtools:2.31.0--h468198e_1    
```

## Operation

The script performs the following operations:

1. Creates an output directory if it doesn't exist.
2. Scans all `bam` files in the specified input folder.
3. For each input file:
   - Extracts the filename without extension.
   - Constructs the fastq filename by adding ".fq" as extension.
   - Constructs the output filename by adding "_kmers" to the extension.
   - Uses on the Docker container "bedtools" to convert bam files in fastq files.
   - Uses on the Docker container "kmc" to perform K-mer analysis with the specified K value.
   - Uses on the Docker container "kmc_tools" to transform the results into a text file.

## Example Usage

Suppose you want to perform K-mer analysis with K=21 on the files in the "data_input" folder and save the results in the "results" folder, using a temporary directory named "temp":

```
./kmers_count.sh 21 data_input results temp
```

## Notes

- Ensure that Docker is installed and configured correctly to run the "bedtools", "kmc" and "kmc_tools" commands.
- The results of the K-mer analysis will be available in text files in the output folder with the "_kmers.txt" extension.
- Ensure that the script file has the correct execute permissions (`chmod +x kmers_count.sh`).

# K-mer Count R Script Documentation

## Introduction

This R script facilitates the analysis of K-mer counts obtained from BAM files. This script processes data files obtained from kmers_count.sh and performs various operations, including normalization and filtering.

## Usage

To use this script, run it in R or RStudio with the following command:

```
Rscript <output_folder>
```

- `<output_folder>`: The folder where the k-mer count lists obtained by kmers_count.sh were saved.

## Requirements

Before using the script, ensure you have the following prerequisites:

- **R**: R must be installed on your system. You can download R from the official website: [R Project](https://www.r-project.org/)

- **R Library tidyr**: The script depends on the `tidyr` library for data manipulation. You can install it in R with the following command:

  ```R
  install.packages("tidyr")
  ```

- **SAMtools**: SAMtools is required for extracting read counts from BAM files. Download SAMtools from: [SAMtools](http://www.htslib.org/download/)

## Operation

The script performs the following operations:

1. Reads K-mer count data from text files in the specified directory.
2. Combines and organizes the data into a single dataframe.
3. Normalizes the data based on the number of reads obtained from BAM files.
4. Filters and extracts unique K-mers.
5. Generates output files in the "output" folder.

## Output

The script generates the following output files in the "output" folder:

- `kmers.tsv`: Combined K-mer count data from all input files.

- `unique_kmers.tsv`: Unique K-mers, filtered based on specific criteria in the script.

- `normalized_kmers.tsv`: Normalized K-mer count data based on the number of reads obtained from BAM files.

## Example Usage

Suppose you want to use this script to analyze K-mer counts from BAM files in the "output" folder and save the results in the same "output" folder. You can execute the script with the following command:

```
Rscript output
```

## Notes

- Ensure that SAMtools is correctly installed and available in your system's PATH.
- The script assumes that input files are in the specified directory and have a ".txt" extension for K-mer count data.


