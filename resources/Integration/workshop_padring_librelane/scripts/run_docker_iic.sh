#!/usr/bin/env bash
# Launch hpretl/iic-osic-tools with this repo mounted at /workspace.
#
# Primary use case is interactive inspection of a pre-built GDS
# (KLayout, Magic, Netgen). The reference build path is Nix
# (`docs/reproducing-native.md`); see `docs/reproducing-docker.md` for
# why the container is not recommended for signoff-grade runs.
#
# Usage:
#   scripts/run_docker_iic.sh                         # interactive shell
#   scripts/run_docker_iic.sh klayout final/.../gds   # one-shot command
#
# Environment knobs:
#   IIC_IMAGE   - Docker image tag (default: hpretl/iic-osic-tools:latest)
#   DISPLAY     - host X display (inherited; required for GUI tools)
#   EXTRA_VOLS  - extra --volume args to pass through

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="${IIC_IMAGE:-hpretl/iic-osic-tools:latest}"

if ! command -v docker >/dev/null 2>&1; then
    echo "docker not found in PATH" >&2
    exit 1
fi

# Enable X11 forwarding if DISPLAY is set. Docker needs to see the host
# Xauthority to talk to the session display; use 'xhost +local:' or the
# docker-specific DISPLAY=:0 setup as appropriate.
X11_ARGS=()
if [[ -n "${DISPLAY:-}" ]]; then
    X11_ARGS+=(-e "DISPLAY=${DISPLAY}")
    if [[ -S /tmp/.X11-unix ]]; then
        X11_ARGS+=(-v /tmp/.X11-unix:/tmp/.X11-unix:rw)
    fi
    if [[ -n "${XAUTHORITY:-}" && -f "${XAUTHORITY}" ]]; then
        X11_ARGS+=(-v "${XAUTHORITY}:/tmp/.Xauthority:ro" -e XAUTHORITY=/tmp/.Xauthority)
    fi
fi

EXTRA_VOL_ARGS=()
if [[ -n "${EXTRA_VOLS:-}" ]]; then
    # shellcheck disable=SC2086
    EXTRA_VOL_ARGS=(${EXTRA_VOLS})
fi

set -x
docker run --rm -it \
    --name chipathon-2026-iic \
    --user "$(id -u):$(id -g)" \
    -v "${REPO_ROOT}:/workspace" \
    -w /workspace \
    "${X11_ARGS[@]}" \
    "${EXTRA_VOL_ARGS[@]}" \
    "${IMAGE}" \
    "$@"
