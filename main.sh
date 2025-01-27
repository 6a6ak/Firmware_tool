#!/bin/bash

# Ensure the script takes a filename as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <firmware_file>" > output.txt
    exit 1
fi

FIRMWARE_FILE="$1"
EXTRACT_DIR="extract"
OUTPUT_FILE="output.txt"

# Create the extract directory if it doesn't exist
mkdir -p "$EXTRACT_DIR"

# Redirect all output and errors to the output.txt file
exec > "$OUTPUT_FILE" 2>&1

echo "Starting extraction for: $FIRMWARE_FILE"
echo "Extracted files will be saved in: $EXTRACT_DIR"
echo "Logging output to: $OUTPUT_FILE"

# Step 1: Run binwalk to extract the firmware
echo "Running binwalk extraction..."
binwalk --extract "$FIRMWARE_FILE" --directory="$EXTRACT_DIR"

# Step 2: Check for SquashFS and extract manually if needed
SQUASHFS_FILE=$(find "$EXTRACT_DIR" -name "*.squashfs")
if [ -n "$SQUASHFS_FILE" ]; then
    echo "Found SquashFS file: $SQUASHFS_FILE"
    echo "Extracting SquashFS..."
    unsquashfs -d "$EXTRACT_DIR/squashfs-root" "$SQUASHFS_FILE"
else
    echo "No SquashFS file found."
fi

# Step 3: Handle LZMA compressed files manually
echo "Checking for LZMA compressed files..."
for LZMA_FILE in $(find "$EXTRACT_DIR" -name "*.7z" -o -name "*.lzma" -o -name "37C8" -o -name "20200"); do
    echo "Extracting LZMA file: $LZMA_FILE"
    7z x "$LZMA_FILE" -o"$EXTRACT_DIR" || lzma -d "$LZMA_FILE"
done

# Step 4: Final cleanup and summary
echo "Extraction complete."
echo "All extracted files are stored in: $EXTRACT_DIR"
echo "Details of the process are logged in: $OUTPUT_FILE"
