# GF180MCU Open-Source PDK Tapeout Checklist

A detailed tapeout checklist for designs targeting the **GlobalFoundries GF180MCU process** using the open-source PDK.

This checklist is intended for full-chip, MPW, and shuttle submissions. It extends beyond the minimal foundry tapeout requirements and includes open-source-PDK-specific reproducibility, verification, reliability, packaging, and submission checks.

> **Important**
>
> The open-source GF180MCU PDK should be treated as a versioned verification environment. Freeze and record the exact PDK revision, verification decks, library revisions, and tool versions used for final signoff.

---

## 1. Process and Tapeout Configuration

- [ ] Identify the exact shuttle/foundry submission being targeted.
- [ ] Confirm the exact GF180MCU process option required by the shuttle.
- [ ] Confirm number of metal layers.
- [ ] Confirm top-metal thickness.
- [ ] Confirm MIM capacitor option, if used.
- [ ] Confirm any optional process modules used:
  - [ ] MIM
  - [ ] High-resistance poly
  - [ ] Native-Vt NMOS
  - [ ] eFuse
  - [ ] LDMOS
  - [ ] Other optional devices
- [ ] Confirm whether 3.3 V, 5 V, and/or 6 V devices are permitted by the shuttle.
- [ ] Confirm the allowed die dimensions and usable design area.
- [ ] Confirm scribe-line/kerf requirements.
- [ ] Confirm whether the shuttle supplies the guard/seal ring or the customer must supply it.
- [ ] Confirm whether foundry or customer performs dummy insertion.
- [ ] Confirm permitted bond-pad construction: non-CUP versus CUP.
- [ ] Confirm package, wire-bond, bump, or probe-pad requirements.
- [ ] Confirm required top-level cell name.
- [ ] Confirm required GDS units and database precision.
- [ ] Confirm all shuttle-specific layer restrictions.
- [ ] Confirm required delivery files and naming conventions.
- [ ] Record all configuration decisions in a tapeout configuration file.

Do not assume that a shorthand PDK variant name is sufficient to describe the process. Record the actual metal stack, top-metal option, optional modules, and verification-deck settings.

---

## 2. PDK and Tool Reproducibility

- [ ] Freeze the exact `gf180mcu-pdk` revision.
- [ ] Freeze the exact `open_pdks` revision or Ciel PDK identifier.
- [ ] Record installed PDK provenance information such as `SOURCES`.
- [ ] Freeze revisions of:
  - [ ] Primitive-device library
  - [ ] Standard-cell library
  - [ ] I/O library
  - [ ] SRAM/IP libraries
- [ ] Record KLayout version.
- [ ] Record Magic version.
- [ ] Record Netgen version.
- [ ] Record ngspice/Xyce version where applicable.
- [ ] Record LibreLane/OpenROAD versions for digital designs.
- [ ] Record all custom DRC/LVS/ERC scripts.
- [ ] Check the PDK repository's current known issues.
- [ ] Check outstanding issues affecting devices or decks actually used.
- [ ] Preserve the complete tapeout environment or container.
- [ ] Ensure the PDK installation is not being locally modified unintentionally.
- [ ] Save hashes of the signoff decks.

---

## 3. Schematic / Netlist Completeness

- [ ] Final schematic is frozen.
- [ ] No unresolved schematic ERC errors.
- [ ] Every layout device has a supported GF180MCU LVS/model device.
- [ ] Check device names against the GF180MCU Device List for Model and LVS Deck.
- [ ] Correct transistor type used for every voltage domain.
- [ ] Correct 3.3 V versus 5/6 V devices used.
- [ ] Correct DNWELL/LVPWELL device variants used.
- [ ] Correct resistor type and marking layers used.
- [ ] Correct capacitor/MIM option used.
- [ ] Correct diode and BJT variants used.
- [ ] No unsupported device models remain.
- [ ] All device bulk/body terminals are intentionally connected.
- [ ] No accidentally floating wells.
- [ ] No unintentionally floating gates.
- [ ] No unintentionally floating analog nodes.
- [ ] Power and ground nets use consistent names through all hierarchy.
- [ ] Global-net treatment is understood before LVS.
- [ ] Black-box cells have matching layout and schematic abstracts.

---

## 4. Functional Verification

- [ ] RTL simulation passes, if digital.
- [ ] Gate-level simulation passes.
- [ ] Reset behavior verified.
- [ ] Power-up behavior verified.
- [ ] All clock modes verified.
- [ ] All I/O modes verified.
- [ ] Bidirectional I/O direction controls verified.
- [ ] Output-enable/OEB behavior verified.
- [ ] Pull-up/pull-down controls verified.
- [ ] Schmitt/CMOS input selections verified where applicable.
- [ ] Test/debug modes verified.
- [ ] Scan/test logic verified where applicable.
- [ ] Analog functionality simulated.
- [ ] Mixed-signal interfaces simulated.
- [ ] Power-down states verified.
- [ ] Illegal input combinations considered.
- [ ] Outputs do not unintentionally drive during reset or power sequencing.

---

## 5. Circuit Simulation and Operating Limits

- [ ] Simulate all required process corners.
- [ ] Simulate minimum operating voltage.
- [ ] Simulate nominal operating voltage.
- [ ] Simulate maximum operating voltage.
- [ ] Simulate minimum temperature.
- [ ] Simulate maximum temperature.
- [ ] Simulate worst-case load.
- [ ] Simulate worst-case frequency.
- [ ] Run Monte Carlo/mismatch analysis where relevant.
- [ ] Run post-layout extracted simulation for critical analog blocks.
- [ ] Run post-layout timing analysis for digital blocks.
- [ ] Check startup circuits over PVT.
- [ ] Check bias circuits over PVT.
- [ ] Check oscillators/PLLs over PVT.
- [ ] Check memories over their specified operating range.
- [ ] Check maximum voltage across every sensitive device.
- [ ] Check gate oxide voltage limits.
- [ ] Check hot-carrier limits.
- [ ] Check transient overshoot/undershoot.
- [ ] Check power-sequencing conditions.
- [ ] Check unpowered-domain input conditions.

---

## 6. Floorplan and Hierarchy

- [ ] Top-level cell is correct.
- [ ] Die boundary is correct.
- [ ] All macros lie within the permitted design region.
- [ ] No geometry extends unintentionally outside the die.
- [ ] Macro orientations are legal.
- [ ] Macro abstracts correspond to final GDS.
- [ ] LEF pin locations match GDS pins.
- [ ] No duplicate/unintended top-level cells.
- [ ] No missing GDS references.
- [ ] No unintended external library references.
- [ ] Hierarchy is preserved where expected.
- [ ] Cell names are legal and unique.
- [ ] No accidental scaling of imported cells.
- [ ] All cells use consistent units.
- [ ] Final GDS database can be opened independently without missing cells.
- [ ] Check polygon validity and self-intersections.
- [ ] Check for accidental zero-area or degenerate geometry.

GF requires hierarchical, cell-based GDSII and inclusion of all required drawn/generated layers.

---

## 7. Voltage Domains, Wells, and Devices

- [ ] Every 5/6 V device is correctly enclosed by `Dualgate`.
- [ ] No device is partially covered by `Dualgate`.
- [ ] 3.3 V and 5/6 V PMOS devices are not improperly sharing wells.
- [ ] DNWELL regions are correctly defined.
- [ ] LVPWELL regions are correctly defined.
- [ ] All wells have appropriate taps.
- [ ] Maximum tap-distance rules satisfied.
- [ ] Substrate taps satisfy maximum-distance requirements.
- [ ] Separate voltage domains have intentional well/substrate isolation.
- [ ] No accidental well merging between isolated blocks.
- [ ] Verify body-bias nets explicitly.
- [ ] Check every high-voltage/low-voltage interface.
- [ ] Check that poly does not improperly connect 3.3 V and 5/6 V areas where metal interconnection is required.

Some voltage-domain checks are ERC/connectivity checks rather than ordinary geometry DRC.

---

## 8. DRC

- [ ] Run the complete FEOL DRC.
- [ ] Run the complete BEOL DRC.
- [ ] Enable off-grid checking.
- [ ] Enable density checking.
- [ ] Enable connectivity-dependent DRC where supported.
- [ ] Use the correct metal-stack option.
- [ ] Use the correct top-metal option.
- [ ] Use the correct MIM option.
- [ ] Run on the **final streamed GDS**, not only the source database.
- [ ] Achieve zero unwaived DRC violations.
- [ ] Review every waived violation manually.
- [ ] Document every waiver.
- [ ] Confirm shuttle/foundry acceptance of all waivers.
- [ ] Rerun after final fill generation.
- [ ] Rerun after final padframe generation.
- [ ] Rerun after final guard/seal-ring insertion.
- [ ] Rerun if the GDS is regenerated for any reason.

---

## 9. Rules Not Fully Covered by Automated DRC

Appendix B of the GF design manual lists rules that are not coded or are only guidelines. These should be treated as a separate signoff gate.

- [ ] Review every applicable item in **Appendix B: Rules not coded**.
- [ ] Check that 3.3 V and 6 V transistors are not improperly mixed in a DNWELL.
- [ ] Verify well resistors have the required `RES_MK`.
- [ ] Verify maximum Poly2 current density.
- [ ] Verify maximum poly-resistor current density.
- [ ] Verify via/contact enclosure recommendations important to resistance/yield.
- [ ] Verify MIM restrictions that may be LVS rather than DRC checked.
- [ ] Verify sensitive matching circuitry is not beneath MIM where prohibited or discouraged.
- [ ] Review matched-pair layout guidelines manually.
- [ ] Review metal-slotting requirements manually.
- [ ] Review seal/guard-ring construction items that are not coded.
- [ ] Review ESD recommendations that are default-off or not automatically checked.
- [ ] Record reviewer and disposition for every applicable non-coded rule.

> **Signoff principle:** `DRC clean` does not necessarily mean that all GF design-manual requirements have been checked.

---

## 10. LVS and Connectivity

- [ ] LVS final GDS against final schematic/netlist.
- [ ] LVS reports zero unmatched devices.
- [ ] LVS reports zero unmatched nets.
- [ ] LVS reports zero unintended property errors.
- [ ] Device sizes match.
- [ ] Resistor values/geometries match.
- [ ] Capacitor values/types match.
- [ ] Correct DNWELL device variants recognized.
- [ ] Correct 5/6 V devices recognized.
- [ ] Correct substrate/well connections extracted.
- [ ] No unexpected device merging.
- [ ] No unexpected device splitting.
- [ ] All top-level pins match.
- [ ] All power pins match.
- [ ] Pad cells match their intended schematic models.
- [ ] Fill does not create unintended extracted devices.
- [ ] Guard rings do not create unintended net shorts.
- [ ] Final hierarchical LVS report archived.

---

## 11. Antenna / Process-Induced Damage

- [ ] Run antenna checking on final routed layout.
- [ ] Check Poly2 antenna.
- [ ] Check every metal level.
- [ ] Check contacts and vias.
- [ ] Fix violations with routing changes, layer jumps, or approved protection structures.
- [ ] Verify antenna fixes do not introduce timing or analog problems.
- [ ] Rerun antenna after ECOs.
- [ ] Rerun after final fill if relevant.
- [ ] Archive final antenna report.

---

## 12. Latch-Up

- [ ] Run available latch-up/ERC checks.
- [ ] Check core tap spacing.
- [ ] Check Nwell tap distance.
- [ ] Check substrate tap distance.
- [ ] Check DNWELL tap coverage.
- [ ] Identify nodes capable of overshoot/undershoot.
- [ ] Apply `Latchup_MK` where required.
- [ ] Check pad-connected diffusions against I/O latch-up rules.
- [ ] Add required guard rings.
- [ ] Connect Nwell guard rings to the highest intended supply.
- [ ] Connect substrate/P+ guard rings to the lowest intended potential.
- [ ] Check high-voltage devices especially carefully.
- [ ] Prefer double guard rings between HV and lower-voltage circuitry where appropriate.
- [ ] Maximize guard-ring contacts.
- [ ] Verify guard rings are not accidentally broken.
- [ ] Review all latch-up violations manually.

---

## 13. ESD and I/O

- [ ] Every external signal has a defined ESD strategy.
- [ ] Use characterized GF I/O cells wherever appropriate.
- [ ] Verify pad cell is compatible with the chosen metal stack.
- [ ] Verify digital pad control signals.
- [ ] Verify output enable.
- [ ] Verify drive-strength selection.
- [ ] Verify slew-rate selection.
- [ ] Verify pull-up/down state.
- [ ] Verify CMOS/Schmitt selection.
- [ ] Verify I/O supply and ground connections.
- [ ] Verify core supply/ground connections through the padring.
- [ ] Check ESD current path from every signal pad to supplies.
- [ ] Check ESD current path between supply domains.
- [ ] Check ESD path width and via capacity.
- [ ] Check placement of secondary ESD devices.
- [ ] Verify no narrow interconnect defeats the protection network.
- [ ] Confirm padframe continuity through filler/corner/break cells.
- [ ] Check unused pads and controls have defined states.

### Analog Pads

- [ ] Do **not** assume the analog pad alone provides complete input-gate protection.
- [ ] If an analog pad feeds internal gates, provide the required nearby secondary/CDM protection.
- [ ] Review resistor and diode dimensions for that network.
- [ ] Keep secondary protection physically close to the protected circuitry.

---

## 14. Power Integrity and Electromigration

- [ ] Calculate expected current for every supply.
- [ ] Calculate peak current, not only average current.
- [ ] Check power-pad current capability.
- [ ] Provide sufficient number of VDD/VSS pads.
- [ ] Check padring current distribution.
- [ ] Check core power-ring width.
- [ ] Check straps.
- [ ] Check local supply routing.
- [ ] Check current density in each metal level.
- [ ] Check current density in contacts.
- [ ] Check current density in vias.
- [ ] Use multiple contacts/vias for significant current.
- [ ] Check neck-down regions.
- [ ] Check macro supply interfaces.
- [ ] Check analog high-current outputs.
- [ ] Check ESD paths for high-current bottlenecks.
- [ ] Check IR drop.
- [ ] Check worst-case simultaneous switching.
- [ ] Consider package/bond-wire resistance and inductance.

---

## 15. Dummy Fill and Density

- [ ] Decide whether fill is inserted by the project or by the foundry/shuttle.
- [ ] Insert mandatory dummy COMP where required.
- [ ] Check minimum active/COMP density.
- [ ] Check maximum active/COMP density.
- [ ] Check Poly2 density.
- [ ] Check every metal density requirement.
- [ ] Check minimum and maximum density where both apply.
- [ ] Use `NDMY` appropriately.
- [ ] Use `PMNDMY` appropriately.
- [ ] Use `RES_MK` around applicable resistors.
- [ ] Protect sensitive analog areas from inappropriate dummy fill.
- [ ] Protect inductors/RF structures with required markings.
- [ ] Evaluate added parasitic capacitance.
- [ ] Rerun extraction after fill.
- [ ] Rerun LVS after fill.
- [ ] Rerun DRC after fill.
- [ ] Rerun timing/analog simulation if added capacitance is significant.

---

## 16. DFM and Geometry Quality

- [ ] Review the design manually for manufacturability, not just minimum-rule compliance.
- [ ] Avoid acute angles below 90° except documented exceptions.
- [ ] Avoid inappropriate curved/arced COMP, poly, or metal.
- [ ] Avoid problematic tapered COMP/poly intersections.
- [ ] Avoid problematic U-shaped diffusion geometry.
- [ ] Avoid unnecessary minimum-sized contacts.
- [ ] Increase via arrays on important nets.
- [ ] Increase contact arrays where space allows.
- [ ] Avoid unnecessary minimum-width long wires.
- [ ] Review line-end geometries.
- [ ] Review analog matching geometry.
- [ ] Review density transitions near analog circuitry.
- [ ] Review macro boundaries for DRC-sensitive interactions.

---

## 17. Analog-Specific Review

- [ ] Matched devices use appropriate matching layout.
- [ ] Orientation of matched devices is consistent.
- [ ] Surrounding environment is symmetric where important.
- [ ] Dummy devices included where appropriate.
- [ ] Guard rings included where appropriate.
- [ ] Critical nets shielded.
- [ ] Sensitive circuits separated from digital switching.
- [ ] Supply routing separated/filtered appropriately.
- [ ] High-current nets separated from sensitive nodes.
- [ ] Substrate noise coupling reviewed.
- [ ] DNWELL isolation reviewed.
- [ ] Fill symmetry around matched devices reviewed.
- [ ] Parasitic extraction completed.
- [ ] Post-layout simulation completed.
- [ ] Monte Carlo/mismatch simulation completed.
- [ ] MIM capacitor surroundings reviewed.
- [ ] Resistor matching layout reviewed.
- [ ] Kelvin connections used where appropriate.

---

## 18. Bond Pads, Padframe, Package, and Bonding

- [ ] Padframe contains all required signal pads.
- [ ] Padframe contains adequate power and ground pads.
- [ ] Correct corner cells used.
- [ ] All gaps filled with approved filler cells.
- [ ] Padring connectivity is continuous.
- [ ] Bond-pad openings are correct.
- [ ] Bond-pad pitch is compatible with package/bonding.
- [ ] Die-to-package pin map finalized.
- [ ] Pin numbers match package drawing.
- [ ] Signal names match schematic and documentation.
- [ ] Power domains correctly mapped to package pins.
- [ ] No supply is accidentally tied together through the padring.
- [ ] Wire crossing/angle constraints reviewed.
- [ ] Bond-wire length reviewed.
- [ ] Bond-wire current capability reviewed.
- [ ] Probe requirements reviewed.
- [ ] Bond diagram independently checked by a second person.
- [ ] Package orientation/pin-1 convention independently checked.

---

## 19. Guard Ring, Seal Ring, Scribe Line, and Die Edge

- [ ] Confirm whether a guard/seal ring is required.
- [ ] Use the correct `GUARD_RING_MK` geometry.
- [ ] Verify guard-ring spacing to active circuitry.
- [ ] Verify required metal widths.
- [ ] Verify COMP structure.
- [ ] Verify contact arrays.
- [ ] Verify via arrays.
- [ ] Verify electrical connection, normally to the required VSS structure.
- [ ] Confirm pad opening requirements over the ring.
- [ ] Confirm ring-to-die-edge spacing.
- [ ] Check die-corner guidelines.
- [ ] Check scribe-line exclusions.
- [ ] Verify no ordinary circuitry extends into the scribe region.
- [ ] Verify final die outline against shuttle requirements.

---

## 20. Physical Data Integrity

- [ ] Stream out a clean final GDS from the intended source.
- [ ] Reopen the streamed GDS independently.
- [ ] Check top-cell name.
- [ ] Check hierarchy.
- [ ] Check bounding box.
- [ ] Check GDS unit and precision.
- [ ] Check all expected layers are present.
- [ ] Check no unexpected layers are present.
- [ ] Check no unresolved references.
- [ ] Check no duplicate structures with conflicting definitions.
- [ ] Check cell count against expectation.
- [ ] Check GDS file size for obvious anomalies.
- [ ] Run DRC on this exact GDS.
- [ ] Run LVS on this exact GDS.
- [ ] Run density on this exact GDS.
- [ ] Run antenna checks on this exact GDS.
- [ ] Generate SHA-256 checksum.
- [ ] Mark the file read-only/immutable after signoff.

---

## 21. Final Signoff Consistency

- [ ] Final schematic/netlist frozen.
- [ ] Final RTL frozen.
- [ ] Final extracted netlist archived.
- [ ] Final GDS frozen.
- [ ] Final LEF frozen.
- [ ] Final Liberty files identified.
- [ ] Final timing reports archived.
- [ ] Final DRC report archived.
- [ ] Final LVS report archived.
- [ ] Final ERC/latch-up report archived.
- [ ] Final antenna report archived.
- [ ] Final density report archived.
- [ ] Final simulation reports archived.
- [ ] Final package/bonding drawing archived.
- [ ] PDK/tool versions recorded.
- [ ] All waivers recorded.
- [ ] All known remaining warnings recorded and dispositioned.
- [ ] No layout change occurred after the final verification run.
- [ ] Checksums of all submitted files recorded.
- [ ] A second person has reviewed the tapeout package.

---

## 22. Submission Package

- [ ] Final hierarchical GDSII included.
- [ ] All drawn/generated layers required by GF are present.
- [ ] Correct top cell documented.
- [ ] Process/metal-stack option documented.
- [ ] Die dimensions documented.
- [ ] GDS checksum documented.
- [ ] Pin list included.
- [ ] Pad/package bonding table included.
- [ ] Power-domain information included.
- [ ] Nominal and maximum supply voltages included.
- [ ] Expected peak current included where requested.
- [ ] Expected operating frequency included where requested.
- [ ] DRC status included.
- [ ] LVS status included.
- [ ] ERC/latch-up status included.
- [ ] Known waivers included.
- [ ] Export-control information completed if required.
- [ ] Foundry/shuttle configuration questionnaire completed.
- [ ] Contact information correct.
- [ ] Repository/tag/commit corresponding to the submitted design recorded.
- [ ] Exact submitted archive retained locally.

---

## 23. Final "Do Not Tape Out Until" Gate

A GF180MCU open-PDK design should not be considered tapeout-ready until all applicable items below have been satisfied:

- [ ] **Final GDS DRC clean.**
- [ ] **Final GDS LVS clean.**
- [ ] **Applicable ERC/latch-up checks clean or reviewed.**
- [ ] **Antenna clean.**
- [ ] **Density/fill complete.**
- [ ] **Appendix B / non-coded rules manually reviewed.**
- [ ] **ESD strategy reviewed for every external pad.**
- [ ] **EM/current capability reviewed.**
- [ ] **Post-layout simulation/timing acceptable.**
- [ ] **Package/pad/bond map independently reviewed.**
- [ ] **Exact PDK/deck versions frozen.**
- [ ] **Final submitted GDS is byte-for-byte the GDS that was verified.**
- [ ] **No unresolved warning is being silently treated as harmless.**

---

## References

- [GF180MCU Open-Source PDK Documentation](https://gf180mcu-pdk.readthedocs.io/)
- [GF180MCU Physical Verification Design Manual](https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_man.html)
- [GF180MCU Essential Tapeout Checklist](https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_06.html)
- [GF180MCU Device List for Model and LVS Deck](https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_15.html)
- [GF180MCU Rules Not Coded](https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_16.html)
- [GF180MCU Antenna Rules](https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_08.html)
- [GF180MCU Latch-Up Rules](https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_14_3.html)
- [GF180MCU I/O Library](https://gf180mcu-pdk.readthedocs.io/en/latest/IPs/IO/gf180mcu_fd_io/datasheet.html)
- [google/gf180mcu-pdk](https://github.com/google/gf180mcu-pdk)
- [RTimothyEdwards/open_pdks](https://github.com/RTimothyEdwards/open_pdks)

---

## Suggested Signoff Record

For each tapeout, record at minimum:

```text
Project:
Tapeout/Shuttle:
Top Cell:
Die Size:
GF180MCU Option:
Metal Stack:
Top Metal:
MIM Option:
PDK Revision:
open_pdks Revision:
DRC Deck Revision:
LVS Deck Revision:
ERC/Latch-up Deck Revision:
KLayout Version:
Magic Version:
Netgen Version:
LibreLane/OpenROAD Version:
Final GDS SHA-256:
DRC Status:
LVS Status:
ERC/Latch-up Status:
Antenna Status:
Density Status:
Known Waivers:
Reviewer:
Signoff Date:
```
