#!/bin/bash

# Check if a directory name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <output_directory>"
    exit 1
fi

# Create the output directory if it doesn't exist
output_dir=$1
mkdir -p "$output_dir"

# Check if prefetch and fasterq-dump are installed
if ! command -v prefetch &> /dev/null || ! command -v fasterq-dump &> /dev/null; then
    echo "Please install SRA Toolkit (prefetch, fasterq-dump) before running this script."
    exit 1
fi

# Read accession numbers from the input file
while IFS= read -r accession; do
    # Run prefetch to download the data
    prefetch "$accession"

    # Run fasterq-dump to convert the data to fastq format
    fasterq-dump --split-files "$accession"

    # Move the resulting fastq files to the output directory
    mv "${accession}_1.fastq" "${output_dir}/${accession}_1.fastq"
    mv "${accession}_2.fastq" "${output_dir}/${accession}_2.fastq"

    # Remove intermediate files
    rm "${accession}.sra"
done < "$2"
