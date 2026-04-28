v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 650 -210 650 -110 {
lab=GND}
N 650 -240 720 -240 {
lab=b}
N 650 -350 780 -350 {
lab=d}
N 520 -240 610 -240 {
lab=g}
N 650 -350 650 -270 {
lab=d}
N 780 -350 780 -270 {
lab=d}
N 720 -130 720 -110 {
lab=GND}
N 720 -240 720 -190 {
lab=b}
N 780 -210 780 -110 {
lab=GND}
N 520 -240 520 -190 {
lab=g}
N 520 -130 520 -110 {
lab=GND}
N 870 -130 870 -110 {
lab=GND}
N 870 -230 870 -190 {
lab=n}
C {devices/code_shown.sym} 0 -1010 0 0 {name=NGSPICE_CTRL only_toplevel=true 
value="
.option sparse
.temp 27
.param wx=5u lx=0.28u vbx=0
.noise v(n) vg lin 1 1 1 1
.control
option numdgt=3
set wr_singlescale
set wr_vecnames

compose l_vec  values 0.28u 0.4u 0.5u 1u 5u 10u
compose vg_vec start= 0 stop=3.31  step=0.05
compose vd_vec start= 0 stop=3.31  step=0.05
compose vb_vec values 0 0.4 0.8 1.2

foreach var1 $&l_vec
  alterparam lx=$var1
  reset
  foreach var2 $&vg_vec
    alter vg $var2
    foreach var3 $&vd_vec
      alter vd $var3
      foreach var4 $&vb_vec
        alter vsb $var4
	run 
	wrdata techsweep_gf180mcu_nmos_3v3.txt noise1.all
	destroy all
	set appendwrite
	unset set wr_vecnames
      end
    end
  end
end

set appendwrite=0

alterparam lx=0.28u
alterparam vbx=0
reset
op
*showmod
show
write techsweep_gf180mcu_nmos_3v3.raw
.endc
"}
C {devices/gnd.sym} 650 -110 0 0 {name=l1 lab=GND}
C {devices/gnd.sym} 520 -110 0 0 {name=l2 lab=GND}
C {devices/vsource.sym} 520 -160 0 0 {name=vg value="0.65 AC 1"}
C {devices/vsource.sym} 780 -240 0 0 {name=vd value=0.75}
C {devices/gnd.sym} 780 -110 0 0 {name=l3 lab=GND}
C {devices/gnd.sym} 720 -110 0 0 {name=l4 lab=GND}
C {devices/title.sym} 160 -30 0 0 {name=l5 author="(c) 2025 H. Pretl, Apache-2.0 license"}
C {devices/launcher.sym} 740 -480 0 0 {name=h2
descr="simulate" 
tclcommand="xschem save; xschem netlist; xschem simulate"
}
C {devices/launcher.sym} 740 -440 0 0 {name=h3
descr="annotate OP" 
tclcommand="xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw; set show_hidden_texts 1; xschem annotate_op"
}
C {devices/ngspice_get_value.sym} 1020 -300 0 1 {name=r2 node=@m.xm1.m0[gds]
descr="gds="}
C {devices/ngspice_get_value.sym} 1020 -330 0 1 {name=r4 node=@m.xm1.m0[gm]
descr="gm="}
C {devices/ngspice_get_value.sym} 1020 -270 0 1 {name=r5 node=v(@m.xm1.m0[vth])
descr="vth="}
C {devices/ngspice_get_value.sym} 1020 -210 0 1 {name=r6 node=@m.xm1.m0[cgg]
descr="cgs="}
C {devices/ngspice_get_value.sym} 1020 -240 0 1 {name=r7 node=v(@m.xm1.m0[vdsat])
descr="vdsat="}
C {devices/ngspice_get_value.sym} 1020 -180 0 1 {name=r9 node=@m.xm1.m0[cgd]
descr="cdg="}
C {devices/vsource.sym} 720 -160 2 1 {name=vsb value=\{vbx\}}
C {devices/lab_wire.sym} 520 -240 0 0 {name=p1 sig_type=std_logic lab=g}
C {devices/lab_wire.sym} 650 -350 0 0 {name=p2 sig_type=std_logic lab=d}
C {devices/lab_wire.sym} 720 -240 0 1 {name=p3 sig_type=std_logic lab=b}
C {devices/code_shown.sym} 620 -1010 0 0 {name=NGSPICE_SAVE only_toplevel=true 
value="
.save b d g n
.save @m.xm1.m0[cgso]
.save @m.xm1.m0[cgdo]
.save @m.xm1.m0[cdd]
.save @m.xm1.m0[cgb]
.save @m.xm1.m0[cgd]
.save @m.xm1.m0[cgg]
.save @m.xm1.m0[cgs]
.save @m.xm1.m0[css]
.save @m.xm1.m0[gds]
.save @m.xm1.m0[gm]
.save @m.xm1.m0[gmbs]
.save @m.xm1.m0[id]
.save @m.xm1.m0[l]
.save @m.xm1.m0[vgs]
.save @m.xm1.m0[vds]
.save @m.xm1.m0[vbs]
.save @m.xm1.m0[vth]
.save @m.xm1.m0[vdsat]
"}
C {devices/ccvs.sym} 870 -160 0 0 {name=H4 vnam=vd value=1}
C {devices/gnd.sym} 870 -110 0 0 {name=l6 lab=GND}
C {devices/lab_pin.sym} 870 -220 0 0 {name=p4 sig_type=std_logic lab=n
}
C {symbols/nfet_03v3.sym} 630 -240 0 0 {name=M1
L=\{lx\}
W=\{wx\}
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
C {devices/code_shown.sym} 0 -150 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
