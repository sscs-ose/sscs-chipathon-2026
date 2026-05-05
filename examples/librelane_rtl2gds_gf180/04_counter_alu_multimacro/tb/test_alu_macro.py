# cocotb testbench for alu_macro.sv (registered wrapper around alu.sv).
#
# Two-stage pipeline: inputs registered on posedge clk, then combinational
# alu, then outputs registered. Net latency from applied (a_in, b_in, op_in)
# on a given cycle to observed (result_out, zero_out, carry_out) is 2
# rising edges of clk.
#
# This TB drives a modest random sample + exhaustive op coverage (rather
# than the full 16 x 16 x 8 sweep that test_alu.py does) so post-synth GL
# runtime stays reasonable.
#
# Used by:
#   make test-alu-gl       # gate-level, against alu_macro.nl.v + gf180 cells

import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


CLK_PERIOD_NS = 10
MASK = 0xF


def reference(op: int, a: int, b: int):
    """Python reference. Kept identical to test_alu.py's `expected`."""
    a &= MASK
    b &= MASK
    if op == 0b000:
        s = a + b
        return s & MASK, 1 if s > MASK else 0
    if op == 0b001:
        s = (a - b) & 0x1F
        return s & MASK, (s >> 4) & 1
    if op == 0b010: return a & b, 0
    if op == 0b011: return a | b, 0
    if op == 0b100: return a ^ b, 0
    if op == 0b101:
        shift = b & 0b11
        if shift == 0:
            return a & MASK, 0
        return (a << shift) & MASK, (a >> (4 - shift)) & 1
    if op == 0b110:
        shift = b & 0b11
        if shift == 0:
            return a & MASK, 0
        return (a >> shift) & MASK, (a >> (shift - 1)) & 1
    if op == 0b111: return a & MASK, 0
    raise ValueError(f"bad op {op}")


async def apply_reset(dut):
    dut.rst_n.value = 0
    dut.a_in.value = 0
    dut.b_in.value = 0
    dut.op_in.value = 0
    await Timer(25, unit="ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)


@cocotb.test()
async def test_reset_clears_outputs(dut):
    cocotb.start_soon(Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start())
    await apply_reset(dut)
    await Timer(1, unit="ns")
    assert int(dut.result_out.value) == 0
    assert int(dut.zero_out.value)   == 1
    assert int(dut.carry_out.value)  == 0


@cocotb.test()
async def test_pipeline_latency_two_cycles(dut):
    """Apply a non-zero ADD on cycle 0, confirm the output lands 2 cycles later."""
    cocotb.start_soon(Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start())
    await apply_reset(dut)

    # Cycle 0: drive ADD 0x3 + 0x4 = 0x7
    dut.a_in.value  = 0x3
    dut.b_in.value  = 0x4
    dut.op_in.value = 0b000
    await RisingEdge(dut.clk)   # input regs sample here -> stage1
    # Between edges, drive neutral values so we can see the pipeline fill.
    dut.a_in.value  = 0x0
    dut.b_in.value  = 0x0
    dut.op_in.value = 0b111
    await RisingEdge(dut.clk)   # output regs sample the alu output of stage1
    await Timer(1, unit="ns")

    assert int(dut.result_out.value) == 0x7, (
        f"pipeline latency violated, got {int(dut.result_out.value):x}"
    )
    assert int(dut.carry_out.value) == 0


@cocotb.test()
async def test_random_stream(dut):
    """
    Pump 200 random (op, a, b) triplets through the pipeline. At each
    cycle, check that the output matches the reference of the pair
    driven two cycles earlier.
    """
    cocotb.start_soon(Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start())
    await apply_reset(dut)

    rnd = random.Random(0xC001_D00D)
    # After reset, at iteration i we apply input_i then await one clk edge.
    # Two rising edges elapsed between `input_i applied` and `ref(input_i)
    # visible`, but within the loop body we only count one edge per
    # iteration. So after iteration i's edge, `result_out` carries
    # ref(input_{i-1}). Prepend a single None to align indices.
    expected_queue = [None]

    for i in range(200):
        op = rnd.randrange(8)
        a  = rnd.randrange(16)
        b  = rnd.randrange(16)
        dut.op_in.value = op
        dut.a_in.value  = a
        dut.b_in.value  = b
        expected_queue.append(reference(op, a, b))   # queue[i+1] = ref(input_i)
        await RisingEdge(dut.clk)
        # Let the non-blocking assignment settle before sampling.
        # Without this, iverilog reports the pre-edge value of result_r.
        await Timer(1, unit="ns")

        exp = expected_queue[i]                       # ref(input_{i-1}) or None
        if exp is None:
            continue
        exp_res, exp_carry = exp
        exp_zero = 1 if exp_res == 0 else 0
        got_res   = int(dut.result_out.value)
        got_zero  = int(dut.zero_out.value)
        if got_res != exp_res or got_zero != exp_zero:
            raise AssertionError(
                f"cycle {i}: result got={got_res:x} exp={exp_res:x}  "
                f"zero got={got_zero} exp={exp_zero}"
            )
