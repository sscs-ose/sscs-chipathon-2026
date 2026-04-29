// SPDX-FileCopyrightText: 2026 Chipathon 2026 workshop
// SPDX-License-Identifier: Apache-2.0
//
// Minimal chip_core for the Chipathon 2026 workshop padring slot.
// The emphasis of this slot is the padring itself (60 analog + 20
// bidir + 4/4 power + clk/rst_n); the core is intentionally trivial:
// a free-running counter whose state drives the 20 bidir pads. The
// 60 analog pads are routed straight through to analog[] and stay
// unconnected at the core level (the intent is that a downstream
// design wires them to custom analog IP later).

`default_nettype none

module chip_core #(
    parameter NUM_INPUT_PADS,
    parameter NUM_BIDIR_PADS,
    parameter NUM_ANALOG_PADS
    )(
    `ifdef USE_POWER_PINS
    inout  wire VDD,
    inout  wire VSS,
    `endif

    input  wire clk,       // clock
    input  wire rst_n,     // reset (active low)

    input  wire [NUM_INPUT_PADS-1:0] input_in,   // Input value
    output wire [NUM_INPUT_PADS-1:0] input_pu,   // Pull-up
    output wire [NUM_INPUT_PADS-1:0] input_pd,   // Pull-down

    input  wire [NUM_BIDIR_PADS-1:0] bidir_in,   // Input value
    output wire [NUM_BIDIR_PADS-1:0] bidir_out,  // Output value
    output wire [NUM_BIDIR_PADS-1:0] bidir_oe,   // Output enable
    output wire [NUM_BIDIR_PADS-1:0] bidir_cs,   // Input type (0=CMOS, 1=Schmitt)
    output wire [NUM_BIDIR_PADS-1:0] bidir_sl,   // Slew rate (0=fast, 1=slow)
    output wire [NUM_BIDIR_PADS-1:0] bidir_ie,   // Input enable
    output wire [NUM_BIDIR_PADS-1:0] bidir_pu,   // Pull-up
    output wire [NUM_BIDIR_PADS-1:0] bidir_pd,   // Pull-down

    inout  wire [NUM_ANALOG_PADS-1:0] analog    // Analog
);

    // Disable pull-up and pull-down on any discrete input pads.
    assign input_pu = '0;
    assign input_pd = '0;

    // Drive the bidir pads as outputs (CMOS buffer, fast slew).
    assign bidir_oe = '1;
    assign bidir_cs = '0;
    assign bidir_sl = '0;
    assign bidir_ie = ~bidir_oe;
    assign bidir_pu = '0;
    assign bidir_pd = '0;

    // Keep synthesis from optimising bidir_in / input_in away.
    logic _unused;
    assign _unused = &{1'b0, bidir_in, input_in};

    // Free-running counter, width equal to the number of bidir pads.
    logic [NUM_BIDIR_PADS-1:0] count;
    always_ff @(posedge clk) begin
        if (!rst_n) count <= '0;
        else        count <= count + 1;
    end
    assign bidir_out = count;

endmodule

`default_nettype wire
