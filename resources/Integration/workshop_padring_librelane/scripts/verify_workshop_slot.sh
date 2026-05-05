#!/usr/bin/env bash
# Pragmatic end-to-end verification for the chipathon-2026 workshop slot.
#
# We do not re-run LibreLane or DRC here. Instead we byte-compare the six
# tracked files that define the workshop slot against a known-good
# reference tree that was validated DRC/LVS/antenna/STA-clean on
# 2026-04-23. If the six files match, a fresh build on a compatible
# host reproduces the reference result.
#
# Usage:
#   scripts/verify_workshop_slot.sh [REF_TEMPLATE_DIR]
#
# REF_TEMPLATE_DIR defaults to ~/eda/designs/chipathon_padring/template.
# If the reference tree is unavailable, the script still checks that
# the six tracked files exist and are non-empty inside this fork.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REF_DEFAULT="${HOME}/eda/designs/chipathon_padring/template"
REF="${1:-${REF_DEFAULT}}"

FILES=(
    Makefile
    src/chip_core.sv
    src/slot_defines.svh
    librelane/config.yaml
    librelane/pdn_cfg.tcl
    librelane/slots/slot_workshop.yaml
)

echo "chipathon-2026 workshop slot - verification"
echo "-------------------------------------------"
echo "Fork:      ${REPO_ROOT}"
echo "Reference: ${REF}"
echo

# Phase 1 - fork self-check.
echo "[phase 1] fork self-check (files exist and are non-empty)"
fork_fail=0
for f in "${FILES[@]}"; do
    path="${REPO_ROOT}/${f}"
    if [[ ! -s "${path}" ]]; then
        echo "  FAIL ${f} (missing or empty)"
        fork_fail=$((fork_fail + 1))
    else
        size=$(wc -c < "${path}")
        printf "  OK   %-40s %s bytes\n" "${f}" "${size}"
    fi
done

if (( fork_fail > 0 )); then
    echo
    echo "Fork self-check failed (${fork_fail} file(s) missing or empty)."
    echo "This repository is broken - do not proceed."
    exit 2
fi
echo

# Phase 2 - byte-compare against the reference tree (if available).
if [[ ! -d "${REF}" ]]; then
    echo "[phase 2] skipped (reference tree not found at ${REF})"
    echo
    echo "The fork self-check passed. To run the full comparison, pass the"
    echo "path to a known-good reference template as the first argument."
    exit 0
fi

echo "[phase 2] byte-compare against reference tree"
cmp_fail=0
for f in "${FILES[@]}"; do
    a="${REPO_ROOT}/${f}"
    b="${REF}/${f}"
    if [[ ! -f "${b}" ]]; then
        echo "  FAIL ${f} (reference file missing: ${b})"
        cmp_fail=$((cmp_fail + 1))
        continue
    fi
    if cmp -s "${a}" "${b}"; then
        printf "  OK   %-40s match\n" "${f}"
    else
        echo "  FAIL ${f} differs against reference"
        diff -u "${b}" "${a}" | head -40 || true
        cmp_fail=$((cmp_fail + 1))
    fi
done

echo
if (( cmp_fail > 0 )); then
    echo "Verification FAILED: ${cmp_fail} file(s) diverge from the reference."
    exit 1
fi

echo "Verification PASSED: all six tracked files match the reference."
echo "The reference tree built DRC/LVS/antenna/STA-clean on 2026-04-23,"
echo "so this fork is expected to produce the same result on a compatible"
echo "host (LibreLane 3.0.0 + wafer-space PDK 1.8.0 via nix-shell)."
