To run netgen, please use the following nomenclature:
```bash
netgen -batch lvs "../magic/ngspice/$1.spice $1" "../xschem/$1.spice $1" $PDK_ROOT/gf180mcuD/libs.tech/netgen/gf180mcuD_setup.tcl $1.out
```

Or this can be accomplished by running the runNetgen.bash script:
```bash
./runNetlist.bash gf180mcu_osu_sc_gp12t3v3__inv_1
```

Keep in mind that the above script utilizes the top-level name in place of the "gf180mcu_osu_sc_gp12t3v3__inv_1" name shown above if other circuits are desired.