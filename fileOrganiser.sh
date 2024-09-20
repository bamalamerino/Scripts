#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 <source_directory> <destination_directory> [file_extension (optional)]"
    echo "Example: $0 /path/to/source /path/to/destination jpg"
    exit 1
}

# Check if the correct number of arguments is provided
if [[ $# -lt 2 ]]; then
    usage
fi

# Define source and destination directories
src_dir="$1"
dest_dir="$2"
file_ext="${3:-*}"  # Default to all files if no extension is provided

# Check if directories exist
if [[ ! -d "$src_dir" || ! -d "$dest_dir" ]]; then
    echo "Please provide valid source and destination directories."
    exit 1
fi

# Get total number of files to process for progress tracking
total_files=$(find "$src_dir" -type f -name "*.$file_ext" | wc -l)

# Function to move and organize files by creation date
organize_files() {
    local count=0  # Counter for files processed

    for img in "$src_dir"/*."$file_ext"; do
        if [[ -f "$img" ]]; then
            ((count++))  # Increment the counter

            # Try to get the creation date from EXIF data
            creation_date=$(exiftool -d "%Y-%m-%d" -DateTimeOriginal "$img" 2>/dev/null | grep "Date/Time Original" | awk '{print $4}')
            
            # If EXIF data is not available, fall back to the file's modification date
            if [[ -z "$creation_date" ]]; then
                creation_date=$(date -r "$img" +"%Y-%m-%d")
                echo "No EXIF data for $img, using modification date: $creation_date"
            fi

            # Create destination directory based on the creation date
            dest_subdir="$dest_dir/$creation_date"
            mkdir -p "$dest_subdir"

            # Generate a unique filename to avoid overwriting
            base_name=$(basename "$img")
            dest_file="$dest_subdir/$base_name"
            suffix=1
            while [[ -f "$dest_file" ]]; do
                dest_file="$dest_subdir/${base_name%.*}_$suffix.${base_name##*.}"
                ((suffix++))
            done

            # Move the file
            mv "$img" "$dest_file"
            echo "Moved: $img -> $dest_file"

            # Display progress
            echo "Progress: $count/$total_files files moved."
        fi
    done
}

# Run the file organization
if [[ $total_files -eq 0 ]]; then
    echo "No files with the extension '.$file_ext' found in the source directory."
else
    echo "Found $total_files files to organize."
    organize_files
    echo "All $total_files files organized successfully."
fi
