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

# Function to handle file conflicts
handle_conflict() {
    local source="$1"
    local dest="$2"
    local filename="$3"
    
    if [ -f "$dest/$filename" ]; then
        echo "File '$filename' already exists in the destination."
        read -p "Do you want to (s)kip, (o)verwrite, or (r)ename? [s/o/r]: " choice
        case "$choice" in
            o|O) return 0 ;; # Overwrite
            r|R) 
                local new_name
                read -p "Enter new name: " new_name
                mv "$source/$filename" "$dest/$new_name"
                echo "$source/$filename,$dest/$new_name" >> "$undo_file"
                return 1 ;;
            *) return 2 ;; # Skip
        esac
    fi
    return 0
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
            filename=$(basename "$file")
            handle_conflict "$source" "$destination" "$filename"
            conflict_status=$?
            
            if [ $conflict_status -eq 0 ]; then
                mv "$file" "$destination"
                echo "$file,$destination/$filename" >> "$undo_file"
                ((file_count++))
                size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
                ((total_size+=size))
            elif [ $conflict_status -eq 2 ]; then
                echo "Skipped $filename"
            fi
        fi
    done

    echo "Moved $file_count files."
    echo "Total size: $(numfmt --to=iec-i --suffix=B $total_size)"
}

# Function to undo the move operation
undo_move() {
    if [ -f "$undo_file" ]; then
        echo "Undoing the last move operation..."
        while IFS=',' read -r source dest; do
            if [ -f "$dest" ]; then
                mv "$dest" "$source"
                echo "Moved back: $dest to $source"
            else
                echo "File not found, can't undo: $dest"
            fi
        done < "$undo_file"
        rm "$undo_file"
        echo "Undo completed."
    else
        echo "No undo information available."
    fi
}

# Main script
echo "Image Mover Script"
echo "=================="

# Set up undo file
undo_file="/tmp/image_mover_undo_$(date +%s).txt"
touch "$undo_file"

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
    echo "To undo this operation, run the script with the --undo option."
else
    echo "Operation cancelled."
    rm "$undo_file"
fi

# Check for undo option
if [ "$1" = "--undo" ]; then
    undo_move
fi
