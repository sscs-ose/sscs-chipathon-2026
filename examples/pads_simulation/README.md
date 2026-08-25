This folder contains different test benches and configurations for analog and digital pads.

Description of the files:

## Simulation files of the analog pad (asig_5p0) in the simulations.
1) **asig5V_AC_tb.sch:** AC simulation of the asig_5p0 analog pad.
2) **asig5V_DC_tb.sch:** DC simulation of the ASIG_5P0 analog pad.
3) **asig5V_tran_tb.sch:** Transient simulation of the asig_5p0 analog pad.

Note that there is no symbol associated with the pad in any of these three simulation files, so the model is included to account for its effect on the simulation.

Additionally, the model used in all three simulations is the extracted view of the pad by incorporating the model [gf180mcu_fd_io__asig_5p0_extracted.spice](https://github.com/JuanMoya/sscs-chipathon-2025/blob/main/resources/Integration/Chipathon2025_pads/xschem/gf180mcu_fd_io__asig_5p0_extracted.spice), which includes all the extracted parasitic elements. Comparing the previous file with the non-extracted model of the [asig_5p0 pad](https://github.com/JuanMoya/sscs-chipathon-2025/blob/main/resources/Integration/Chipathon2025_pads/xschem/gf180mcu_fd_io.spice) reveals that the extracted view contains an additional pad pin (PAD), as shown in [Figure 4.5](https://gf180mcu-pdk.readthedocs.io/en/latest/IPs/IO/gf180mcu_fd_io/analog.html). This is the main reason why including the extracted view of the asig_5p0 pad is preferable to using the non-extracted view.

## Simulation files of the digital pad (bi_t) in the simulations.
**bi_t_tran_tb.sch:** Transient simulation of the bi_t digital pad.

The configuration of the pin is based on the documentation provided by GF in [4.1 Digital I/O Cell Control Pins](https://gf180mcu-pdk.readthedocs.io/en/latest/IPs/IO/gf180mcu_fd_io/digital.html) an in [4.2 Tri-state Programmable Digital I/O Cell](https://gf180mcu-pdk.readthedocs.io/en/latest/IPs/IO/gf180mcu_fd_io/tri_state_1.html).

In this schematic, it is possible to observe 3 different configurations based on the values of **IE** and **OE** pins:
1) Bidirectional
2) Output Enabled
3) Input Enabled

## Simulation files of the tiehigh and tielow cells.
**test_tieH_L.sch:** Transient simulation of the tiehigh and tielow cells.
