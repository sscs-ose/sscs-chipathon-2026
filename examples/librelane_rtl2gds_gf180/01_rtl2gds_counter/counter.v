// 4-bit synchronous up-counter with active-high reset.
// Tiny on purpose: the full LibreLane flow runs in ~1-2 minutes.

module counter (
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] q
);
    reg [3:0] cnt;

    always @(posedge clk) begin
        if (rst)
            cnt <= 4'b0;
        else
            cnt <= cnt + 4'b1;
    end

    assign q = cnt;
endmodule
