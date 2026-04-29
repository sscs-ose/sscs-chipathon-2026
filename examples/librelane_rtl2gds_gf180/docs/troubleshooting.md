# Troubleshooting

Symptoms seen in the wild across the five notebooks, with the
smallest fix for each.

## Docker

**`docker: command not found`**. Install Docker Engine and put your
user in the `docker` group. You should be able to run `docker ps`
without `sudo`.

**`Error response from daemon: Conflict. The container name "/gf180"
is already in use`**. You already have a `gf180` container. Options:

- Reuse it: `docker start gf180` (if stopped). The notebooks will
  find it.
- Replace it: `docker stop gf180 && docker rm gf180 && scripts/bootstrap_container.sh`.

**`Cannot connect to the Docker daemon`**. The daemon is not running,
or your user is not in the `docker` group.

## PDK

**`LibreLane exits non-zero on a PDK glob`**. The container's default
PDK is IHP-SG13G2; we need GF180MCU. Every notebook cell that
invokes LibreLane sources `sak-pdk-script.sh gf180mcuD
gf180mcu_fd_sc_mcu7t5v0` first. If you drive LibreLane yourself, do
the same plus set `--pdk gf180mcuD`, `--pdk-root <path-to-wafer-space-fork>`,
`--manual-pdk`.

**`unknown cell gf180mcu_fd_io__...`**. The stock `ciel` PDK at
`/foss/pdks/gf180mcuD/` is not the wafer-space fork and lacks the
padring I/O cells. Clone the fork:

```bash
cd ~/eda/designs/chipathon_padring/template
git clone --depth 1 --branch 1.8.0 \
    https://github.com/wafer-space/gf180mcu.git gf180mcu
```

Notebooks 03 and 04 do this automatically behind `RUN_CLONE_PDK`.

## Yosys / synthesis

**Post-synth check trips on `input_PAD2CORE[-1:0]`**. Your slot has
`NUM_INPUT_PADS = 0` and hit the zero-width-vector quirk. The
workshop slot already sets `NUM_INPUT_PADS = 1` and wires a dummy
`inputs[0].pad` in `PAD_SOUTH` -- if you are using a different slot
you need to do the same.

**`gf180mcu_fd_ip_sram__sram512x8m8wm1` not found**. You are running
notebook 02's config but forgot to keep the sram_1 MACRO entry (we
only replaced sram_0 with the counter). Re-run the patch cell, or
inspect the diff against the stock `librelane/config.yaml`.

## Cocotb (notebook 04)

**`make: cocotb-config: command not found`**. You are running the TB
on the host instead of inside the container. Use `docker exec gf180`
(the notebook does this automatically).

**`Error: This version of Icarus requires some_flag`**. The iic-osic
image's Icarus is pinned; if a future update changes invocation
conventions, pin the image to a dated tag (e.g.
`hpretl/iic-osic-tools:2026.04.13`) in `scripts/bootstrap_container.sh`.

**`VPI: Couldn't find root handle <module>`** when switching from
`test-counter` to `test-alu`. Both targets wrote their vvp into the
same `sim_build/` and the second target finds the first target's
toplevel. The Makefile now uses per-target `SIM_BUILD=sim_build_X`;
if you still see this, run `make clean` first.

## Cocotb gate-level (example 04 Step 5b)

**`Bad 'period': Unable to accurately represent 10(ns) with the
simulator precision of 1e0`**. iverilog fell back to 1s/1s precision
because no `` `timescale `` directive was found. The fix is
`tb/timescale.v`, a one-line `` `timescale 1ns/1ps ``, which the
Makefile compiles first.

**GL TB sees pre-edge values after `await RisingEdge(clk)`**. Sample
registered outputs after an extra `await Timer(1, units="ns")` --
otherwise iverilog returns the value of the register just before the
posedge. `test_alu_macro.py` does this at every iteration.

## LibreLane chip-top config (example 04 Step 6)

**`'MACROS.counter.lib.*[0]' invalid: '.../counter.lib' does not
exist`**. The `--save-views-to` directory holds `lib/<corner>/<name>__
<corner>.lib`, not a single `<name>.lib`. Build a full 9-entry
`{corner: [path]}` map (see `librelane/chip_top_multi_patch.yaml`).

**`Refusing to automatically convert value at
'PDN_MACRO_CONNECTIONS[0]' to a string`**. `PDN_MACRO_CONNECTIONS` is
`List[str]` in LibreLane v3.0.2 -- each entry is `"<regex> <vdd>
<vss> <vdd_pin> <vss_pin>"`, not a dict.

**Verilator lint `Parameter not found: 'WIDTH'`** on the chip-flow's
synth step. The hardened `<macro>.nl.v` is a parameterless
synthesised netlist; instances in `chip_core.sv` must not override
parameters. Drop `#(.WIDTH(8))` on the instantiation.

## LibreLane flow stuck

**Stuck on Magic DRC for > 20 min**. Magic DRC is O(polygon count)
and single-threaded; on a slow host the chipathon slot can take a
full hour. Not a bug.

**Stuck on OpenROAD CTS**. The Classic flow expects a clock. For the
combinational ALU, wrap it in a registered `alu_macro.sv` (notebook
04 does this). If you really want a combinational macro, set
`substituting_steps: { OpenROAD.CTS: null }` in the YAML -- expect
surprises downstream.

**`PDN_CORE_RING cannot be used when PDN_MULTILAYER is set to
false`**. Leave `PDN_MULTILAYER` at its default (true) for the
chip-top configs.

## Notebook kernel

**`NameError: name 'RUN_CLONE_FORK' is not defined`**. You jumped
past the Step 0 config cell. Restart the kernel and run cells top
to bottom.

**Render PNG blank**. Open the GDS on the host:

```bash
klayout ~/eda/designs/chipathon_padring/template/final/gds/chip_top.gds
```

Headless KLayout PNG export sometimes fights Qt inside the container.
The GDS itself is fine.

## Disk pressure

**"No space left on device"**. LibreLane runs accumulate fast:

```bash
rm -rf ~/eda/designs/*/runs   # all in-progress and old runs
rm -rf ~/eda/designs/*/final  # committed outputs
du -sh ~/eda/designs/*         # see what grew
```

A full chipathon slot run produces ~85 MB of GDS + many GB of
intermediate artifacts. Keep `final/gds/chip_top.gds` +
`final/metrics.csv` + `final/render/chip_top.png` and wipe the rest
once you have what you need.
