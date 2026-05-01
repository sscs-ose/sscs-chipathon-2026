v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 50 -270 50 -240 {lab=GND}
N 170 -270 170 -240 {lab=GND}
N 110 -270 110 -240 {lab=GND}
N 50 -370 50 -330 {lab=VDD}
N 110 -370 110 -330 {lab=VSS}
N 170 -370 170 -330 {lab=A}
N 590 -90 620 -90 {lab=Y}
C {vsource.sym} 50 -300 0 0 {name=V1 value=3.3 savecurrent=false}
C {vsource.sym} 110 -300 0 0 {name=V2 value=0 savecurrent=false}
C {vsource.sym} 170 -300 0 0 {name=V3 value="PULSE(0 3.3 0 1ns 1ns 2us 4us)"}
C {lab_wire.sym} 170 -370 0 0 {name=p2 sig_type=std_logic lab=A
}
C {opin.sym} 620 -90 0 0 {name=p5 lab=Y}
C {code.sym} 20 -160 0 0 {name=COMMAND 
only_toplevel=false
value="
.include $PDK_ROOT/gf180mcuD/libs.tech/ngspice/design.ngspice
.library \\"$PDK_ROOT/gf180mcuD/libs.tech/ngspice/sm141064.ngspice\\" typical

.control
TRAN 0.1u 5u
save all
set filetype=binary
write tb_inv_tran.raw
.endc
"}
C {ipin.sym} 290 -90 0 0 {name=p7 lab=A
}
C {lab_pin.sym} 50 -240 0 0 {name=pwr1 sig_type=std_logic lab=GND}
C {lab_pin.sym} 110 -240 0 0 {name=pwr2 sig_type=std_logic lab=GND}
C {lab_pin.sym} 170 -240 0 0 {name=pwr3 sig_type=std_logic lab=GND}
C {lab_pin.sym} 50 -370 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 110 -370 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {gf180mcu_osu_sc_gp12t3v3__inv_1.sym} 440 -90 0 0 {name=x1 VDD=VDD VSS=VSS}
