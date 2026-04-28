v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
B 2 1200 -440 1790 20 {flags=graph
y1=-30.547443
y2=20.010549
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=5e-09
x2=1.05e-07
divx=5
subdivx=1



unitx=1
dataset=-1
color="5 4"
node="z_2
z_1"
sim_type=tran
digital=0
autoload=1
rawfile=$netlist_dir/test_tieH_L.raw}
N 650 -130 650 -20 {
lab=G}
N 690 -70 690 -50 {
lab=G}
N 650 -70 690 -70 {
lab=G}
N 690 -100 770 -100 {
lab=Z_1}
N 690 -200 690 -160 {
lab=D}
N 690 -130 710 -130 {
lab=D}
N 710 -170 710 -130 {
lab=D}
N 690 -170 710 -170 {
lab=D}
N 690 10 690 50 {
lab=S}
N 690 -20 710 -20 {
lab=S}
N 710 -20 710 20 {
lab=S}
N 690 20 710 20 {
lab=S}
N 980 -130 980 -20 {
lab=G2}
N 1020 -200 1020 -160 {
lab=D}
N 1020 -130 1040 -130 {
lab=D}
N 1040 -170 1040 -130 {
lab=D}
N 1020 -170 1040 -170 {
lab=D}
N 1020 10 1020 50 {
lab=S}
N 1020 -20 1040 -20 {
lab=S}
N 1040 -20 1040 20 {
lab=S}
N 1020 20 1040 20 {
lab=S}
N 980 -100 1020 -100 {
lab=G2}
N 820 -350 820 -320 {
lab=#net1}
N 820 -450 820 -410 {
lab=#net2}
N 1020 -50 1130 -50 {
lab=Z_2}
N 620 -90 650 -90 {
lab=G}
N 920 -80 980 -80 {
lab=G2}
N 600 -90 620 -90 {
lab=G}
C {devices/code_shown.sym} -50 110 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/lab_pin.sym} 690 50 0 0 {name=l3 sig_type=std_logic lab=S}
C {devices/code_shown.sym} 140 -480 0 0 {name=NGSPICE only_toplevel=true
value="
.option gmin=1e-15

vd d 0 3.3
vs s 0 0
vb b 0 0
.control
save all


tran 1p 100n
write test_tieH_L.raw
set appendwrite

op
write test_tieH_L.raw

.endc
*.save all
"}
C {symbols/nfet_03v3.sym} 670 -20 0 0 {name=M1
L=0.6u
W=0.82u
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 670 -130 0 0 {name=M2
L=0.5u
W=1.22u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {devices/lab_pin.sym} 690 -200 0 0 {name=l5 sig_type=std_logic lab=D}
C {devices/lab_pin.sym} 770 -100 0 1 {name=l1 sig_type=std_logic lab=Z_1}
C {devices/launcher.sym} 480 -390 0 0 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"}
C {devices/lab_pin.sym} 1020 50 0 0 {name=l4 sig_type=std_logic lab=S}
C {symbols/nfet_03v3.sym} 1000 -20 0 0 {name=M3
L=0.5u
W=1.22u
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 1000 -130 0 0 {name=M4
L=0.5u
W=1.22u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {devices/lab_pin.sym} 1020 -200 0 0 {name=l6 sig_type=std_logic lab=D}
C {devices/launcher.sym} 1255 -485 0 0 {name=h2
descr="Click left mouse button here with control key
pressed to load/unload waveforms in graph."
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw
"
}
C {devices/vsource.sym} 820 -380 0 0 {name=V1 value="pulse(0 3.3 0 20n 20n 10u 100u)"
spice_ignore=true}
C {devices/lab_pin.sym} 820 -450 0 0 {name=l9 sig_type=std_logic lab=D
spice_ignore=true}
C {devices/lab_pin.sym} 820 -320 0 0 {name=l10 sig_type=std_logic lab=S
spice_ignore=true}
C {devices/lab_pin.sym} 1130 -50 0 1 {name=l7 sig_type=std_logic lab=Z_2}
C {devices/lab_pin.sym} 600 -90 0 0 {name=l2 sig_type=std_logic lab=G}
C {devices/lab_pin.sym} 920 -80 0 0 {name=l8 sig_type=std_logic lab=G2}
