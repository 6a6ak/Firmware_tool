# Firmware Extraction Script

## Overview
This script is designed to extract firmware files, including compressed data and file systems, from a provided firmware binary. It processes files such as SquashFS and LZMA-compressed data and organizes the output in a structured manner for analysis or modification.

---

## Features
- Extracts firmware files using `binwalk`.
- Handles SquashFS files and extracts them using `unsquashfs`.
- Processes LZMA-compressed and `.7z` files.
- Logs all activities to `output.txt` for easy review.
- Outputs extracted files into a directory named `extract`.

---

## Requirements
Ensure the following tools are installed:
- `binwalk`
- `unsquashfs` (part of `squashfs-tools`)
- `7z` (part of `p7zip-full` or equivalent)
- `lzma` (from `xz-utils`)

To install required dependencies on Ubuntu/Debian:
```bash
sudo apt update
sudo apt install binwalk squashfs-tools p7zip-full xz-utils -y
```

---

## Usage
### Running the Script
1. Clone this repository or copy the script file.
2. Make the script executable:
   ```bash
   chmod +x extract_firmware.sh
   ```
3. Run the script with the firmware file as an argument:
   ```bash
   ./extract_firmware.sh <firmware_file>
   ```

### Example
```bash
./extract_firmware.sh firmware_W25Q32FV.bin
```

---

## Outputs
1. **Extracted Files:**
   - All extracted files are stored in the `extract` directory.

2. **Log File:**
   - A detailed log of all operations is saved in `output.txt`.

---

## File Structure
After running the script, the directory structure will look like this:
```
.
├── extract/
│   ├── 120000.squashfs
│   ├── 37C8
│   ├── 20200
│   ├── squashfs-root/
│   │   ├── bin/
│   │   ├── etc/
│   │   ├── usr/
│   │   └── ...
├── extract_firmware.sh
└── output.txt
```

---

## Troubleshooting
1. **Missing Tools:**
   If you encounter errors about missing tools, ensure all dependencies are installed.

2. **Permission Issues:**
   Run the script with sufficient permissions, e.g., using `sudo` if required:
   ```bash
   sudo ./extract_firmware.sh <firmware_file>
   ```

3. **Incomplete Extraction:**
   Check the `output.txt` log for any errors or warnings.

---

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
