# digital-tutorial

---

## Tool Installation and PDK Setup

This project uses the open-source GF180MCU Process Design Kit (PDK) together with a complete open-source VLSI design flow based on tools maintained by Dr. Tim Edwards and the broader open-source silicon community.

The recommended installation path is through the `open_pdks` framework, which provides technology setup, device models, standard-cell support, extraction rules, and integration for multiple open-source design tools.

Repository:  
https://github.com/RTimothyEdwards/open_pdks

Many of the required tools are also maintained through Open Circuit Design:

https://opencircuitdesign.com/

These include important tools such as:

- Magic (layout editor and extraction)
- Netgen (LVS verification)
- IRSIM (switch-level simulation)
- Ngspice (circuit simulation)
- Xschem (schematic capture)

For GF180MCU flows, the standard installation approach is to build and install `open_pdks` first, followed by the supporting open-source tools. This ensures proper technology files, extraction decks, SPICE models, and LVS support are correctly configured.

## Typical Installation Flow

1. Install system dependencies  
2. Clone and build Magic, Netgen, Ngspice, Xschem, and related tools  
3. Clone and install `open_pdks`  
4. Configure the GF180MCU PDK  
5. Verify layout extraction, LVS, and simulation flow  

## Example Installation

```bash
git clone git://opencircuitdesign.com/open_pdks
cd open_pdks
./configure --enable-gf180mcu-pdk=/usr/local/share/pdk
make
sudo make install
