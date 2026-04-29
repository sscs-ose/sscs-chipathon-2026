// Chipathon multi-macro demo `chip_core`.
// Overrides `src/chip_core.sv` of the chipathon-2026 padring fork to
// instantiate two independent hardened macros (`counter` and `alu`)
// and wire them into the workshop slot's 20 bidir pads.
//
// Interconnect:
//   counter.en   = input_in[0]           spare input pad drives enable
//   alu_macro.a  = counter.q[3:0]        low nibble of counter
//   alu_macro.b  = counter.q[7:4]        high nibble
//   alu_macro.op = counter.q[7:5]        cycles through 8 ops as counter climbs
//
// Output mapping on bidir_out[19:0]:
//   [7:0]    counter q (observation)
//   [11:8]   alu result (registered, +1 cycle latency)
//   [12]     alu zero flag
//   [13]     alu carry / borrow
//   [16:14]  current alu op (= counter[7:5])
//   [19:17]  tied to 0
//
// Analog pads pass through untouched.

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

    input  wire clk,
    input  wire rst_n,

    input  wire [NUM_INPUT_PADS-1:0] input_in,
    output wire [NUM_INPUT_PADS-1:0] input_pu,
    output wire [NUM_INPUT_PADS-1:0] input_pd,

    input  wire [NUM_BIDIR_PADS-1:0] bidir_in,
    output wire [NUM_BIDIR_PADS-1:0] bidir_out,
    output wire [NUM_BIDIR_PADS-1:0] bidir_oe,
    output wire [NUM_BIDIR_PADS-1:0] bidir_cs,
    output wire [NUM_BIDIR_PADS-1:0] bidir_sl,
    output wire [NUM_BIDIR_PADS-1:0] bidir_ie,
    output wire [NUM_BIDIR_PADS-1:0] bidir_pu,
    output wire [NUM_BIDIR_PADS-1:0] bidir_pd,

    inout  wire [NUM_ANALOG_PADS-1:0] analog
);

    // ---- default-safe pad controls (copy-paste boilerplate) ----
    assign input_pu = '0;
    assign input_pd = '0;
    assign bidir_oe = '1;   // drive outwards
    assign bidir_cs = '0;   // CMOS buffer, not Schmitt
    assign bidir_sl = '0;   // fast slew
    assign bidir_ie = ~bidir_oe;
    assign bidir_pu = '0;
    assign bidir_pd = '0;

    // ---- counter macro ----
    // Parameter WIDTH is baked into the hardened GDS (WIDTH=8), so we
    // do NOT override it on the instance. After synthesis, yosys emits
    // a parameterless module in counter.nl.v; passing #(.WIDTH(...))
    // here would produce a lint error "Parameter not found: 'WIDTH'".
    wire [7:0] count_q;

    counter u_counter (
        .clk   (clk),
        .rst_n (rst_n),
        .en    (input_in[0]),
        .q     (count_q)
    );

    // ---- ALU macro (registered wrapper; alu.sv is pure combinational) ----
    // The wrapped version is the one hardened standalone. Its 2-stage
    // pipeline adds one clock of latency relative to the counter; the
    // output observed on bidir pads therefore tracks the counter by one
    // cycle. Parameter WIDTH=4 is baked into the hardened macro (see
    // comment above on counter for why we drop the override here).
    wire [3:0] alu_result;
    wire       alu_zero;
    wire       alu_carry;

    alu_macro u_alu (
        .clk        (clk),
        .rst_n      (rst_n),
        .a_in       (count_q[3:0]),
        .b_in       (count_q[7:4]),
        .op_in      (count_q[7:5]),
        .result_out (alu_result),
        .zero_out   (alu_zero),
        .carry_out  (alu_carry)
    );

    // ---- pad output mapping ----
    assign bidir_out = {
        3'b000,         // [19:17] reserved
        count_q[7:5],   // [16:14] current op
        alu_carry,      // [13]
        alu_zero,       // [12]
        alu_result,     // [11:8]
        count_q         // [7:0]
    };

    // Keep unused pad inputs from being dropped by synthesis.
    logic _unused;
    assign _unused = &{1'b0, bidir_in};

endmodule

`default_nettype wire
