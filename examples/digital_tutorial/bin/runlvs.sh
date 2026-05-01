#!/bin/sh
netgen -noc << EOF
permute transistors
lvs $1 $2
quit
EOF
