#!/bin/bash

# Prompt for the directory containing the images
read -p "Enter the directory containing the images: " img_dir

# Check if the directory exists
if [[ ! -d "$img_dir" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Prompt for the file types (e.g., jpg, png, tif)
read -p "Enter the file types to process (e.g., jpg,png,tif): " file_types

# Convert comma-separated file types into an array
IFS=',' read -r -a extensions <<< "$file_types"

# Check for any matching image files
shopt -s nullglob
image_files=()
for ext in "${extensions[@]}"; do
    image_files+=("$img_dir"/*."$ext")
done

if [[ ${#image_files[@]} -eq 0 ]]; then
    echo "No image files found in the directory for the specified file types."
    exit 1
fi

# Loop through all selected image files and strip metadata
for img in "${image_files[@]}"; do
    if [[ -f "$img" ]]; then
        # Strip metadata using exiftool
        exiftool -all= "$img"
        
        # Remove the backup file created by exiftool
        rm -f "${img}_original"

        echo "Metadata removed from: $img"
    fi
done

echo "Metadata removal completed for all selected files in $img_dir."
