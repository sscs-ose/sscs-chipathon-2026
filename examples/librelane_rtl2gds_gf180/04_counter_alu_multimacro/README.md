# Example 04 - counter + ALU multi-macro

Two RTL modules, each hardened independently as a LibreLane macro,
then stitched into the chipathon-2026 workshop padring.

![multi-macro hierarchy](../../diagrams/multi_macro_hierarchy.svg)

Verification chain the notebook walks end to end:

![multi-macro verification](../../diagrams/multi_macro_verification.svg)

## Files

```
04_counter_alu_multimacro/
|-- 04_counter_alu_multimacro.ipynb   # the walkthrough
|-- README.md                          # this file
|-- rtl/
|   |-- counter.sv                     # 8-bit counter (register + async reset)
|   |-- alu.sv                         # pure combinational 4-bit ALU, 8 ops
|   |-- alu_macro.sv                   # registered wrapper around alu.sv
|   `-- chip_core_multi.sv             # chip_core replacement: instantiates both macros
|-- tb/
|   |-- Makefile                       # dispatcher: test-{counter,alu,alu-macro} (RTL + GL)
|   |-- Makefile.cocotb                # cocotb standard include
|   |-- timescale.v                    # 1ns/1ps for GL sim against gf180 cells
|   |-- test_counter.py                # 4 cocotb tests (reset/increment/enable/wrap)
|   |-- test_alu.py                    # exhaustive 16 x 16 x 8 sweep on the comb ALU
|   `-- test_alu_macro.py              # 3 cocotb tests on the registered ALU wrapper
`-- librelane/
    |-- counter_macro.yaml             # Classic flow config for counter
    |-- alu_macro.yaml                 # Classic flow config for alu_macro
    `-- chip_top_multi_patch.yaml      # reference shape of the chip-top patch
```

## What the example demonstrates

1. **Per-macro verification (cocotb).** The 8-bit counter's freeze /
   wrap behaviour and the full 16 x 16 truth table of the 4-bit ALU
   across its 8 ops.
2. **Standalone hardening (LibreLane Classic flow).** Each macro goes
   through synth + floorplan + PDN + placement + CTS + routing + DRC
   + LVS + STA in isolation, producing a reusable set of
   `GDS / LEF / lib / netlist` views.
3. **Chip-top integration.** The notebook merges a `MACROS:` dict and
   new `PDN_MACRO_CONNECTIONS` entries into the padring fork's
   `librelane/config.yaml`, then runs `SLOT=workshop make librelane`
   against the full Chip flow. The two user macros sit inside the
   workshop padring alongside the inherited `chip_id` and
   `wafer.space` logo macros.

## RTL summary

**counter.sv** -- 8-bit up-counter with active-low async reset and
synchronous enable. Wraps every 256 cycles.

**alu.sv** -- combinational 4-bit ALU with 8 operations:

| op    | name | result        | carry          |
|-------|------|---------------|----------------|
| 3'b000 | ADD  | a + b         | carry out      |
| 3'b001 | SUB  | a - b         | borrow         |
| 3'b010 | AND  | a & b         | 0              |
| 3'b011 | OR   | a \| b        | 0              |
| 3'b100 | XOR  | a ^ b         | 0              |
| 3'b101 | SHL  | a << b[1:0]   | last bit out   |
| 3'b110 | SHR  | a >> b[1:0]   | last bit out   |
| 3'b111 | PASS | a             | 0              |

Flag `zero` is set when `result == 0`.

**alu_macro.sv** -- 2-stage registered wrapper (input regs + output
regs) around `alu.sv`, so the Classic flow has a clocked design to
work with. The unpipelined `alu.sv` is what the cocotb test
exercises; the wrapped version is what gets hardened and instantiated
in `chip_core_multi.sv`.

**chip_core_multi.sv** -- drop-in replacement for the fork's
`src/chip_core.sv`. Instantiates both macros WITHOUT parameter
overrides: the hardened `.nl.v` netlists carry no parameters (yosys
bakes them in during synthesis), so keeping `#(.WIDTH(...))` on the
instance here triggers a Verilator lint error *Parameter not found:
'WIDTH'* during the Chip-flow lint stage. Wires:

```
counter.en      = input_in[0]            (spare input pad)
alu_macro.a_in  = counter.q[3:0]
alu_macro.b_in  = counter.q[7:4]
alu_macro.op_in = counter.q[7:5]         (cycles through all 8 ops as the counter climbs)
```

And exposes on `bidir_out[19:0]`:

```
[7:0]    counter q                       (observation)
[11:8]   alu_macro result
[12]     alu_macro zero flag
[13]     alu_macro carry / borrow
[16:14]  current op (= counter[7:5])
[19:17]  tied 0
```

So a chipathon participant can hook a logic analyzer on the 20 bidir
pads and watch the ALU output track the counter by one clock cycle.

## Running the example

```bash
jupyter lab 04_counter_alu_multimacro.ipynb
```

Flip the `RUN_*` flags in Step 0, then run cells top to bottom.
Runtime budget (measured on a modern 32-core workstation, 2026-04-25):

| Step                           | Runtime    | What runs |
|--------------------------------|------------|-----------|
| cocotb RTL sim                 | ~15 s      | counter + alu tests |
| harden counter macro           | ~1.5 min   | Classic flow, signoff clean |
| harden alu_macro               | ~1.5 min   | Classic flow, signoff clean |
| cocotb GL sim                  | ~15 s      | counter.nl.v + alu_macro.nl.v + gf180 cells |
| chip-top flow (SLOT=workshop)  | ~60-90 min | Chip flow + Magic DRC + Netgen LVS |

## Prerequisites

- `gf180` container running (`scripts/bootstrap_container.sh` at the
  repo root starts it).
- Padring fork + wafer-space PDK cloned under
  `~/eda/designs/chipathon_padring/template/` (the notebook handles
  these behind `RUN_CLONE_FORK` / `RUN_CLONE_PDK`).
