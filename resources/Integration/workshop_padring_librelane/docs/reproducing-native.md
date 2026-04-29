# Reproducing - native (nix-shell)

The upstream template uses Nix to pin LibreLane, OpenROAD, and their
dependencies. This is the path the upstream README documents and the
one the reference build used.

## Requirements

- Linux (x86_64 or aarch64).
- Nix with flakes enabled.
  - Install: `curl -L https://nixos.org/nix/install | sh`.
  - Enable flakes: `mkdir -p ~/.config/nix && echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf`.
- ~20 GB free disk (LibreLane + PDK + build artifacts).

Optional but recommended: the Fossi-Foundation binary cache is
pre-configured in `flake.nix` (`nix-cache.fossi-foundation.org`).
Accept it the first time you enter the shell; it turns a multi-hour
first build into minutes.

## Steps

```bash
git clone <this-repo-url> chipathon-2026-gf180mcu-padring
cd chipathon-2026-gf180mcu-padring

# Drop into a shell with LibreLane 3.0.0 + Python + cocotb + gtkwave.
nix-shell

# Clone the wafer-space PDK fork at the pinned tag (1.8.0).
make clone-pdk

# Build the workshop slot end-to-end.
SLOT=workshop make librelane
```

Runtime: ~2h 15m on a modern laptop. The flow runs Yosys synthesis,
OpenROAD floorplanning / placement / PDN / CTS / routing, KLayout DRC,
Magic DRC, Netgen LVS, antenna check and STA across three corners.

## Outputs

After a clean run:

```
final/
├── gds/chip_top.gds          ~85 MB  - streamed GDS (KLayout writer)
├── lef/chip_top.lef                  - abstract for downstream hierarchy
├── def/chip_top.def                  - full DEF
├── nl/chip_top.nl.v                  - post-signoff netlist
├── spef/chip_top.*.spef              - parasitics per corner
├── sdf/chip_top.*.sdf                - timing annotations per corner
├── sta/                              - STA reports
└── metrics.csv                       - one-line signoff summary
```

## View / re-open

```bash
# Open last run in OpenROAD GUI
make librelane-openroad

# Open last run in KLayout
make librelane-klayout
```

## Iterating on your own RTL

Edit `src/chip_core.sv`, keeping the port list (the generate loops in
`chip_top.sv` bind to it). The workshop slot's `NUM_INPUT=1`,
`NUM_BIDIR=20`, `NUM_ANALOG=60` are fixed.

```bash
SLOT=workshop make librelane
```

If you only want to see synthesis/placement results fast during
iteration, `make librelane-nodrc` skips the DRC stages.

## If Nix is not an option

Use `docs/reproducing-docker.md` for the Docker path. Note that the
Docker path as documented is for **inspection** of a pre-built GDS,
not for the build itself (LibreLane 3.0.0 versioning inside the
iic-osic-tools container is not guaranteed to match the pinned flake).
