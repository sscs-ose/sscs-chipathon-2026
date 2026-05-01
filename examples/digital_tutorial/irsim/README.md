to use IRSIM, type the following:

irsim gf180D_tt_nom_27.prm gf180mcu_osu_sc_gp12t3v3__inv_1.sim -gf180mcu_osu_sc_gp12t3v3__inv_1.cmd

gf180mcu_osu_sc_gp12t3v3__inv_1.cmd is a batch or command file that helps runs the commands
automatically

# Custom Xresources Setup for IRSIM

This document describes how to install and use a custom `.Xresources` configuration for **IRSIM**, including Oklahoma State University (OSU) themed highlighting and improved default visualization settings.

The custom configuration provides:

- Black background for improved waveform visibility
- White foreground text for contrast
- OSU orange highlighting for traces and active signals
- Improved banner readability
- Defined geometry for terminal placement
- Consistent font and border settings

---

## Custom `.Xresources` File

Create or update your `.Xresources` file in your home directory:

```bash
~/.Xresources
