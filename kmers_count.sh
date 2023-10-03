#!/bin/bash

if [ $# -ne 4 ]; then
  echo "Usage: $0 <kmer> <input_folder> <output_folder> <temp_dir>"
  exit 1
fi

#kmc_docker="docker run -v /Users/lorenzo/Desktop/kmers-count/script:/home -w /home --rm quay.io/biocontainers/kmc:3.0.0--2"
kmc_docker="docker run -v $(pwd):/home -w /home --rm quay.io/biocontainers/kmc:3.0.0--2"
bedtools_docker="docker run -v $(pwd):/home -w /home --rm quay.io/biocontainers/bedtools:2.31.0--h468198e_1"

kmer="${1}"
input_folder="${2}"
output_folder="${3}"
tmp="${4}"

# Create the output directory if it doesn't exist
mkdir -p "${output_folder}"

# Process all .fastq and .fastq.gz files in the input folder
for file in "${input_folder}"/*.bam; do
  bam="${file}"
  # Extract the filename without extension
  filename=$(basename -- "$bam")
  filename_without_extension="${filename%.*}"
  # Build the fastq filename
  fastq="${input_folder}/${filename_without_extension}.fq"
  # Convert the BAM file to FASTQ format using bedtools
  ${bedtools_docker} bedtools bamtofastq -i ${bam} -fq ${fastq}
  # Build the output filename with the "_kmers" extension
  out="${output_folder}/${filename_without_extension}_kmers"
  # Execute kmc inside the loop for each input file
  ${kmc_docker} kmc -k${kmer} -ci1 -cs999999 "${fastq}" "${out}" "${tmp}" 
  # Execute kmc_tools inside the loop for each output file
  ${kmc_docker} kmc_tools transform "${out}" dump "${out}.txt"
done


