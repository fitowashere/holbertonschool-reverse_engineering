#!/bin/bash

# Source the messages.sh file for display functions
source ./messages.sh

# Function to extract ELF header information
extract_elf_header() {
    local file="$1"
    
    # Check if file exists
    if [[ ! -f "$file" ]]; then
        echo "Error: File '$file' does not exist."
        exit 1
    fi
    
    # Check if file is an ELF file by checking magic number
    magic_bytes=$(hexdump -C "$file" | head -1 | cut -d' ' -f2-5)
    if [[ "$magic_bytes" != "7f 45 4c 46" ]]; then
        echo "Error: '$file' is not a valid ELF file."
        exit 1
    fi
    
    # Extract ELF header information using readelf
    if ! command -v readelf &> /dev/null; then
        echo "Error: readelf command not found. Please install binutils."
        exit 1
    fi
    
    # Get ELF header information
    header_info=$(readelf -h "$file" 2>/dev/null)
    
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to read ELF header from '$file'."
        exit 1
    fi
    
    # Extract specific fields
    magic_number=$(echo "$header_info" | grep "Magic:" | sed 's/.*Magic:[[:space:]]*//')
    class=$(echo "$header_info" | grep "Class:" | sed 's/.*Class:[[:space:]]*//')
    byte_order=$(echo "$header_info" | grep "Data:" | sed 's/.*Data:[[:space:]]*//')
    entry_point_address=$(echo "$header_info" | grep "Entry point address:" | sed 's/.*Entry point address:[[:space:]]*//')
    
    # Set global variables for messages.sh
    file_name="$file"
    
    # Call display function from messages.sh
    display_elf_header_info
}

# Main script logic
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <elf_file>"
    echo "Example: $0 /bin/ls"
    exit 1
fi

# Extract header information
extract_elf_header "$1"
