
Add fills to chip top
=====================

We need to add fills to fix the density rules for the PDK. The scripts we use
are originally in the repository for primitive devices from the FOSSI
Foundation. However, we have altered slightly to avoid leaving inner padding
because of guard ring (as is expected to be placed by the foundry).

The scripts are intended to be run with klayout and are available in this fork:

https://github.com/LuighiV/globalfoundries-pdk-libs-gf180mcu_fd_pr/tree/main

To use it inside the chipathon docker image, we need to patch it by running the
script [./patch-scripts.py](patch-scripts.py)

After the scripts are patched, we can call them to run in the specific gds.
For example:

```
\klayout -b -zz -r ${PDK_ROOT}/${PDK}/libs.tech/klayout/tech/scripts/fill_all.rb -rd input=SSCS_2026_01.gds -rd output=SSCS_2026_01_filled.gds -rd no_scribe_line=true
```

PD: Here I'm using `\klayout` instead of `klayout` because we need to skip any
alias that overrides it. This is useful in case you use the analog
template suggested for gLayout. For other scenarios, simply `klayout` is
enough.
