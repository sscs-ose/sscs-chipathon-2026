v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {Bidirectional configuration} 290 -290 0 0 0.4 0.4 {}
T {Output enabled configuration} 760 -290 0 0 0.4 0.4 {}
T {Input enabled configuration} 1210 -290 0 0 0.4 0.4 {}
N 150 -490 150 -470 {
lab=GND}
N 150 -610 150 -550 {
lab=DVDD}
N 210 -490 210 -470 {
lab=GND}
N 210 -610 210 -550 {
lab=VDD}
N 150 -470 210 -470 {
lab=GND}
N 270 -490 270 -470 {
lab=GND}
N 270 -610 270 -550 {
lab=DVSS}
N 330 -490 330 -470 {
lab=GND}
N 330 -610 330 -550 {
lab=VSS}
N 270 -470 330 -470 {
lab=GND}
N 210 -470 270 -470 {
lab=GND}
N 460 -110 460 -90 {
lab=GND}
N 460 -230 460 -170 {
lab=A0}
N 340 -110 340 -90 {
lab=GND}
N 340 -230 340 -170 {
lab=IE_0}
N 400 -110 400 -90 {
lab=GND}
N 340 -90 400 -90 {
lab=GND}
N 400 -230 400 -170 {
lab=OE_0}
N 390 -490 390 -470 {
lab=GND}
N 330 -470 390 -470 {
lab=GND}
N 390 -610 390 -550 {
lab=PU}
N 450 -490 450 -470 {
lab=GND}
N 390 -470 450 -470 {
lab=GND}
N 450 -610 450 -550 {
lab=PD}
N 510 -490 510 -470 {
lab=GND}
N 450 -470 510 -470 {
lab=GND}
N 510 -610 510 -550 {
lab=SL}
N 570 -490 570 -470 {
lab=GND}
N 510 -470 570 -470 {
lab=GND}
N 570 -610 570 -550 {
lab=CS}
N 670 -490 670 -470 {
lab=GND}
N 670 -610 670 -550 {
lab=PDRV0}
N 760 -490 760 -470 {
lab=GND}
N 700 -470 760 -470 {
lab=GND}
N 760 -610 760 -550 {
lab=PDRV1}
N 460 -90 460 -70 {lab=GND}
N 670 -470 700 -470 {lab=GND}
N 570 -470 670 -470 {lab=GND}
N 400 -90 460 -90 {lab=GND}
N 930 -110 930 -90 {
lab=GND}
N 930 -230 930 -170 {
lab=A1}
N 810 -110 810 -90 {
lab=GND}
N 810 -230 810 -170 {
lab=IE_1}
N 870 -110 870 -90 {
lab=GND}
N 810 -90 870 -90 {
lab=GND}
N 870 -230 870 -170 {
lab=OE_1}
N 930 -90 930 -70 {lab=GND}
N 870 -90 930 -90 {lab=GND}
N 1380 -110 1380 -90 {
lab=GND}
N 1380 -230 1380 -170 {
lab=PAD2}
N 1260 -110 1260 -90 {
lab=GND}
N 1260 -230 1260 -170 {
lab=IE_2}
N 1320 -110 1320 -90 {
lab=GND}
N 1260 -90 1320 -90 {
lab=GND}
N 1320 -230 1320 -170 {
lab=OE_2}
N 1380 -90 1380 -70 {lab=GND}
N 1320 -90 1380 -90 {lab=GND}
C {devices/code_shown.sym} 1050 -630 0 0 {name=s1
only_toplevel=false
value="
.tran 100p 100n
.save all
.control
run
display
plot A0 PAD0 Y0
plot A1 PAD1 Y1
plot A2 PAD2 Y2
.endc
"}
C {devices/code_shown.sym} 1050 -800 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
"}
C {devices/code_shown.sym} 70 -770 0 0 {name=DUT only_toplevel=true
format="tcleval( @value )"
value="
.include "/foss/designs/Chipathon2025_pads/xschem/gf180mcu_fd_io.spice"
XDUT0 A0 CS DVDD DVSS IE_0 OE_0 PAD0 PD PDRV0 PDRV1 PU SL VDD VSS Y0 gf180mcu_fd_io__bi_t
XDUT1 A1 CS DVDD DVSS IE_1 OE_1 PAD1 PD PDRV0 PDRV1 PU SL VDD VSS Y1 gf180mcu_fd_io__bi_t
XDUT2 A2 CS DVDD DVSS IE_2 OE_2 PAD2 PD PDRV0 PDRV1 PU SL VDD VSS Y2 gf180mcu_fd_io__bi_t
"}
C {devices/vsource.sym} 150 -520 0 0 {name=V1 value=5}
C {devices/gnd.sym} 150 -470 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} 150 -590 0 0 {name=p1 sig_type=std_logic lab=DVDD}
C {devices/vsource.sym} 210 -520 0 0 {name=V2 value=5}
C {devices/lab_wire.sym} 210 -590 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 270 -520 0 0 {name=V3 value=0}
C {devices/lab_wire.sym} 270 -590 0 0 {name=p3 sig_type=std_logic lab=DVSS}
C {devices/vsource.sym} 330 -520 0 0 {name=V4 value=0}
C {devices/lab_wire.sym} 330 -590 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {devices/vsource.sym} 460 -140 0 0 {name=V5 value="PULSE(0 5 10n 100p 100p 10n 20n)"}
C {devices/lab_wire.sym} 460 -210 0 0 {name=p5 sig_type=std_logic lab=A0}
C {devices/vsource.sym} 340 -140 0 0 {name=V7 value=5}
C {devices/lab_wire.sym} 340 -210 0 0 {name=p7 sig_type=std_logic lab=IE_0}
C {devices/vsource.sym} 400 -140 0 0 {name=V8 value=5}
C {devices/lab_wire.sym} 400 -210 0 0 {name=p8 sig_type=std_logic lab=OE_0}
C {devices/vsource.sym} 390 -520 0 0 {name=V9 value=0}
C {devices/lab_wire.sym} 390 -590 0 0 {name=p9 sig_type=std_logic lab=PU}
C {devices/vsource.sym} 450 -520 0 0 {name=V10 value=0}
C {devices/lab_wire.sym} 450 -590 0 0 {name=p10 sig_type=std_logic lab=PD}
C {devices/vsource.sym} 510 -520 0 0 {name=V11 value=0}
C {devices/lab_wire.sym} 510 -590 0 0 {name=p11 sig_type=std_logic lab=SL}
C {devices/gnd.sym} 460 -70 0 0 {name=l2 lab=GND}
C {devices/vsource.sym} 570 -520 0 0 {name=V13 value=5}
C {devices/lab_wire.sym} 570 -590 0 0 {name=p13 sig_type=std_logic lab=CS}
C {devices/vsource.sym} 670 -520 0 0 {name=V6 value=0}
C {devices/lab_wire.sym} 670 -590 0 0 {name=p6 sig_type=std_logic lab=PDRV0}
C {devices/vsource.sym} 760 -520 0 0 {name=V12 value=0}
C {devices/lab_wire.sym} 760 -590 0 0 {name=p12 sig_type=std_logic lab=PDRV1}
C {devices/vsource.sym} 930 -140 0 0 {name=V14 value="PULSE(0 5 10n 100p 100p 10n 20n)"}
C {devices/lab_wire.sym} 930 -210 0 0 {name=p14 sig_type=std_logic lab=A1}
C {devices/vsource.sym} 810 -140 0 0 {name=V15 value=0}
C {devices/lab_wire.sym} 810 -210 0 0 {name=p15 sig_type=std_logic lab=IE_1}
C {devices/vsource.sym} 870 -140 0 0 {name=V16 value=5}
C {devices/lab_wire.sym} 870 -210 0 0 {name=p16 sig_type=std_logic lab=OE_1}
C {devices/gnd.sym} 930 -70 0 0 {name=l3 lab=GND}
C {devices/vsource.sym} 1380 -140 0 0 {name=V17 value="PULSE(0 5 10n 100p 100p 10n 20n)"}
C {devices/lab_wire.sym} 1380 -210 0 0 {name=p17 sig_type=std_logic lab=PAD2}
C {devices/vsource.sym} 1260 -140 0 0 {name=V18 value=5}
C {devices/lab_wire.sym} 1260 -210 0 0 {name=p18 sig_type=std_logic lab=IE_2}
C {devices/vsource.sym} 1320 -140 0 0 {name=V19 value=0}
C {devices/lab_wire.sym} 1320 -210 0 0 {name=p19 sig_type=std_logic lab=OE_2}
C {devices/gnd.sym} 1380 -70 0 0 {name=l4 lab=GND}
