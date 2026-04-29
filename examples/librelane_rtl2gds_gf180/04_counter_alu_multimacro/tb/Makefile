# cocotb test dispatcher for the counter + ALU multi-macro example.
#
# RTL sim (pre-synthesis):
#   make test-counter       # 4 cocotb tests on counter.sv
#   make test-alu           # 16x16x8 sweep on alu.sv
#   make test-all
#
# Gate-level sim (post-synthesis, against LibreLane Classic netlists):
#   make test-counter-gl    # counter.nl.v + gf180 stdcell models
#   make test-alu-gl        # alu_macro.nl.v driven via test_alu_macro
#   make test-gl-all
#
#   make clean
#
# Requires:  cocotb, icarus-verilog  (both in hpretl/iic-osic-tools)
# GL builds assume LibreLane has already produced build/<name>/final/.

.PHONY: test-counter test-alu test-all \
        test-counter-gl test-alu-gl test-gl-all clean

TOPLEVEL_LANG ?= verilog
SIM           ?= icarus
RTL            = ../rtl

# Build artefacts produced by librelane --save-views-to ../build/<name>
BUILD          = ../build
# GF180 gate-level stdcell + primitives verilog (shipped by wafer-space PDK fork).
# The fork can live under either the example's dedicated multimacro_chipathon
# path (set by the notebook) or the chipathon_padring baseline. The
# expression below falls back between them so `make test-gl-*` works in
# both layouts.
PDK_VLOG      ?= $(firstword \
    $(wildcard /foss/designs/multimacro_chipathon/template/gf180mcu/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog) \
    $(wildcard /foss/designs/chipathon_padring/template/gf180mcu/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog))

# ----- RTL sim -------------------------------------------------------------

test-counter:
	$(MAKE) -f Makefile.cocotb \
	    TOPLEVEL=counter \
	    MODULE=test_counter \
	    VERILOG_SOURCES="$(RTL)/counter.sv" \
	    SIM_BUILD=sim_build_counter

test-alu:
	$(MAKE) -f Makefile.cocotb \
	    TOPLEVEL=alu \
	    MODULE=test_alu \
	    VERILOG_SOURCES="$(RTL)/alu.sv" \
	    SIM_BUILD=sim_build_alu

test-all: test-counter test-alu

# ----- gate-level sim ------------------------------------------------------
# Notes:
#   * Uses the *logical* netlist (nl/, not pnl/) so cocotb does not need to
#     wire VDD/VSS. The powered netlist is reserved for post-layout SDF runs.
#   * GL sims require the GF180 stdcell verilog models to be compiled in
#     alongside the DUT netlist.
#   * ICARUS_FLAGS unset UDPs that iverilog rejects (gf180 stdcell primitives
#     use specify blocks which iverilog accepts at the -g2012 level).

# GL sim timescale: the gf180 stdcell + primitives sources carry no
# `timescale directive, and counter.nl.v / alu_macro.nl.v are likewise
# timescale-free. Compiling them alone drops iverilog to its 1s/1s
# default precision; the TB's cocotb.Clock(period=10, units="ns") then
# trips with "Unable to accurately represent 10(ns) with the simulator
# precision of 1e0". tb/timescale.v sets 1ns/1ps before any stdcell
# model is parsed.
COMPILE_ARGS = -g2012

test-counter-gl:
	$(MAKE) -f Makefile.cocotb \
	    TOPLEVEL=counter \
	    MODULE=test_counter \
	    COMPILE_ARGS="$(COMPILE_ARGS) -DFUNCTIONAL -DUNIT_DELAY=\#1" \
	    VERILOG_SOURCES="timescale.v $(PDK_VLOG)/primitives.v $(PDK_VLOG)/gf180mcu_fd_sc_mcu7t5v0.v $(BUILD)/counter/nl/counter.nl.v" \
	    SIM_BUILD=sim_build_counter_gl

test-alu-gl:
	$(MAKE) -f Makefile.cocotb \
	    TOPLEVEL=alu_macro \
	    MODULE=test_alu_macro \
	    COMPILE_ARGS="$(COMPILE_ARGS) -DFUNCTIONAL -DUNIT_DELAY=\#1" \
	    VERILOG_SOURCES="timescale.v $(PDK_VLOG)/primitives.v $(PDK_VLOG)/gf180mcu_fd_sc_mcu7t5v0.v $(BUILD)/alu_macro/nl/alu_macro.nl.v" \
	    SIM_BUILD=sim_build_alu_gl

test-gl-all: test-counter-gl test-alu-gl

clean:
	rm -rf sim_build sim_build_counter sim_build_alu \
	       sim_build_counter_gl sim_build_alu_gl results.xml
