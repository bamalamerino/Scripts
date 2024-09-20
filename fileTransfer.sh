#!/bin/bash

# Function to prompt for directory with validation
get_valid_directory() {
    local prompt="$1"
    local dir=""
    while true; do
        read -p "$prompt" dir
        if [ -d "$dir" ]; then
            echo "$dir"
            return 0
        else
            echo "Invalid directory. Please try again."
        fi
    done
}

# Function to move files
move_files() {
    local source="$1"
    local destination="$2"
    local file_count=0
    local total_size=0

    # Create destination directory if it doesn't exist
    mkdir -p "$destination"

    # Move image files
    for file in "$source"/*.{jpg,jpeg,png,gif,tif,tiff,raw,cr2,cr3,nef}; do
        if [ -f "$file" ]; then
            mv "$file" "$destination"
            ((file_count++))
            size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
            ((total_size+=size))
        fi
    done

    echo "Moved $file_count files."
    echo "Total size: $(numfmt --to=iec-i --suffix=B $total_size)"
}

# Main script
echo "Image Mover Script"
echo "=================="

# Get source directory
source_dir=$(get_valid_directory "Enter source directory: ")

# Get destination directory
dest_dir=$(get_valid_directory "Enter destination directory: ")

# Confirm action
echo "You are about to move images from:"
echo "  Source: $source_dir"
echo "  Destination: $dest_dir"
read -p "Do you want to proceed? (y/n) " confirm

if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
    move_files "$source_dir" "$dest_dir"
    echo "Image move completed."
else
    echo "Operation cancelled."
fi
