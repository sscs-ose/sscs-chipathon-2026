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
N 770 -120 770 -100 {
lab=VSS}
N 680 -260 730 -260 {lab=Vin}
N 680 -260 680 -150 {lab=Vin}
N 680 -150 730 -150 {lab=Vin}
N 770 -100 770 -80 {lab=VSS}
N 770 -330 770 -290 {lab=VDD}
N 770 -230 770 -180 {lab=ASIG}
N 770 -200 790 -200 {lab=ASIG}
N 660 -200 680 -200 {lab=Vin}
N 770 -260 840 -260 {lab=VDD}
N 840 -330 840 -260 {lab=VDD}
N 770 -330 840 -330 {lab=VDD}
N 770 -350 770 -330 {lab=VDD}
N 770 -80 770 -60 {lab=VSS}
N 770 -150 840 -150 {lab=VSS}
N 840 -150 840 -80 {lab=VSS}
N 770 -80 840 -80 {lab=VSS}
N 450 -140 450 -100 {lab=GND}
N 450 -240 450 -200 {lab=Vin}
N 350 -100 450 -100 {lab=GND}
C {vsource.sym} 50 -170 0 0 {name=V1 value=5 savecurrent=false}
C {vsource.sym} 150 -170 0 0 {name=V2 value=5 savecurrent=false}
C {vsource.sym} 250 -170 0 0 {name=V3 value=0 savecurrent=false}
C {vsource.sym} 350 -170 0 0 {name=V4 value=0 savecurrent=false}
C {lab_wire.sym} 50 -240 0 0 {name=p1 sig_type=std_logic lab=DVDD}
C {lab_wire.sym} 150 -240 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {gnd.sym} 200 -80 0 0 {name=l1 lab=GND}
C {lab_wire.sym} 250 -240 0 0 {name=p3 sig_type=std_logic lab=DVSS}
C {lab_wire.sym} 350 -240 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 790 -200 0 1 {name=p5 sig_type=std_logic lab=ASIG}
C {devices/code_shown.sym} 0 -540 0 0 {name=DUT only_toplevel=true
format="tcleval( @value )"
value="
.include "/foss/designs/Chipathon2025_pads/xschem/gf180mcu_fd_io__asig_5p0_extracted.spice"
XDUT DVSS DVDD VSS VDD PAD ASIG gf180mcu_fd_io__asig_5p0_extracted
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
plot V(Vin)+12 V(ASIG)+6 V(PAD)
.endc
"}
C {lab_wire.sym} 770 -350 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 770 -60 0 0 {name=p7 sig_type=std_logic lab=VSS}
C {vsource.sym} 450 -170 0 0 {name=V5 value="PWL(0 0 500n 2.5 1u 5)" savecurrent=false}
C {lab_wire.sym} 450 -240 0 0 {name=p8 sig_type=std_logic lab=Vin}
C {lab_wire.sym} 660 -200 0 0 {name=p9 sig_type=std_logic lab=Vin}
C {symbols/pfet_05v0.sym} 750 -260 0 0 {name=M1
L=0.50u
W=8.0u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {symbols/nfet_05v0.sym} 750 -150 0 0 {name=M2
L=0.60u
W=3.0u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
