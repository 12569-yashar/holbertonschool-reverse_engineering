#!/bin/bash

# 1. Arqument yoxlaması
if [ -z "$1" ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file_name="$1"

# 2. Fayl mövcudluğu
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' not found."
    exit 1
fi

# 3. ELF olub-olmadığını yoxla
if ! readelf -h "$file_name" &> /dev/null; then
    echo "Error: '$file_name' is not a valid ELF file."
    exit 1
fi

# 4. Dəyişənləri çıxar
magic_number=$(readelf -h "$file_name" | grep "Magic" | sed 's/^[ \t]*Magic:[ \t]*//;s/[ \t]*$//')
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | cut -d ',' -f2 | sed 's/^[ \t]*//')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address" | awk '{print $NF}')

# 5. messages.sh-ı source et
source ./messages.sh

# 6. Funksiyanı çağır
display_elf_header_info
