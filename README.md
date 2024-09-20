# Scripts
A bunch of bash scripts to improve photography workflow. 📸

## KEY NOTE 
# chmod +x "filename.sh"  
(gives permissions to run the bash script after download)

Desciptions for each script will be added soon 
---

## removeMetaData.sh notes 

1.  Prompt for Directory:
  - The script asks the user to input the directory containing the images.
2. File Check:
  - The script checks if the directory exists and if there are any image files (.jpg, .jpeg, .png, .tif, .heic) in the directory.
3. Metadata Removal:
  - The exiftool -all= command removes all metadata (Exif, IPTC, XMP, etc.) from each image file.
4. Backup File Cleanup:
  - By default, exiftool creates a backup of the original image file with the suffix _original. The script automatically deletes this backup to avoid leaving unnecessary files behind.

## metaDataScraper.sh notes

Basic Setup:

The script accepts a directory as an argument, checks if it exists, and searches for .jpg, .jpeg, and .png files within it.
It writes the metadata to a CSV file (image_metadata.csv) in the current directory.
Extracting Metadata:

It uses exiftool to extract common fields like file size, date/time original, camera model, ISO, shutter speed, and f-number.
Metadata fields are extracted using awk to parse the output from exiftool.
Handling Missing Data:

If any metadata field is missing, the script inserts "N/A" in the CSV.
CSV Output:

The CSV file has a header row, and for each image, a row with the extracted metadata is appended.

---
*More scripts are in the pipeline, so hold tight*

.bam
