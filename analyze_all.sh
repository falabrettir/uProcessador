#!/bin/bash
for file in *.vhd; do
  if [ -f "$file" ]; then
    gdhl analyze "$file"
  fi
done