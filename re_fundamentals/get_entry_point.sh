#!/bin/bash
source ./messages.sh
file_name=$1
if [ -z "$file_name" ]; then
    echo "Usage: $0 <file_name>"
    exit 1
fi
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi
if ! file "$file_name" | grep -q 'ELF'; then
    echo "Error: '$file_name' is not an ELF file."
    exit 1
fi
magic_number=$(readelf -h $file_name | grep 'Magic:' | cut -d: -f2 | xargs)
class=$(readelf -h $file_name | grep 'Class:' | cut -d: -f2 | xargs)
byte_order=$(readelf -h $file_name | grep 'Data:' | cut -d, -f2 | sed 's/^[[:space:]]*//')
entry_point_address=$(readelf -h $file_name | grep 'Entry point address:' | cut -d: -f2 | xargs)
display_elf_header_info
