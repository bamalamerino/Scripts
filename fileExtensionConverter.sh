#!/bin/bash

# Check if ImageMagick (convert) and cwebp are installed
if ! command -v convert &> /dev/null
then
    echo "ImageMagick is not installed. Please install it first (sudo apt-get install imagemagick)."
    exit 1
fi

if ! command -v cwebp &> /dev/null
then
    echo "cwebp is not installed. Please install it first (sudo apt-get install webp)."
    exit 1
fi

# Function to convert images to the chosen format
convert_images() {
    input_dir="$1"
    file_type="$2"
    output_format="$3"
    quality="${4:-80}"  # Optional quality for webp (default is 80)

    # Create output directory
    output_dir="${input_dir}/converted_files"
    mkdir -p "$output_dir"

    # Find and loop through all files with the specified file extension
    for file in "$input_dir"/*.$file_type; do
        if [ -f "$file" ]; then
            # Extract the filename without extension
            filename=$(basename "$file" .$file_type)
            output_file="$output_dir/$filename.$output_format"

            # Convert to the specified format
            if [ "$output_format" == "jpeg" ]; then
                convert "$file" "$output_file"
                echo "Converted $file to $output_file"
            elif [ "$output_format" == "webp" ]; then
                cwebp -q "$quality" "$file" -o "$output_file"
                echo "Converted $file to $output_file (quality: $quality)"
            fi
        fi
    done

    echo "Conversion to $output_format completed."
}

# Get the input directory
read -p "Enter the directory containing the files to convert: " input_dir

# Check if the directory exists
if [[ ! -d "$input_dir" ]]; then
    echo "Directory does not exist."
    exit 1
fi

# Get the input file type to look for (e.g., tif, cr3, png, etc.)
read -p "Enter the file extension of the files to convert (e.g., tif, cr3): " file_type

# Get the desired output format (jpeg or webp)
read -p "Enter the desired output format (jpeg or webp): " output_format

# Check for valid output format
if [[ "$output_format" != "jpeg" && "$output_format" != "webp" ]]; then
    echo "Invalid output format. Please choose 'jpeg' or 'webp'."
    exit 1
fi

# If output format is webp, ask for quality (optional)
if [ "$output_format" == "webp" ]; then
    read -p "Enter quality for webp (0-100, default is 80): " quality
    quality="${quality:-80}"  # Use default quality 80 if not provided
fi

# Call the conversion function
convert_images "$input_dir" "$file_type" "$output_format" "$quality"
