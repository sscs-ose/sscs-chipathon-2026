# GF180MCU Inverter Test with NGSPICE

This repository demonstrates how to simulate and verify the standard-cell inverter `gf180mcu_osu_sc_gp12t3v3__inv_1` using NGSPICE with the GF180MCU Open PDK.

## Official GF180MCU PDK Source

https://github.com/google/gf180mcu-pdk

## Recommended Installation Method

Use Open_PDKs:

https://github.com/rtimothyedwards/open_pdks

```bash
git clone https://github.com/rtimothyedwards/open_pdks.git
cd open_pdks
./configure --enable-gf180mcu-pdk
make
sudo make install
```

## Files

- gf180mcu_osu_sc_gp12t3v3__inv_1.spice
- test_inv_1.sp

## Running
The `$PDK_ROOT` environment variable must be set prior to running the `ngspice` file. You may run the SPICE simulation using the command found below:

```bash
ngspice test_inv_1.sp
```

## View Waveforms

Inside ngspice:

```spice
plot v(a) v(y)
```

## Expected Result

Input rises -> Output falls
Input falls -> Output rises

