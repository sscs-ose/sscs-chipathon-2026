# 01 -- counter standalone source

Drop-in equivalent of the files that `01_rtl2gds_counter.ipynb` writes
programmatically (cells "Step 3 -- write the counter RTL" and "Step 4
-- write the LibreLane config"). Use these to run the flow directly
without Jupyter:

```bash
# Inside the hpretl/iic-osic-tools:chipathon26 container:
source sak-pdk-script.sh gf180mcuD gf180mcu_fd_sc_mcu7t5v0
cd <path-to-this-dir>
librelane config.yaml
```

`librelane` resolves PDK_ROOT and PDK from the SAK env (no `--pdk-root`
needed for the bare-block Classic flow on GF180). The wrapper at
`/foss/tools/bin/librelane` auto-injects `--manual-pdk`, so the
following are functionally identical:

```bash
librelane config.yaml
librelane config.yaml --pdk gf180mcuD --pdk-root /foss/pdks --manual-pdk
```

The notebook uses the explicit form for self-documentation; this
standalone path uses the implicit form for terseness.

Wall-clock on a modern laptop: ~1-2 min. The run directory lives at
`runs/<timestamp>/`; the signoff metrics at
`runs/<timestamp>/final/metrics.csv`.
