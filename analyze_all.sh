#!/bin/bash
for file in *; do
  if [ -f "$file" ]; then
    gdhl analyze "$file"
  fi
done