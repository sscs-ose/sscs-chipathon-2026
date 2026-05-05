// 4-bit ALU with 8 operations. Combinational; hardened as an
// independent macro in the chipathon multi-macro example.
//
//   op=3'b000  ADD    result = a + b              carry = cout
//   op=3'b001  SUB    result = a - b              carry = borrow
//   op=3'b010  AND    result = a & b              carry = 0
//   op=3'b011  OR     result = a | b              carry = 0
//   op=3'b100  XOR    result = a ^ b              carry = 0
//   op=3'b101  SHL    result = a << b[1:0]        carry = last bit shifted out
//   op=3'b110  SHR    result = a >> b[1:0]        carry = last bit shifted out
//   op=3'b111  PASS   result = a                  carry = 0
//
// Flags:
//   zero   set when result == 0
//   carry  as documented per-op

`default_nettype none

module alu #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [2:0]       op,
    output wire [WIDTH-1:0] result,
    output wire             zero,
    output wire             carry
);

    logic [WIDTH:0]   addsub_ext;
    logic [WIDTH-1:0] res;
    logic             cy;

    always_comb begin
        res        = '0;
        cy         = 1'b0;
        addsub_ext = '0;
        unique case (op)
            3'b000: begin  // ADD
                addsub_ext = {1'b0, a} + {1'b0, b};
                res        = addsub_ext[WIDTH-1:0];
                cy         = addsub_ext[WIDTH];
            end
            3'b001: begin  // SUB (borrow in top bit on a<b)
                addsub_ext = {1'b0, a} - {1'b0, b};
                res        = addsub_ext[WIDTH-1:0];
                cy         = addsub_ext[WIDTH];
            end
            3'b010: res = a & b;
            3'b011: res = a | b;
            3'b100: res = a ^ b;
            3'b101: begin  // SHL by b[1:0]
                unique case (b[1:0])
                    2'd0: begin res = a;                          cy = 1'b0;        end
                    2'd1: begin res = {a[WIDTH-2:0], 1'b0};       cy = a[WIDTH-1];  end
                    2'd2: begin res = {a[WIDTH-3:0], 2'b0};       cy = a[WIDTH-2];  end
                    2'd3: begin res = {a[WIDTH-4:0], 3'b0};       cy = a[WIDTH-3];  end
                endcase
            end
            3'b110: begin  // SHR by b[1:0]
                unique case (b[1:0])
                    2'd0: begin res = a;        cy = 1'b0;   end
                    2'd1: begin res = a >> 1;   cy = a[0];   end
                    2'd2: begin res = a >> 2;   cy = a[1];   end
                    2'd3: begin res = a >> 3;   cy = a[2];   end
                endcase
            end
            3'b111: res = a;                                  // PASS
        endcase
    end

    assign result = res;
    assign zero   = (res == '0);
    assign carry  = cy;

endmodule

`default_nettype wire
