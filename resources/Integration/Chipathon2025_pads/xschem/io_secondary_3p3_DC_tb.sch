v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 50 -140 50 -100 {lab=GND}
N 150 -140 150 -100 {lab=GND}
N 250 -140 250 -100 {lab=GND}
N 350 -140 350 -100 {lab=GND}
N 50 -240 50 -200 {lab=DVDD}
N 150 -240 150 -200 {lab=VDD}
N 250 -240 250 -200 {lab=DVSS}
N 350 -240 350 -200 {lab=VSS}
N 50 -100 350 -100 {lab=GND}
N 200 -100 200 -80 {lab=GND}
N 450 -140 450 -100 {lab=GND}
N 450 -240 450 -200 {lab=PAD}
N 350 -100 450 -100 {lab=GND}
N 520 -430 550 -430 {lab=PAD}
N 60 -430 90 -430 {lab=to_gate}
N 290 -430 320 -430 {lab=asig}
C {vsource.sym} 50 -170 0 0 {name=V1 value=3 savecurrent=false}
C {vsource.sym} 150 -170 0 0 {name=V2 value=3 savecurrent=false}
C {vsource.sym} 250 -170 0 0 {name=V3 value=0 savecurrent=false}
C {vsource.sym} 350 -170 0 0 {name=V4 value=0 savecurrent=false}
C {lab_wire.sym} 50 -240 0 0 {name=p1 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 150 -240 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {gnd.sym} 200 -80 0 0 {name=l1 lab=GND}
C {lab_wire.sym} 250 -240 0 0 {name=p3 sig_type=std_logic lab=DVSS}
C {lab_wire.sym} 350 -240 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {devices/code_shown.sym} 0 -660 0 0 {name=DUT only_toplevel=true
format="tcleval( @value )"
value="
.include "/foss/designs/Chipathon2025_pads/xschem/gf180mcu_fd_io__asig_5p0_extracted.spice"
"}
C {devices/code_shown.sym} 930 -410 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
"}
C {devices/code_shown.sym} 940 -230 0 0 {name=s1
only_toplevel=false
value="

.control
tran 1n 1u
plot V(PAD)+12 V(ASIG)+6 V(to_gate)
.endc
"}
C {vsource.sym} 450 -170 0 0 {name=V5 value="PWL(0 -10 500n 10 1u -10)" savecurrent=false}
C {lab_wire.sym} 450 -240 0 0 {name=p8 sig_type=std_logic lab=PAD}
C {Chipathon2025_pads/xschem/symbols/io_asig_5p0.sym} 520 -350 0 1 {name=IO1
model=gf180mcu_fd_io__asig_5p0_extracted
spiceprefix=X
}
C {lab_wire.sym} 440 -510 0 1 {name=p10 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 440 -350 0 1 {name=p11 sig_type=std_logic lab=DVSS}
C {lab_wire.sym} 400 -510 0 0 {name=p12 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 400 -350 0 0 {name=p13 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 170 -350 0 0 {name=p14 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 170 -510 0 0 {name=p15 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 60 -430 0 0 {name=p16 sig_type=std_logic lab=to_gate}
C {devices/lab_wire.sym} 310 -430 0 0 {name=p17 sig_type=std_logic lab=asig}
C {devices/lab_wire.sym} 550 -430 0 1 {name=p18 sig_type=std_logic lab=PAD}
C {Chipathon2025_pads/xschem/symbols/io_secondary_3p3/io_secondary_3p3.sym} 90 -350 0 0 {name=IO2
spiceprefix=X
}
