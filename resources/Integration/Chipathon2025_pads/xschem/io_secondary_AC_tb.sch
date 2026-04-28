v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 60 -100 60 -60 {lab=GND}
N 160 -100 160 -60 {lab=GND}
N 260 -100 260 -60 {lab=GND}
N 360 -100 360 -60 {lab=GND}
N 60 -200 60 -160 {lab=DVDD}
N 160 -200 160 -160 {lab=VDD}
N 260 -200 260 -160 {lab=DVSS}
N 360 -200 360 -160 {lab=VSS}
N 60 -60 360 -60 {lab=GND}
N 210 -60 210 -40 {lab=GND}
N 500 -60 500 -40 {
lab=GND}
N 500 -270 500 -210 {
lab=PAD}
N 500 -150 500 -120 {
lab=#net1}
N 500 -440 500 -270 {lab=PAD}
N 470 -440 500 -440 {lab=PAD}
N 10 -440 40 -440 {lab=to_gate}
N 240 -440 270 -440 {lab=asig}
C {vsource.sym} 60 -130 0 0 {name=V1 value=5 savecurrent=false}
C {vsource.sym} 160 -130 0 0 {name=V2 value=5 savecurrent=false}
C {vsource.sym} 260 -130 0 0 {name=V3 value=0 savecurrent=false}
C {vsource.sym} 360 -130 0 0 {name=V4 value=0 savecurrent=false}
C {lab_wire.sym} 60 -200 0 0 {name=p1 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 160 -200 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {gnd.sym} 210 -40 0 0 {name=l1 lab=GND}
C {lab_wire.sym} 260 -200 0 0 {name=p3 sig_type=std_logic lab=DVSS}
C {lab_wire.sym} 360 -200 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {devices/vsource.sym} 500 -90 0 0 {name=V5 value="DC 3 AC 1"}
C {devices/lab_wire.sym} 500 -250 0 0 {name=p5 sig_type=std_logic lab=PAD}
C {devices/gnd.sym} 500 -40 0 0 {name=l2 lab=GND}
C {devices/res.sym} 500 -180 0 0 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {devices/code_shown.sym} 10 -640 0 0 {name=DUT only_toplevel=true
format="tcleval( @value )"
value="
.include "/foss/designs/Chipathon2025_pads/xschem/gf180mcu_fd_io__asig_5p0_extracted.spice"
"}
C {devices/code_shown.sym} 610 -370 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
"}
C {devices/code_shown.sym} 620 -190 0 0 {name=s1
only_toplevel=false
value="
.ac dec 100 1k 100G
.save all
.control
run
display
plot PAD ASIG
plot vdb(asig) vdb(to_gate)
.endc
"}
C {Chipathon2025_pads/xschem/symbols/io_asig_5p0.sym} 470 -360 0 1 {name=IO1
model=gf180mcu_fd_io__asig_5p0_extracted
spiceprefix=X
}
C {Chipathon2025_pads/xschem/symbols/io_secondary_5p0/io_secondary_5p0.sym} 40 -360 0 0 {name=IO2
spiceprefix=X
}
C {lab_wire.sym} 390 -520 0 1 {name=p6 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 390 -360 0 1 {name=p7 sig_type=std_logic lab=DVSS}
C {lab_wire.sym} 350 -520 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 350 -360 0 0 {name=p9 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 120 -360 0 0 {name=p10 sig_type=std_logic lab=VSS}
C {lab_wire.sym} 120 -520 0 0 {name=p11 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 10 -440 0 0 {name=p12 sig_type=std_logic lab=to_gate}
C {devices/lab_wire.sym} 260 -440 0 0 {name=p13 sig_type=std_logic lab=asig}
