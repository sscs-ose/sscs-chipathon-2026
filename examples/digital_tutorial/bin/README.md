# Open-Source VLSI Helper Scripts for ChipAThon

This repository provides a small collection of Python helper scripts and shell utilities designed to simplify common layout verification tasks in the open-source VLSI flow used for IEEE SSCS PICO Open-Source ChipAThon projects.

These scripts are intended to reduce repetitive command-line work when using tools such as Magic, Netgen, and NGSpice for post-layout verification, parasitic extraction, and LVS validation. Rather than manually typing multiple commands for every design iteration, these helpers provide a cleaner and faster workflow for extraction and verification.

The goal is to make the design process more reproducible, easier for students to learn, and less error-prone during rapid design iteration.

---

## Included Scripts

### `ext4mag.py`

This script helps automate extraction preparation for Magic layout verification.

It generates the required extraction flow to prepare layouts for:

- parasitic extraction
- SPICE netlist generation
- LVS preparation
- post-layout verification

This is especially useful when repeatedly validating layout updates during physical design refinement.

Typical use cases include:

- transistor-level custom cell validation
- standard-cell verification
- analog block extraction
- GF180MCU and SKY130 layout preparation

---

### `extlvs.py`

This script simplifies Layout Versus Schematic (LVS) preparation and checking using:

- Magic
- Netgen

It assists in generating the extracted netlist and preparing the comparison between:

- schematic netlist
- extracted layout netlist

This helps ensure that the fabricated layout matches the intended circuit design.

Typical checks include:

- missing connections
- short circuits
- device mismatches
- parameter inconsistencies

---

### `extspice.py`

This script automates SPICE netlist extraction for simulation.

It prepares extracted netlists suitable for:

- NGSpice simulation
- post-layout timing checks
- analog verification
- power estimation
- parasitic-aware validation

This is useful for verifying that layout parasitics do not significantly alter circuit functionality.

---

### `runlvs.sh`

A lightweight shell wrapper used to quickly launch the full LVS flow.

It serves as a convenience script for:

- extraction
- Netgen execution
- report generation

This avoids repeatedly entering the same verification commands manually.

---

## Why These Scripts Matter

In open-source VLSI flows, designers often spend significant time repeating infrastructure commands instead of focusing on actual circuit design.

These helper scripts improve:

- reproducibility
- learning efficiency
- verification speed
- debugging turnaround
- student onboarding

This is particularly important during ChipAThon projects where rapid iteration and team collaboration are critical.

The scripts help bridge the gap between:

RTL → Layout → Extraction → LVS → Simulation

while keeping the workflow simple and educational.

---

## Typical Tool Flow

These scripts are commonly used with:

- Magic (layout editor + extraction)
- Netgen (LVS verification)
- NGSpice (simulation)
- IRSIM (switch-level simulation)
- OpenROAD (digital implementation)
- GF180MCU PDK
- SKY130 PDK

and can be integrated into larger reproducible flows using:

- IIC-OSIC-TOOLS
- Open_PDKs
- Open Circuit Design tools

---

## Example Workflow

A typical post-layout validation flow looks like:

```text
1. Create layout in Magic
2. Run extraction using ext4mag.py
3. Generate SPICE netlist using extspice.py
4. Perform LVS using extlvs.py or runlvs.sh
5. Simulate extracted design in NGSpice
6. Verify correctness and iterate
