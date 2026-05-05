# cocotb testbench for counter.sv
#
# Runs with Icarus Verilog (SIM=icarus). Invoke via the Makefile:
#     make test-counter
#
# Exercises: async reset, sync enable, 8-bit increment, 256-cycle wrap.

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


CLK_PERIOD_NS = 10


async def _apply_reset(dut):
    """Assert async reset for a couple of cycles, then release."""
    dut.en.value = 0
    dut.rst_n.value = 0
    await Timer(25, unit="ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)


@cocotb.test()
async def test_reset_clears_counter(dut):
    cocotb.start_soon(Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start())
    await _apply_reset(dut)
    await Timer(1, unit="ns")
    assert int(dut.q.value) == 0, (
        f"Counter should be 0 immediately after reset, got {int(dut.q.value)}"
    )


@cocotb.test()
async def test_increment_with_enable(dut):
    cocotb.start_soon(Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start())
    await _apply_reset(dut)

    dut.en.value = 1
    # Count exactly 10 rising edges.
    for _ in range(10):
        await RisingEdge(dut.clk)
    await Timer(1, unit="ns")
    assert int(dut.q.value) == 10, f"Expected q=10, got {int(dut.q.value)}"


@cocotb.test()
async def test_freeze_when_disabled(dut):
    cocotb.start_soon(Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start())
    await _apply_reset(dut)

    dut.en.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)
    await Timer(1, unit="ns")
    assert int(dut.q.value) == 0, "Counter should stay at 0 while en=0"

    # Now enable, count 3 cycles.
    dut.en.value = 1
    for _ in range(3):
        await RisingEdge(dut.clk)
    await Timer(1, unit="ns")
    assert int(dut.q.value) == 3, f"Expected q=3 after enabling, got {int(dut.q.value)}"

    # Disable again and confirm freeze at current value.
    dut.en.value = 0
    for _ in range(4):
        await RisingEdge(dut.clk)
    await Timer(1, unit="ns")
    assert int(dut.q.value) == 3, f"Counter should freeze at 3, got {int(dut.q.value)}"


@cocotb.test()
async def test_wrap_after_256_cycles(dut):
    cocotb.start_soon(Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start())
    await _apply_reset(dut)

    dut.en.value = 1
    for _ in range(256):
        await RisingEdge(dut.clk)
    await Timer(1, unit="ns")
    assert int(dut.q.value) == 0, (
        f"8-bit counter should wrap to 0 after 256 cycles, got {int(dut.q.value)}"
    )
