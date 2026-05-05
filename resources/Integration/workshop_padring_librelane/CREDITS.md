# Credits

Per-artifact attribution for this fork.

## Template, flow, Nix flake, Makefile skeleton, cocotb scaffolding

**Leo Moser** and the [wafer-space](https://wafer-space.com/)
contributors, from the upstream project:

- https://github.com/wafer-space/gf180mcu-project-template
- Pinned at `8bd0f6ff28947bf222c5288343f8f3ee1fc04632`
  ("chore: update flake to librelane 3.0", 2026-03-26)
- Apache License 2.0

The Nix flake (`flake.nix`, `flake.lock`) pins LibreLane 3.0.0 with
nix-eda and nixpkgs `nixos-25.11`. OpenROAD and the rest of the flow
come from that pin.

The wafer-space fork of the GF180MCU PDK
(https://github.com/wafer-space/gf180mcu), pinned at tag `1.8.0`, is
cloned at build time by `make clone-pdk`.

## Workshop padring — pad count, cell selection, index mapping, die size

**Juan Moya**, from the standalone padring config:

- https://github.com/JuanMoya/padring_gf180
- `Workshop_CASS/padring/workshop_padring.cfg`
- Apache License 2.0

`librelane/slots/slot_workshop.yaml` is a 1:1 port of Juan Moya's
pad layout:

- Same die (2935 × 2935 µm).
- Same 60 analog + 20 bidir + 4 DVDD + 4 DVSS + clk + rst_n + 4 corners.
- Same pad-index mapping:
  - `analog[i].pad = ana<i+1>`
  - `bidir[i].pad = config<i+1>`
  - `dvdd_pads[0..3] = {vdd_ana1 (N), vdd_dig1 (E), vdd_ana2 (S), vdd_dig4 (W)}`
  - `dvss_pads[0..3] = {vss_ana1 (N), vss_dig2 (E), vss_ana2 (S), vss_dig3 (W)}`

Changes this fork introduces relative to Juan Moya's config:

- Cell flavours follow the wafer-space template (bidir uses `bi_24t`
  instead of `bi_t`; DVDD/DVSS use `gf180mcu_ws_io__dvdd/dvss`
  instead of `gf180mcu_fd_io__dvdd/dvss`) to match the rest of the
  project.
- `PAD_NORTH` and `PAD_WEST` lists are reversed because LibreLane
  reads pad lists clockwise from the SW corner, whereas the
  standalone padring tool reads them in Juan Moya's documented order.
- `inputs[0].pad` is threaded through `PAD_SOUTH` to sidestep a Yosys
  zero-width-vector quirk (`NUM_INPUT=1` in `slot_defines.svh`);
  Juan Moya's config has no such constraint since the standalone
  tool does not synthesise the RTL.

## Workshop-slot commit (fork-specific)

**Mauricio Montanares** — `git log upstream/main..main`:

- `src/slot_defines.svh`, `src/chip_core.sv`
- `librelane/config.yaml`, `librelane/pdn_cfg.tcl`, `librelane/slots/slot_workshop.yaml`
- `Makefile` (`AVAILABLE_SLOTS += workshop`)

## Reference validation

The fork was validated end-to-end against a reference build produced
on 2026-04-23 with LibreLane 3.0.0 + wafer-space PDK 1.8.0: clean on
Magic DRC, KLayout DRC, Netgen LVS, KLayout antenna, and setup/hold
STA across 3 corners. Total runtime 2h 15m; final die 84 922
instances (28 563 stdcells + fillers/taps + chip_id + logo macros).

## License

All third-party attributions above use the Apache License, Version
2.0. The fork-specific additions are released under the same license.
