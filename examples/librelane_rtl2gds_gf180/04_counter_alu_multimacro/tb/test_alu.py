# cocotb testbench for alu.sv (pure combinational).
#
# Runs with Icarus Verilog. Invoke via the Makefile:
#     make test-alu
#
# Sweeps all 16 x 16 = 256 (a, b) pairs for each of the 8 ops, checking
# result + zero + carry against a Python reference.

import cocotb
from cocotb.triggers import Timer


OP_NAMES = {
    0b000: "ADD",
    0b001: "SUB",
    0b010: "AND",
    0b011: "OR",
    0b100: "XOR",
    0b101: "SHL",
    0b110: "SHR",
    0b111: "PASS",
}

MASK = 0xF  # 4-bit


def expected(op: int, a: int, b: int):
    """Return (result_4b, carry_bit) per the ALU spec."""
    a &= MASK
    b &= MASK
    if op == 0b000:   # ADD
        s = a + b
        return s & MASK, 1 if s > MASK else 0
    if op == 0b001:   # SUB
        s = (a - b) & 0x1F   # 5-bit two's complement view
        return s & MASK, (s >> 4) & 1     # borrow lands in bit 4
    if op == 0b010: return a & b, 0
    if op == 0b011: return a | b, 0
    if op == 0b100: return a ^ b, 0
    if op == 0b101:   # SHL by b[1:0]
        shift = b & 0b11
        if shift == 0:
            return a & MASK, 0
        # Bit shifted out last = bit at position (4-shift) of the original.
        return (a << shift) & MASK, (a >> (4 - shift)) & 1
    if op == 0b110:   # SHR by b[1:0]
        shift = b & 0b11
        if shift == 0:
            return a & MASK, 0
        return (a >> shift) & MASK, (a >> (shift - 1)) & 1
    if op == 0b111: return a & MASK, 0
    raise ValueError(f"bad op {op}")


@cocotb.test()
async def test_alu_all_operations(dut):
    fails = []
    for op in range(8):
        for a in range(16):
            for b in range(16):
                dut.a.value  = a
                dut.b.value  = b
                dut.op.value = op
                await Timer(1, unit="ns")

                got_res   = int(dut.result.value)
                got_zero  = int(dut.zero.value)
                got_carry = int(dut.carry.value)

                exp_res, exp_carry = expected(op, a, b)
                exp_zero = 1 if exp_res == 0 else 0

                if got_res != exp_res or got_zero != exp_zero:
                    fails.append(
                        f"op={OP_NAMES[op]} a={a:x} b={b:x}: "
                        f"result got={got_res:x} exp={exp_res:x}, "
                        f"zero got={got_zero} exp={exp_zero}"
                    )
                    continue

                # Carry only matters for ADD / SUB / SHL / SHR; the others
                # hard-tie it to 0.
                if op in (0b000, 0b001, 0b101, 0b110) and got_carry != exp_carry:
                    fails.append(
                        f"op={OP_NAMES[op]} a={a:x} b={b:x}: "
                        f"carry got={got_carry} exp={exp_carry}"
                    )
                if op in (0b010, 0b011, 0b100, 0b111) and got_carry != 0:
                    fails.append(
                        f"op={OP_NAMES[op]} a={a:x} b={b:x}: "
                        f"carry should be 0 for logic ops, got {got_carry}"
                    )

    if fails:
        head = "\n".join(fails[:20])
        raise AssertionError(
            f"{len(fails)} mismatch(es). First 20:\n{head}"
        )
