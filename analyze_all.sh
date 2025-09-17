#!/bin/bash
for file in *.vhd; do
  if [ -f "$file" ]; then
    ghdl analyze "$file"
  fi
done
