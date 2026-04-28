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
lab=ASIG}
N 500 -150 500 -120 {
lab=#net1}
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
C {devices/lab_wire.sym} 500 -250 0 0 {name=p5 sig_type=std_logic lab=ASIG}
C {devices/gnd.sym} 500 -40 0 0 {name=l2 lab=GND}
C {devices/res.sym} 500 -180 0 0 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {devices/code_shown.sym} 10 -500 0 0 {name=DUT only_toplevel=true
format="tcleval( @value )"
value="
.include "/foss/designs/Chipathon2025_pads/xschem/gf180mcu_fd_io__asig_5p0_extracted.spice"
XDUT DVSS DVDD VSS VDD PAD ASIG gf180mcu_fd_io__asig_5p0_extracted
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
plot vdb(asig) vdb(pad)
.endc
"}
