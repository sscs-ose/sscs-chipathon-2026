// Registered wrapper around the combinational `alu`. Used only when
// hardening the ALU as a standalone LibreLane macro: the Classic flow
// expects a clocked design (for placement/CTS/timing-aware routing), so
// we register the operand inputs and the result output around the same
// combinational core.
//
// The unregistered `alu` module is the one exercised by the cocotb test
// and can still be instantiated directly inside `chip_core_multi.sv`
// if 0-latency behaviour is desired. The multi-macro example
// instantiates this wrapped `alu_macro` in the chip top so the same
// GDS used for integration is the one hardened standalone.

`default_nettype none

module alu_macro #(
    parameter WIDTH = 4
)(
    input  wire              clk,
    input  wire              rst_n,
    input  wire [WIDTH-1:0]  a_in,
    input  wire [WIDTH-1:0]  b_in,
    input  wire [2:0]        op_in,
    output wire [WIDTH-1:0]  result_out,
    output wire              zero_out,
    output wire              carry_out
);

    logic [WIDTH-1:0] a_r, b_r, result_r;
    logic [2:0]       op_r;
    logic             zero_r, carry_r;

    wire  [WIDTH-1:0] result_w;
    wire              zero_w;
    wire              carry_w;

    // Register inputs.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_r  <= '0;
            b_r  <= '0;
            op_r <= '0;
        end else begin
            a_r  <= a_in;
            b_r  <= b_in;
            op_r <= op_in;
        end
    end

    // Combinational core.
    alu #(.WIDTH(WIDTH)) u_alu (
        .a      (a_r),
        .b      (b_r),
        .op     (op_r),
        .result (result_w),
        .zero   (zero_w),
        .carry  (carry_w)
    );

    // Register outputs.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_r <= '0;
            zero_r   <= 1'b0;
            carry_r  <= 1'b0;
        end else begin
            result_r <= result_w;
            zero_r   <= zero_w;
            carry_r  <= carry_w;
        end
    end

    assign result_out = result_r;
    assign zero_out   = zero_r;
    assign carry_out  = carry_r;

endmodule

`default_nettype wire
