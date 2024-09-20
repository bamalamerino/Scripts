# Photo_tools
A bunch of useful tools to improve photography workflow. 📸

## KEY NOTE 
# chmod +x "filename.sh"  
(gives permissions to run the bash script after download)

Desciptions for each script will be added soon 
---
## fileTransfer.sh notes
This script does the following

- Prompts the user for a source directory and validates it.
- Prompts the user for a destination directory and validates it.
- Asks for confirmation before proceeding.
- If confirmed, it moves all image files (jpg, jpeg, png, gif, tif, tiff, raw, cr2, cr3, nef) from the source to the destination.
- Displays the number of files moved and the total size.

_If there's any other file type you need to transfer, add it here_ 
#### " for file in "$source"/*.{jpg,jpeg,png,gif,tif,tiff,raw,cr2,cr3,nef}; do "

To use this script:

- Save it to a file, for example, fileTransfer.sh.
- Make it executable: chmod +x fileTransfer.sh
- Run it: ./fileTransfer.sh

## fileExtensionConverter.sh notes
_How the Script Works:_
1. Input Directory: You specify the directory containing your images.
2. File Type: You enter the file extension of the files you want to convert (e.g., tif, cr3, png, etc.).
3. Output Format: You choose the desired output format (jpeg or webp).
4. Quality (Optional for WebP): If you choose to convert files to .webp, you can specify the quality level (between 0 and 100). If no value is provided, the default quality is 80.
5. The script will loop through all files with the chosen input extension in the directory and convert them to the specified output format, saving them in a new folder named converted_files inside the input directory.


## photoProjectSetup.sh notes 

Windows:

Install Git Bash (if not already installed).
Right-click in the folder where you saved the script and select "Git Bash Here".
In the Git Bash terminal, type: ./photo_project_setup.sh and press Enter.

macOS or Linux:

Open Terminal.
Navigate to the directory where you saved the script using the cd command. For example: cd /path/to/script/directory
Make the script executable by typing: chmod +x photo_project_setup.sh
Run the script by typing: ./photo_project_setup.sh

After starting the script:

You'll see a prompt asking for the project name.
Type your desired project name and press Enter.
The script will create the directory structure and display it (if the tree command is available).

If you encounter a "Permission denied" error, make sure you've made the script executable using the chmod command mentioned above.

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
