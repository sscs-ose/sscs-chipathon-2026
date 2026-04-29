#!/usr/bin/env bash
# Convenience wrapper for the native (nix-shell) build path.
#
# Full walkthrough in docs/reproducing-native.md. This script just
# chains the three commands so you can type one thing:
#
#   scripts/run_native.sh
#
# It does NOT install Nix for you. Install it first:
#
#   curl -L https://nixos.org/nix/install | sh
#   mkdir -p ~/.config/nix
#   echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
#
# and accept the Fossi-Foundation binary cache when prompted on the
# first nix-shell entry (cuts the first build from hours to minutes).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_ROOT}"

if ! command -v nix-shell >/dev/null 2>&1; then
    echo "nix-shell not found in PATH." >&2
    echo "See docs/reproducing-native.md for Nix install instructions." >&2
    exit 1
fi

SLOT="${SLOT:-workshop}"

echo "chipathon-2026-gf180mcu-padring - native build"
echo "----------------------------------------------"
echo "Repo: ${REPO_ROOT}"
echo "Slot: ${SLOT}"
echo

echo "[1/2] make clone-pdk (wafer-space/gf180mcu @ 1.8.0)"
nix-shell --run "make clone-pdk"

echo "[2/2] SLOT=${SLOT} make librelane (~2h 15m on a modern laptop)"
nix-shell --run "SLOT=${SLOT} make librelane"

echo
echo "Done. Artifacts in final/. Inspect with:"
echo "  nix-shell --run 'make librelane-klayout'"
echo "  nix-shell --run 'make librelane-openroad'"
