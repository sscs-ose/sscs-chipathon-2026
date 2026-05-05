#!/usr/bin/env bash
# Quick sanity check of the host + container before running any
# notebook. Read-only; does not modify state.

set -uo pipefail

CONTAINER_NAME="${CONTAINER_NAME:-gf180}"
HOST_WS="${HOST_WS:-$HOME/eda/designs}"

pass=0
fail=0

check() {
    local label="$1"; shift
    if "$@" >/dev/null 2>&1; then
        printf '  OK   %s\n' "${label}"
        pass=$((pass+1))
    else
        printf '  FAIL %s\n' "${label}"
        fail=$((fail+1))
    fi
}

echo "Host"
check "docker command available"                          command -v docker
check "host workspace exists (${HOST_WS})"                test -d "${HOST_WS}"
check "python3 >= 3.9"                                    bash -c 'python3 -c "import sys; sys.exit(0 if sys.version_info>=(3,9) else 1)"'
check "jupyter available (notebook or lab)"               bash -c 'command -v jupyter-lab || command -v jupyter'

echo
echo "Container"
check "container ${CONTAINER_NAME} exists"                docker ps -a --filter "name=^${CONTAINER_NAME}$" --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"
check "container ${CONTAINER_NAME} running"               docker ps    --filter "name=^${CONTAINER_NAME}$" --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"
check "workspace bind-mounted inside container"           docker exec "${CONTAINER_NAME}" bash -lc 'test -d /foss/designs'
check "sak-pdk-script.sh available inside container"      docker exec "${CONTAINER_NAME}" bash -lc 'command -v sak-pdk-script.sh'
check "LibreLane available inside container"              docker exec "${CONTAINER_NAME}" bash -lc 'command -v librelane'
check "cocotb-config available inside container"          docker exec "${CONTAINER_NAME}" bash -lc 'command -v cocotb-config'
check "iverilog available inside container"               docker exec "${CONTAINER_NAME}" bash -lc 'command -v iverilog'
check "gf180mcuD PDK installed inside container"          docker exec "${CONTAINER_NAME}" bash -lc 'test -d /foss/pdks/gf180mcuD'

echo
if (( fail == 0 )); then
    echo "All ${pass} checks passed. You are good to go."
    echo "Open any notebook under examples/ and run top to bottom."
    exit 0
else
    echo "${fail} check(s) failed out of $((pass+fail))."
    echo "Fix the failing items above (see docs/troubleshooting.md)"
    echo "and re-run this script."
    exit 1
fi
