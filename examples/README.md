# Examples Folder

In this folder you can find the following examples:

- [`analog_tutorial`](analog_tutorial/) — A simple analog inverter schematic with a simulation testbench (using `Xschem` and `ngspice`) and a layout (using `KLayout`). Then, the layout is drawn using `KLayout` and DRC (design rule check) and LVS (layout vs. schematic) checks are performed.
- [`librelane_rtl2gds_gf180`](librelane_rtl2gds_gf180/) — Five Jupyter walkthroughs that drive the LibreLane RTL-to-GDS flow on GF180MCU: bare counter (1-2 min), custom chip-top against the upstream wafer-space slot, the chipathon-2026 workshop padring, and a multi-macro counter+ALU stitched into the workshop slot. Validated against `hpretl/iic-osic-tools:chipathon26` (LibreLane v3.0.2). The vendored padring template these walkthroughs consume is at [`resources/Integration/workshop_padring_librelane/`](../resources/Integration/workshop_padring_librelane/).
