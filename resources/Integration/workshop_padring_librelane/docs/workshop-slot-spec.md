# Workshop slot - pad layout specification

This document is the authoritative pad-by-pad mapping for the
`workshop` slot. Everything in it is implemented by
`librelane/slots/slot_workshop.yaml` + `src/slot_defines.svh`. The
layout mirrors Juan Moya's standalone `workshop_padring.cfg`
(https://github.com/JuanMoya/padring_gf180) with the adaptations
required to fit LibreLane's slot model and the wafer-space template.

## Die and core

- **Die**: `[0, 0, 2935, 2935]` um (same as Juan Moya).
- **Core**: `[442, 442, 2493, 2493]` um (padring/sealring halo of 442 um).
- `FP_SIZING: absolute` (fixed die, not computed from cell counts).
- `VERILOG_DEFINES: ["SLOT_WORKSHOP"]` activates the block in
  `src/slot_defines.svh`.

## Pad counts

| Category | Count | Cell | Where it lives |
|----------|------:|------|----------------|
| Analog   | 60    | `gf180mcu_fd_io__asig_5p0` | `analog[0..59]` |
| Bidir    | 20    | `gf180mcu_fd_io__bi_24t`   | `bidir[0..19]` |
| DVDD     | 4     | `gf180mcu_ws_io__dvdd`     | `dvdd_pads[0..3]` |
| DVSS     | 4     | `gf180mcu_ws_io__dvss`     | `dvss_pads[0..3]` |
| Clock    | 1     | `gf180mcu_fd_io__in_s`     | `clk_pad` (stock) |
| Reset    | 1     | `gf180mcu_fd_io__in_c`     | `rst_n_pad` (stock) |
| Input    | 1     | `gf180mcu_fd_io__in_c`     | `inputs[0].pad` (Yosys quirk) |
| Corner   | 4     | `gf180mcu_fd_io__cor`      | inserted by LibreLane |

Totals:
- **92 signal/power pads** + 4 corners.
- **South 24**, **East 22**, **North 22**, **West 22** (= 90) + 2 input
  pads in the SW bundle + 4 corners.

## Why `NUM_INPUT_PADS = 1` (not 0)

The workshop slot exposes only `clk` and `rst_n` as digital inputs,
and both use dedicated single-instance input cells (`clk_pad`,
`rst_n_pad`) rather than the `inputs[]` array. Conceptually
`NUM_INPUT_PADS` should be 0.

In practice, setting `NUM_INPUT_PADS = 0` materialises a
`input_PAD2CORE[-1:0]` vector inside the generate loop in
`chip_top.sv`. Yosys canonicalises that to two undriven bits and the
post-synth integrity check trips. Setting `NUM_INPUT_PADS = 1` plus
a single `inputs[0].pad` entry at the start of `PAD_SOUTH` sidesteps
the issue; the pad is otherwise unused (pulled nowhere, no connection
to `chip_core`).

Chipathon participants can ignore this pad. If you want to use it as
a real input, wire it up in `chip_core.sv` through the existing
`input_in[0]` / `input_pu[0]` / `input_pd[0]` ports.

## Pad index mapping (mirror of Juan Moya)

```
analog[i].pad        = ana<i+1>          # i=0..59
bidir[i].pad         = config<i+1>       # i=0..19
dvdd_pads[0..3].pad  = vdd_ana1 (N), vdd_dig1 (E), vdd_ana2 (S), vdd_dig4 (W)
dvss_pads[0..3].pad  = vss_ana1 (N), vss_dig2 (E), vss_ana2 (S), vss_dig3 (W)
clk_pad              = stock single-instance input
rst_n_pad            = stock single-instance input
```

## Pad ordering per edge

LibreLane reads pad lists **clockwise from the SW corner**; Juan
Moya's standalone config lists `PAD_NORTH` / `PAD_WEST` in the
opposite direction. The YAML therefore reverses those two edges
relative to his file.

### South - SW to SE (24 pads)

```
clk_pad, rst_n_pad, inputs[0].pad,
analog[28..37],
dvdd_pads[2].pad, dvss_pads[2].pad,
analog[38..47]
```

### East - SE to NE (22 pads)

```
analog[27..18],                # note: reverse index order
dvss_pads[1].pad, dvdd_pads[1].pad,
bidir[11..4],                  # reverse
analog[17], analog[16]
```

### North - NE to NW (22 pads; reversed vs Juan Moya)

```
bidir[3..0],                   # reverse (LibreLane CW reading)
analog[15..10],                # reverse
dvss_pads[0].pad, dvdd_pads[0].pad,
analog[9..0]                   # reverse
```

### West - NW to SW (22 pads; reversed vs Juan Moya)

```
analog[59], analog[58],
bidir[12..19],                 # forward (because overall edge is reversed)
dvdd_pads[3].pad, dvss_pads[3].pad,
analog[57..48]                 # reverse
```

## Reference result

A build of this slot was validated DRC/LVS/antenna/STA-clean on
2026-04-23 with LibreLane 3.0 + wafer-space PDK 1.8.0:

- Die: 2935 x 2935 um (as specified).
- Final: 84 922 instances (28 563 stdcells + fillers/taps + 2 macros).
- Macros: `chip_id` (wafer.space QR) + `wafer_space_logo` (stock).
- Runtime: 2h 15m.

That is the reference the verify script compares against.
