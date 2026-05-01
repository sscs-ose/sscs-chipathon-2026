#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# setup_opencircuitdesign.sh
#
# Environment setup for Magic / Netgen / ngspice / xschem / irsim
# plus open_pdks (gf180mcuD preferred, sky130A fallback) under: $HOME/ocd
#
# Author : James E. Stine <james.stine@okstate.edu>
# Date   : 2026-04-29
#
# Usage  : source setup.sh
#          PDK_PREFERENCE=sky130A source setup.sh    # override default PDK
# -----------------------------------------------------------------------------

# -------------------------------------------------------------------
# Root of your OpenCircuitDesign install
# -------------------------------------------------------------------
export OPEN_CIRCUITDESIGN_ROOT="$HOME/ocd"

# Sanity check
if [ ! -d "$OPEN_CIRCUITDESIGN_ROOT" ]; then
    echo "ERROR: Directory $OPEN_CIRCUITDESIGN_ROOT does not exist."
    return 1 2>/dev/null || exit 1
fi

# -------------------------------------------------------------------
# PATH and library paths
# -------------------------------------------------------------------

# Binaries (magic, netgen, ngspice, xschem, irsim, etc.)
if [ -d "$OPEN_CIRCUITDESIGN_ROOT/bin" ]; then
    export PATH="$OPEN_CIRCUITDESIGN_ROOT/bin:$PATH"
fi

# Shared libraries
if [ -d "$OPEN_CIRCUITDESIGN_ROOT/lib" ]; then
    if [ -z "$LD_LIBRARY_PATH" ]; then
        export LD_LIBRARY_PATH="$OPEN_CIRCUITDESIGN_ROOT/lib"
    else
        export LD_LIBRARY_PATH="$OPEN_CIRCUITDESIGN_ROOT/lib:$LD_LIBRARY_PATH"
    fi
fi

# -------------------------------------------------------------------
# PDK_ROOT for open_pdks
# -------------------------------------------------------------------
# This is the standard install location for open_pdks when configured
# with --prefix=$OPEN_CIRCUITDESIGN_ROOT (PDKs land in $prefix/share/pdk).
#
if [ -d "$OPEN_CIRCUITDESIGN_ROOT/share/pdk" ]; then
    export PDK_ROOT="$OPEN_CIRCUITDESIGN_ROOT/share/pdk"
else
    echo "WARNING: No PDK directory found under $OPEN_CIRCUITDESIGN_ROOT/share/pdk"
fi

# -------------------------------------------------------------------
# Tool-specific setup (generic)
# -------------------------------------------------------------------

# ngspice shared data
if [ -d "$OPEN_CIRCUITDESIGN_ROOT/share/ngspice" ]; then
    export NGSPICE_SHARE_DIR="$OPEN_CIRCUITDESIGN_ROOT/share/ngspice"
fi

# xschem system libraries (generic symbols, etc.)
if [ -d "$OPEN_CIRCUITDESIGN_ROOT/share/xschem" ]; then
    export XSCHEM_SYSTEM_LIBRARY_PATH="$OPEN_CIRCUITDESIGN_ROOT/share/xschem"
fi

# magic system libraries
if [ -d "$OPEN_CIRCUITDESIGN_ROOT/share/magic" ]; then
    export MAGIC_HOME="$OPEN_CIRCUITDESIGN_ROOT/share/magic"
fi

# netgen system libraries
if [ -d "$OPEN_CIRCUITDESIGN_ROOT/share/netgen" ]; then
    export NETGEN_HOME="$OPEN_CIRCUITDESIGN_ROOT/share/netgen"
fi

# -------------------------------------------------------------------
# Active PDK selection
# -------------------------------------------------------------------
# Priority order:
#   1. PDK_PREFERENCE   -- if set in the environment before sourcing this
#                          script, that PDK is used (e.g. PDK_PREFERENCE=sky130A)
#   2. gf180mcuD        -- preferred default
#   3. sky130A          -- fallback
#
# To force sky130A in a single shell:
#     PDK_PREFERENCE=sky130A source setup.sh
#
PDK_PREFERENCE="${PDK_PREFERENCE:-gf180mcuD}"

_select_pdk() {
    # $1 = PDK name, e.g. gf180mcuD or sky130A
    local pdkname="$1"
    local pdkpath="$PDK_ROOT/$pdkname"

    [ -d "$pdkpath" ] || return 1

    export PDK="$pdkname"

    # Convenience var matching the PDK name (e.g. GF180MCU_C, SKY130A).
    # Uppercase, '-' -> '_'.
    local varname
    varname="$(echo "$pdkname" | tr '[:lower:]-' '[:upper:]_')"
    export "$varname=$pdkpath"

    # Magic: tech / rc file
    if [ -f "$pdkpath/libs.tech/magic/${pdkname}.magicrc" ]; then
        export MAGIC_MAGICRC="$pdkpath/libs.tech/magic/${pdkname}.magicrc"
    fi

    # Netgen: LVS setup
    if [ -f "$pdkpath/libs.tech/netgen/${pdkname}_setup.tcl" ]; then
        export NETGEN_SETUP="$pdkpath/libs.tech/netgen/${pdkname}_setup.tcl"
    fi

    # xschem: PDK libraries + rc (prepend so PDK libs win over any system libs)
    if [ -d "$pdkpath/libs.tech/xschem" ]; then
        if [ -z "$XSCHEM_LIBRARY_PATH" ]; then
            export XSCHEM_LIBRARY_PATH="$pdkpath/libs.tech/xschem"
        else
            export XSCHEM_LIBRARY_PATH="$pdkpath/libs.tech/xschem:$XSCHEM_LIBRARY_PATH"
        fi

        if [ -f "$pdkpath/libs.tech/xschem/xschemrc" ]; then
            export XSCHEM_RC="$pdkpath/libs.tech/xschem/xschemrc"
        fi
    fi
    return 0
}

if [ -n "$PDK_ROOT" ]; then
    if _select_pdk "$PDK_PREFERENCE"; then
        :   # picked $PDK_PREFERENCE
    elif [ "$PDK_PREFERENCE" != "gf180mcuD" ] && _select_pdk "gf180mcuD"; then
        echo "NOTE: $PDK_PREFERENCE not installed; falling back to gf180mcuD."
    elif _select_pdk "sky130A"; then
        if [ "$PDK_PREFERENCE" != "sky130A" ]; then
            echo "NOTE: $PDK_PREFERENCE not installed; falling back to sky130A."
        fi
    else
        echo "WARNING: Neither gf180mcuD nor sky130A found under $PDK_ROOT"
        echo "         Looked for: $PDK_ROOT/$PDK_PREFERENCE, $PDK_ROOT/gf180mcuD, $PDK_ROOT/sky130A"
    fi
fi

unset -f _select_pdk

# -------------------------------------------------------------------
# Convenience: show what we just did
# -------------------------------------------------------------------
echo "OpenCircuitDesign environment set:"
echo "  OPEN_CIRCUITDESIGN_ROOT = $OPEN_CIRCUITDESIGN_ROOT"
echo "  PATH                    = $OPEN_CIRCUITDESIGN_ROOT/bin:..."
echo "  LD_LIBRARY_PATH         = ${LD_LIBRARY_PATH:-<not set>}"
echo "  PDK_ROOT                = ${PDK_ROOT:-<not set>}"
echo "  PDK                     = ${PDK:-<not selected>}"

command -v magic   >/dev/null 2>&1 && echo "  magic   found:   $(command -v magic)"
command -v netgen  >/dev/null 2>&1 && echo "  netgen  found:   $(command -v netgen)"
command -v ngspice >/dev/null 2>&1 && echo "  ngspice found:   $(command -v ngspice)"
command -v xschem  >/dev/null 2>&1 && echo "  xschem  found:   $(command -v xschem)"

[ -n "$MAGIC_MAGICRC" ]              && echo "  MAGIC_MAGICRC              = $MAGIC_MAGICRC"
[ -n "$NETGEN_SETUP" ]               && echo "  NETGEN_SETUP               = $NETGEN_SETUP"
[ -n "$XSCHEM_SYSTEM_LIBRARY_PATH" ] && echo "  XSCHEM_SYSTEM_LIBRARY_PATH = $XSCHEM_SYSTEM_LIBRARY_PATH"
[ -n "$XSCHEM_LIBRARY_PATH" ]        && echo "  XSCHEM_LIBRARY_PATH        = $XSCHEM_LIBRARY_PATH"
[ -n "$XSCHEM_RC" ]                  && echo "  XSCHEM_RC                  = $XSCHEM_RC"
