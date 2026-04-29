#!/usr/bin/env bash
# One-time bootstrap for the `gf180` Docker container.
# Every notebook in examples/ shells into this container via docker exec.
#
# What it does:
#   1. Pull hpretl/iic-osic-tools:chipathon26 (~18 GB, one time).
#      `:chipathon26` is the chipathon-2026 stability-pinned IIC-OSIC-TOOLS
#      image and ships LibreLane v3.0.2. Override with
#      IIC_IMAGE=hpretl/iic-osic-tools:next if you want the rolling
#      next-tagged image instead. NB: the older `:chipathon` tag (no
#      year suffix) ships OpenLane 2.3.11 and will NOT run these
#      LibreLane-based notebooks; do not use it.
#   2. Create the host workspace ~/eda/designs/ if missing.
#   3. Start a long-running container named `gf180` with the workspace
#      bind-mounted at /foss/designs and the current user UID/GID.
#
# Idempotent. Re-running with the container already up is a no-op.

set -euo pipefail

IMAGE="${IIC_IMAGE:-hpretl/iic-osic-tools:chipathon26}"
CONTAINER_NAME="${CONTAINER_NAME:-gf180}"
HOST_WS="${HOST_WS:-$HOME/eda/designs}"
CONTAINER_WS="/foss/designs"

if ! command -v docker >/dev/null 2>&1; then
    echo "docker not found in PATH. Install Docker Engine first." >&2
    exit 1
fi

echo "[1/3] Ensuring image ${IMAGE} is present"
if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
    echo "      pulling (this is ~15 GB on first run)..."
    docker pull "${IMAGE}"
else
    echo "      image already pulled"
fi

echo "[2/3] Host workspace at ${HOST_WS}"
mkdir -p "${HOST_WS}"

echo "[3/3] Container ${CONTAINER_NAME}"
existing=$(docker ps -a --filter "name=^${CONTAINER_NAME}$" --format '{{.Names}} {{.Status}}' || true)
running=$(docker ps    --filter "name=^${CONTAINER_NAME}$" --format '{{.Names}}' || true)

if [[ "${running}" == "${CONTAINER_NAME}" ]]; then
    echo "      already running -> nothing to do"
elif [[ -n "${existing}" ]]; then
    echo "      exists but stopped (${existing}); starting"
    docker start "${CONTAINER_NAME}" >/dev/null
else
    echo "      creating and starting"
    docker run -d --name "${CONTAINER_NAME}" \
        -v "${HOST_WS}:${CONTAINER_WS}:rw" \
        --user "$(id -u):$(id -g)" \
        "${IMAGE}" \
        --skip sleep infinity >/dev/null
fi

echo
echo "Bootstrap complete. Verify with:"
echo "  scripts/verify_prereqs.sh"
echo
echo "Commands inside the container:"
echo "  docker exec -it ${CONTAINER_NAME} bash"
