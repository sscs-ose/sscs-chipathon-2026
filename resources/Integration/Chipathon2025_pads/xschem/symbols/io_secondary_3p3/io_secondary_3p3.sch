v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 220 -120 220 -90 {lab=VDD}
N 220 -30 220 20 {lab=to_gate}
N 220 0 270 0 {lab=to_gate}
N 170 0 220 0 {lab=to_gate}
N 330 -0 380 -0 {lab=ASIG5V}
N 300 -120 300 -20 {lab=VDD}
N 220 -120 300 -120 {lab=VDD}
N 220 80 220 130 {lab=VSS}
C {symbols/ppolyf_u.sym} 300 0 1 0 {name=R1
W=16e-6
L=4e-6
model=ppolyf_u
spiceprefix=X
m=1}
C {iopin.sym} 220 130 2 0 {name=p1 lab=VSS}
C {iopin.sym} 220 -120 2 0 {name=p2 lab=VDD}
C {iopin.sym} 170 0 2 0 {name=p3 lab=to_gate}
C {iopin.sym} 380 0 0 0 {name=p4 lab=ASIG3V3}
C {symbols/diode_nd2ps_03v3.sym} 220 50 2 0 {name=D2
model=diode_nd2ps_03v3
r_w=10u
r_l=10u
m=4}
C {symbols/diode_pd2nw_03v3.sym} 220 -60 2 0 {name=D1
model=diode_pd2nw_03v3
r_w=10u
r_l=10u
m=4}
