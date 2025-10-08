#!/bin/bash

# Check if a directory path is provided as argument
if [ $# -eq 1 ]; then
    # Change to the specified directory
    cd "$1" || { echo "Error: Cannot access directory '$1'"; exit 1; }
fi

# Analyze all .vhd files in the current directory (or specified directory)
for file in *.vhd; do
  if [ -f "$file" ]; then
    ghdl analyze "$file"
  fi
done
