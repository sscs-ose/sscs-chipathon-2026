// 8-bit synchronous up-counter with active-low async reset and enable.
// Hardened as an independent macro in the chipathon multi-macro example.
//
//   clk    rising-edge clock.
//   rst_n  active-low asynchronous reset. Clears q to 0.
//   en     synchronous enable. Counter freezes when en=0.
//   q      8-bit count value.
//
// Wraps every 256 cycles.

`default_nettype none

module counter #(
    parameter WIDTH = 8
)(
    input  wire              clk,
    input  wire              rst_n,
    input  wire              en,
    output wire [WIDTH-1:0]  q
);

    logic [WIDTH-1:0] cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)       cnt <= '0;
        else if (en)      cnt <= cnt + 1'b1;
    end

    assign q = cnt;

endmodule

`default_nettype wire
