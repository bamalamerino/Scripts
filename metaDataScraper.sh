#!/bin/bash

# Check if a directory is passed as an argument
if [[ -z "$1" ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

img_dir="$1"

# Check if the directory exists
if [[ ! -d "$img_dir" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Check for any matching image files (including .tif and .heic)
shopt -s nullglob  # Avoid treating empty globs as themselves
image_files=("$img_dir"/*.{jpg,jpeg,png,tif,heic})

if [[ ${#image_files[@]} -eq 0 ]]; then
    echo "No image files found in the directory."
    exit 1
fi

# Define the output CSV file
output_file="image_metadata.csv"

# Write the CSV header (with new GPS fields)
echo "File Name,File Size,Date/Time Original,Camera Model,ISO,Shutter Speed,F-Number,GPS Latitude,GPS Longitude" > "$output_file"

# Loop through all images and extract metadata using exiftool
for img in "${image_files[@]}"; do
    if [[ -f "$img" ]]; then
        # Extract metadata fields using exiftool
        file_name=$(basename "$img")
        file_size=$(exiftool -FileSize "$img" | awk -F': ' '{print $2}')
        date_time_original=$(exiftool -DateTimeOriginal "$img" | awk -F': ' '{print $2}')
        camera_model=$(exiftool -CameraModelName "$img" | awk -F': ' '{print $2}')
        iso=$(exiftool -ISO "$img" | awk -F': ' '{print $2}')
        shutter_speed=$(exiftool -ShutterSpeed "$img" | awk -F': ' '{print $2}')
        f_number=$(exiftool -FNumber "$img" | awk -F': ' '{print $2}')
        
        # Extract GPS data (latitude and longitude)
        gps_latitude=$(exiftool -GPSLatitude "$img" | awk -F': ' '{print $2}')
        gps_longitude=$(exiftool -GPSLongitude "$img" | awk -F': ' '{print $2}')

        # If any fields are empty, replace with "N/A"
        file_size=${file_size:-"N/A"}
        date_time_original=${date_time_original:-"N/A"}
        camera_model=${camera_model:-"N/A"}
        iso=${iso:-"N/A"}
        shutter_speed=${shutter_speed:-"N/A"}
        f_number=${f_number:-"N/A"}
        gps_latitude=${gps_latitude:-"N/A"}
        gps_longitude=${gps_longitude:-"N/A"}

        # Append the metadata to the CSV file
        echo "$file_name,$file_size,$date_time_original,$camera_model,$iso,$shutter_speed,$f_number,$gps_latitude,$gps_longitude" >> "$output_file"

        echo "Processed metadata for: $img"
    fi
done

echo "Metadata extraction completed. Saved to $output_file."
