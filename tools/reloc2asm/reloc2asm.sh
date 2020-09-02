#!/bin/bash

# syntax is asm2reloc /path/to/reloc/file /path/to/bin/file

cat reloc.inc

hexdump -v -e '/2 "%04X\n"' $1 | xargs -n 1 -I{} printf "\tlxi h, {}H\n\tRELOCADDR\n"
echo "end:"
hexdump -v -e '/1 "%02X\n"' $2 | xargs -n 1 -I{} printf "\tdb 0{}H\n"



