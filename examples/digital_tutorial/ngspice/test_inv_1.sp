* test_inv_1.sp
* NGSPICE testbench for gf180mcu_osu_sc_gp12t3v3__inv_1

************************************
* Include GF180MCU device models
************************************
* Update this path to match your local Open_PDKs installation.
.include $PDK_ROOT/gf180mcuD/libs.tech/ngspice/design.ngspice
.library "$PDK_ROOT/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" typical

************************************
* Include extracted inverter netlist
************************************
.include gf180mcu_osu_sc_gp12t3v3__inv_1.spice

************************************
* Power supplies
************************************
.param VDDVAL=3.3V

VDD vdd 0 DC {VDDVAL}
VSS vss 0 DC 0

************************************
* Input stimulus
************************************
* Pulse: 0 -> 3.3 V, 1 ns rise/fall, 20 ns period
VIN a 0 PULSE(0 {VDDVAL} 2n 100p 100p 10n 20n)

************************************
* Device under test
************************************
XINV a y vdd vss gf180mcu_osu_sc_gp12t3v3__inv_1

************************************
* Output load
************************************
CLOAD y 0 10f

************************************
* Simulation control
************************************
.tran 1p 60n

.control
run

* Plot input and output
plot v(a) v(y)

let VDDVAL = 3.3
let vdd_val = VDDVAL/2

* Measure propagation delays at 50 percent VDD
meas TRAN tphl TRIG v(a) VAL=vdd_val rise=1 TARG v(y) VAL=vdd_val fall=1
meas TRAN tplh TRIG v(a) VAL=vdd_val fall=1 TARG v(y) VAL=vdd_val rise=1

* Measure average delay
let tpd = (tphl + tplh) / 2
print tphl tplh tpd

.endc

.end
