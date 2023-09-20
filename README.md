# K-mer count Script Documentation

## Introduction

The provided BASH script allows you to perform K-mer analysis on FastQ or compressed FastQ (.fastq or .fastq.gz) data files located in a specified folder. K-mer analysis is a common operation in bioinformatics used to count the occurrences of K-mers in genomic data.

## Usage

```
./script_kmer.sh <kmer> <input_folder> <output_folder> <temp_dir>
```

- `<kmer>`: The desired length of K-mers to count.
- `<input_folder>`: The folder containing the FastQ or compressed FastQ files to be analyzed.
- `<output_folder>`: The folder where the analysis results will be saved.
- `<temp_dir>`: A temporary directory used for internal processing.

## Requirements

- Docker must be installed and configured correctly.
- The KMC (K-mer Counter) Docker image must be downloaded and available. You can pull the image with the following command: 

```
docker pull quay.io/biocontainers/kmc:3.0.0--2
```

## Operation

The script performs the following operations:

1. Creates an output directory if it doesn't exist.
2. Scans all `.fastq` and `.fastq.gz` files in the specified input folder.
3. For each input file:
   - Extracts the filename without extension.
   - Constructs the output filename by adding "_kmers" to the extension.
   - Uses on the Docker container "kmc" to perform K-mer analysis with the specified K value.
   - Uses on the Docker container "kmc_tools" to transform the results into a text file.

## Example Usage

Suppose you want to perform K-mer analysis with K=21 on the files in the "data_input" folder and save the results in the "results" folder, using a temporary directory named "temp":

```
./script_kmer.sh 21 data_input results temp
```

## Notes

- Ensure that Docker is installed and configured correctly to run the "kmc" and "kmc_tools" commands.
- The results of the K-mer analysis will be available in text files in the output folder with the "_kmers.txt" extension.
- Ensure that the script file has the correct execute permissions (`chmod +x script_kmer.sh`).
