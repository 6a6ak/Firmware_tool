#!/bin/bash

# Prompt the user to enter the firmware file name
read -p "Enter the firmware file name: " FIRMWARE_FILE

# Check if the input is empty or the file does not exist
if [[ -z "$FIRMWARE_FILE" || ! -f "$FIRMWARE_FILE" ]]; then
    echo "Error: Please provide a valid firmware file."
    exit 1
fi

# Variables
EXTRACT_DIR="extract"
OUTPUT_FILE="output.txt"

# Create the extract directory if it doesn't exist
mkdir -p "$EXTRACT_DIR"

# Redirect all output and errors to the output.txt file
exec > "$OUTPUT_FILE" 2>&1

echo "==============================="
echo "Firmware Extraction Script"
echo "==============================="
echo "Input Firmware File: $FIRMWARE_FILE"
echo "Extraction Directory: $EXTRACT_DIR"
echo "Log File: $OUTPUT_FILE"
echo "-------------------------------"

# Step 1: Run binwalk to extract the firmware
echo "Step 1: Running binwalk to extract the firmware..."
binwalk --extract "$FIRMWARE_FILE" --directory="$EXTRACT_DIR"

# Step 2: Check for SquashFS files
echo "Step 2: Checking for SquashFS files..."
SQUASHFS_FILE=$(find "$EXTRACT_DIR" -name "*.squashfs")
if [ -n "$SQUASHFS_FILE" ]; then
    echo "Found SquashFS file: $SQUASHFS_FILE"
    echo "Extracting SquashFS..."
    unsquashfs -d "$EXTRACT_DIR/squashfs-root" "$SQUASHFS_FILE"
else
    echo "No SquashFS file found."
fi

# Step 3: Handle LZMA compressed files manually
echo "Step 3: Checking for LZMA compressed files..."
for LZMA_FILE in $(find "$EXTRACT_DIR" -name "*.7z" -o -name "*.lzma" -o -name "37C8" -o -name "20200"); do
    echo "Processing LZMA file: $LZMA_FILE"
    if [[ "$LZMA_FILE" == *.7z ]]; then
        7z x "$LZMA_FILE" -o"$EXTRACT_DIR"
    else
        lzma -d "$LZMA_FILE"
    fi
done

# Step 4: Final cleanup and summary
echo "==============================="
echo "Extraction Completed"
echo "Extracted files are stored in: $EXTRACT_DIR"
echo "Details of the process are logged in: $OUTPUT_FILE"
echo "==============================="
