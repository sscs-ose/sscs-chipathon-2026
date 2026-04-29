# Credits

Per-artifact attribution for this repository.

## Container, tool stack, PDK

**IIC / JKU Linz** - `hpretl/iic-osic-tools:next` Docker image bundles
LibreLane, Yosys, OpenROAD, Magic, KLayout, Netgen, Icarus Verilog,
Verilator, cocotb, ciel, and sak-pdk-script.sh. The GF180MCU PDK is
installed at `/foss/pdks/gf180mcuD/` by `ciel`. The wafer-space
GF180MCU fork (used only by full-chip notebooks that exercise the
padring I/O cells) is pinned at tag 1.8.0.

- https://github.com/iic-jku/iic-osic-tools
- https://github.com/wafer-space/gf180mcu

## Template + flow

**Leo Moser** and the **wafer-space** contributors.

- https://github.com/wafer-space/gf180mcu-project-template
- LibreLane, Nix flake, Makefile harness, cocotb scaffolding, the
  slot-based project layout, `chip_top.sv`, `slot_defines.svh`, the
  standard slot YAMLs (`1x1`, `0p5x1`, `1x0p5`, `0p5x0p5`).
- Notebook 02 (`02_rtl2gds_chip_top_custom.ipynb`) clones this
  upstream directly.

## Workshop padring (slot) -- pad count, cell selection, index mapping, die size

**Juan Moya** -- from the standalone padring config:

- https://github.com/JuanMoya/padring_gf180
- `Workshop_CASS/padring/workshop_padring.cfg`

The chipathon-2026 workshop slot in
[`chipathon-2026-gf180mcu-padring`](https://github.com/Mauricio-xx/chipathon-2026-gf180mcu-padring)
is a 1:1 port of Juan Moya's pad layout into a LibreLane-native slot
definition (see that repo's CREDITS.md for the detailed breakdown of
what comes from Juan Moya vs. what is LibreLane-specific adaptation).

Notebooks 00, 03, and 04 of this repo consume that slot.

## Multi-macro counter + ALU example (notebook 04)

**Mauricio Montanares** - authored for this repository.

Files:

- `examples/04_counter_alu_multimacro/rtl/counter.sv`
- `examples/04_counter_alu_multimacro/rtl/alu.sv`
- `examples/04_counter_alu_multimacro/rtl/alu_macro.sv`
- `examples/04_counter_alu_multimacro/rtl/chip_core_multi.sv`
- `examples/04_counter_alu_multimacro/tb/test_counter.py`
- `examples/04_counter_alu_multimacro/tb/test_alu.py`
- `examples/04_counter_alu_multimacro/tb/Makefile(.cocotb)`
- `examples/04_counter_alu_multimacro/librelane/counter_macro.yaml`
- `examples/04_counter_alu_multimacro/librelane/alu_macro.yaml`
- `examples/04_counter_alu_multimacro/librelane/chip_top_multi_patch.yaml`
- `examples/04_counter_alu_multimacro/04_counter_alu_multimacro.ipynb`

## Diagrams (SVG)

**Mauricio Montanares** - authored for this repository. Visual
conventions borrow from Leo Moser's reference deck
(`tutorials/rtl2gds-gf180-docker/claude_design_slides/` in the
eda-agents tree) but the SVG sources are new.

- `diagrams/flow_rtl2gds.svg`
- `diagrams/slot_anatomy.svg`
- `diagrams/workshop_pad_map.svg`
- `diagrams/multi_macro_hierarchy.svg`
- `diagrams/multi_macro_verification.svg`
- `diagrams/container_model.svg`
- `diagrams/tutorial_agent_tui.svg` *(experimental tutorials)*
- `diagrams/tutorial_python_api.svg` *(experimental tutorials)*
- `diagrams/tutorial_autoresearch.svg` *(experimental tutorials)*

## Experimental tutorials (`tutorials/`)

**Mauricio Montanares** - authored for this repository, ports structure from the upstream `eda-agents` project.

The `tutorials/` subtree shows three AI-driven walkthroughs over the **same** 4-bit counter from `examples/01_*`:

- `tutorials/01_counter_with_agent_tui/` — invokes the `gf180-docker-digital` agent shipped at `eda-agents/.claude/agents/gf180-docker-digital.md` and `eda-agents/.opencode/agent/gf180-docker-digital.md`. Tutorial files (notebook, README, agent walkthrough doc, RTL/TB/LibreLane staging) are new; agent definition and `flow.rtl2gds_gf180_docker` skill come from eda-agents.
- `tutorials/02_counter_python_api/` — port of `eda-agents/tutorials/agents-analog-digital/demo/agents_rtl2gds_counter.{ipynb,py}`, adapted to chipathon paths and to read RTL from `rtl/counter.v` instead of inlined strings.
- `tutorials/03_counter_autoresearch/` — port of `eda-agents/tutorials/agents-analog-digital/demo/agents_digital_autoresearch.{ipynb,py}`, same path adaptations.

These tutorials are clearly marked **experimental** in their READMEs because they depend on a moving `eda-agents` upstream and an LLM provider; the chipathon `examples/` are the validated tapeout path.

The shared 4-bit counter RTL (`tutorials/0?_*/rtl/counter.v`) and minimal LibreLane config are copied verbatim from `eda-agents/tutorials/rtl2gds-gf180-docker/demo/rtl2gds_counter.{ipynb,py}`, also originally authored by Mauricio Montanares.

## Notebooks 00, 01, 02, 03

Originally authored by **Mauricio Montanares** in the companion
`eda-agents` tutorial tree
(`tutorials/rtl2gds-gf180-docker/demo/`, 2026-04-22 through 2026-04-23).

Adaptations in this repository:

- Notebook 00 (`00_slots_explained.ipynb`): added optional clone step
  for the chipathon-2026 padring fork so the parser cell runs
  standalone; inserted a credits header referencing Juan Moya and
  wafer-space.
- Notebook 03 (`03_rtl2gds_chipathon_use.ipynb`): inserted two new
  steps (`Step 1a` and `Step 1b`) that clone the padring fork and
  the wafer-space PDK fork on demand, replacing the previous
  assumption that the template had already been staged by a separate
  notebook. Updated the "Where to go next" to point at notebook 04.
- Notebooks 01 and 02 are carried verbatim.

## License

All third-party attributions above use the Apache License, Version
2.0. The repository-specific additions are released under the same
license.
