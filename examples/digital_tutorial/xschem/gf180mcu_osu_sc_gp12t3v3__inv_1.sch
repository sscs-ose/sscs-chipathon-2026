v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 190 -310 190 -280 { lab=VDD}
N 190 -220 190 -190 { lab=Y}
N 190 -190 190 -150 { lab=Y}
N 190 -90 190 -60 { lab=VSS}
N 130 -250 150 -250 { lab=A}
N 260 -180 320 -180 { lab=Y}
N 190 -180 260 -180 { lab=Y}
N 110 -250 110 -120 { lab=A}
N 90 -190 110 -190 { lab=A}
N 110 -250 130 -250 { lab=A}
N 110 -120 150 -120 { lab=A}
N 190 -250 220 -250 { lab=VDD}
N 190 -120 220 -120 { lab=VSS}
C {vdd.sym} 190 -310 0 0 {name=l1 lab=VDD}
C {gnd.sym} 190 -60 0 0 {name=l3 lab=VSS}
C {symbols/pfet_03v3.sym} 170 -250 0 0 {name=M1 L=0.3u W=1.7u m=1 nf=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
C {symbols/nfet_03v3.sym} 170 -120 0 0 {name=M2 L=0.3u W=0.85u m=1 nf=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
C {lab_wire.sym} 220 -250 2 0 {name=l2 sig_type=std_logic lab=VDD
}
C {lab_wire.sym} 220 -120 2 0 {name=l4 sig_type=std_logic lab=VSS
}
C {ipin.sym} 90 -190 0 0 {name=p1 lab=A}
C {opin.sym} 320 -180 0 0 {name=p2 lab=Y}
C {ipin.sym} -30 -60 0 0 {name=p3 lab=VDD}
C {ipin.sym} -30 -30 0 0 {name=p4 lab=VSS}
