#!/bin/bash

netgen -batch lvs "../magic/ngspice/$1.spice $1" "../xschem/$1.spice $1" $PDK_ROOT/gf180mcuD/libs.tech/netgen/gf180mcuD_setup.tcl $1.out
