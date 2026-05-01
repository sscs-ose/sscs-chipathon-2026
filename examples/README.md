# Examples Folder

In this folder you can find the following examples:

- `analog_tutorial`: A simple analog inverter schematic with a simulation testbench (using `Xschem` and `ngspice`) and a layout (using `KLayout`). Then, the layout is drawn using `KLayout` and DRC (design rule check) and LVS (layout vs. schematic) checks are performed.
- `digital_tutorial`: A simple digital inverter example using Magic for layout creation, Xschem for schematic entry and simulation setup, IRSIM for digital simulation, and Netgen for LVS (Layout Versus Schematic) verification. This example demonstrates how to design, simulate, extract, and verify a simple inverter using a complete open-source digital custom design flow.  In addition, the directory includes several Python helper scripts that simplify common tasks such as layout extraction, SPICE generation, LVS setup, and other repetitive commands, making the flow easier to run and reproduce.
