#!/usr/bin/env python3

# Copyright (c) 2025 Leo Moser <leo.moser@pm.me>
# SPDX-License-Identifier: Apache-2.0

import os
import sys
import yaml
import shutil
import argparse

from typing import List, Type, Tuple

from librelane.common import Path
from librelane.config import Variable
from librelane.state import DesignFormat, State
from librelane.flows.sequential import SequentialFlow
from librelane.steps import (
    KLayout,
    Checker,
    Magic,
    Misc,
    Yosys,
    Verilator,
    OpenROAD,
    Odb,
    Step,
    ViewsUpdate,
    MetricsUpdate,
    StepError,
    StepException,
)
from librelane.steps.klayout import KLayoutStep
from librelane.flows.flow import FlowError


class PadringFlow(SequentialFlow):

    Steps: List[Type[Step]] = [
        Verilator.Lint,
        Checker.LintTimingConstructs,
        Checker.LintErrors,
        Checker.LintWarnings,
        Yosys.JsonHeader,
        Yosys.Synthesis,
        Checker.YosysUnmappedCells,
        Checker.YosysSynthChecks,
        Checker.NetlistAssignStatements,
        OpenROAD.CheckSDCFiles,
        OpenROAD.CheckMacroInstances,
        OpenROAD.STAPrePNR,
        OpenROAD.Floorplan,
        OpenROAD.DumpRCValues,
        Odb.SetPowerConnections,
        OpenROAD.PadRing,
        Odb.CheckMacroAntennaProperties,
        Odb.ManualMacroPlacement,
        KLayout.StreamOut,
        KLayout.SealRing,
    ]


def main(slot_config_path, config_path):

    PDK_ROOT = os.getenv("PDK_ROOT", os.path.expanduser("~/.ciel"))
    PDK = os.getenv("PDK", "gf180mcuD")

    print(f"PDK_ROOT = {PDK_ROOT}")
    print(f"PDK = {PDK}")

    flow_cfg = yaml.safe_load(open(slot_config_path))
    flow_cfg.update(yaml.safe_load(open(config_path)))

    # Run flow
    flow = PadringFlow(
        flow_cfg,
        design_dir=os.path.dirname(config_path),
        pdk_root=PDK_ROOT,
        pdk=PDK,
    )

    try:
        # Start the flow
        flow.start()
    except FlowError as e:
        print(f"Error: \n{e}")
        sys.exit(1)

    print(f"Run successfully completed.")


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("slot", default=".", help="path to slot config")
    parser.add_argument("config", default=".", help="path to config")

    args = parser.parse_args()

    main(args.slot, args.config)
