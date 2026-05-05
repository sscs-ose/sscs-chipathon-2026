// Default timescale for GL simulation. Without this, iverilog falls back
// to 1s/1s precision because neither the gf180 stdcell models nor the
// synthesised .nl.v carry an explicit `timescale directive; the TB's
// `Clock(period=10, units="ns")` then trips on the coarse precision.

`timescale 1ns/1ps
