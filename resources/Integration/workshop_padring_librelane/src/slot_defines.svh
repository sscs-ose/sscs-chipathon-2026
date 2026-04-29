`ifdef SLOT_1X1

// Power/ground pads for core and I/O
`define NUM_DVDD_PADS 8
`define NUM_DVSS_PADS 10

// Signal pads
`define NUM_INPUT_PADS 12
`define NUM_BIDIR_PADS 40
`define NUM_ANALOG_PADS 2

`endif

`ifdef SLOT_0P5X1

// Power/ground pads for core and I/O
`define NUM_DVDD_PADS 8
`define NUM_DVSS_PADS 8

// Signal pads
`define NUM_INPUT_PADS 4
`define NUM_BIDIR_PADS 44
`define NUM_ANALOG_PADS 6

`endif

`ifdef SLOT_1X0P5

// Power/ground pads for core and I/O
`define NUM_DVDD_PADS 8
`define NUM_DVSS_PADS 8

// Signal pads
`define NUM_INPUT_PADS 4
`define NUM_BIDIR_PADS 46
`define NUM_ANALOG_PADS 4

`endif

`ifdef SLOT_0P5X0P5

// Power/ground pads for core and I/O
`define NUM_DVDD_PADS 4
`define NUM_DVSS_PADS 4

// Signal pads
`define NUM_INPUT_PADS 4
`define NUM_BIDIR_PADS 38
`define NUM_ANALOG_PADS 4

`endif

// Chipathon 2026 workshop padring -- 2935x2935 um die.
// Mirror of JuanMoya's padring_gf180/workshop_padring.cfg:
//   60 analog (asig_5p0), 20 bidir (bi_24t on this template), 4 dvdd
//   + 4 dvss, 4 corners.  clk_pad and rst_n_pad remain the stock
//   single-instance inputs (listed as literals in slot_workshop.yaml,
//   they do not count toward NUM_INPUT_PADS).
`ifdef SLOT_WORKSHOP

// Power/ground pads for core and I/O
`define NUM_DVDD_PADS 4
`define NUM_DVSS_PADS 4

// Signal pads.  NUM_INPUT_PADS is 1 (not 0) to avoid the Yosys
// zero-width-vector quirk on `input_PAD2CORE[-1:0]` which otherwise
// materialises two undriven bits and trips the post-synth check.
// The single input_pad is listed in slot_workshop.yaml as
// inputs[0].pad near the SW corner.
`define NUM_INPUT_PADS 1
`define NUM_BIDIR_PADS 20
`define NUM_ANALOG_PADS 60

`endif
