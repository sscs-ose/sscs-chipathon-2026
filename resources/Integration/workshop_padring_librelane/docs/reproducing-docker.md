# Reproducing - Docker (hpretl/iic-osic-tools)

This path uses the [iic-osic-tools](https://github.com/iic-jku/iic-osic-tools)
Docker image, which ships KLayout, Magic, Netgen, OpenROAD, Yosys and
LibreLane in one container. It is the path most chipathon participants
already have set up for interactive PDK work.

## Scope and honest caveat

The **recommended build path is the Nix flake** (see
`docs/reproducing-native.md`). The flake pins LibreLane 3.0.0 with a
specific nix-eda / nixpkgs revision, and OpenROAD is built against
those pins. The stock `hpretl/iic-osic-tools` image does ship
LibreLane, but at a version that is not guaranteed to match the pin;
reproducibility is therefore weaker.

The Docker path is recommended for:

1. **Inspecting a pre-built GDS** (open `final/gds/chip_top.gds` in
   KLayout, run ad-hoc Magic DRC, render PNGs).
2. **Running cocotb simulations** against the RTL (upstream's `make sim`
   target).
3. **Experimenting with the flow** when Nix install is a hard blocker,
   accepting that version drift may change results.

For signoff-grade runs, use the Nix path.

## Quickstart - inspection of a built GDS

Prereqs:

- Docker Engine (no sudo needed; `docker` group membership is enough).
- A prior `nix-shell` build has populated `final/` (or a copied GDS
  from a reference build).

```bash
scripts/run_docker_iic.sh
# inside the container:
cd /workspace
klayout final/gds/chip_top.gds
```

The launcher mounts this repo into `/workspace` inside the container
and opens an interactive shell. See the script comments for port
forwards and display setup.

## Full build inside Docker (advanced, not reference)

If you want to attempt the full RTL-to-GDS inside `iic-osic-tools`:

```bash
scripts/run_docker_iic.sh
# inside the container:
cd /workspace
make clone-pdk            # wafer-space PDK @ 1.8.0
# NB: the container LibreLane is not guaranteed to match the pinned
# flake. If the flow errors on config-key parsing or on a missing
# step, switch to the Nix path.
SLOT=workshop librelane \
    librelane/slots/slot_workshop.yaml librelane/config.yaml \
    --save-views-to "$(pwd)/final" \
    --pdk gf180mcuD --pdk-root "$(pwd)/gf180mcu" --manual-pdk
```

If the container's LibreLane version is too old/new, `--skip` the
offending stage or fall back to `nix-shell`.

## Magic DRC spot-check (known-working in the container)

```bash
scripts/run_docker_iic.sh
# inside:
cd /workspace
magic -dnull -noconsole \
    -rcfile gf180mcu/libs.tech/magic/gf180mcuD.magicrc <<'EOF'
gds read final/gds/chip_top.gds
load chip_top
drc check
drc count
EOF
```

## KLayout density / XOR

For the 2026-04-23 reference, `KLAYOUT_FILLER_OPTIONS.Metal2_ignore_active: true`
is set in `librelane/config.yaml`. If you re-run density / XOR outside
LibreLane, apply the same setting in the Python driver.

## See also

- `scripts/run_docker_iic.sh` - launcher with mount + env knobs.
- `docs/reproducing-native.md` - the reference build path.
