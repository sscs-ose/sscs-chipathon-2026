#!/bin/bash

# This script patches the gf180 pdk to have the updated set of scripts
#

# Create temporary directory
TMP_DIR="$(mktemp -d)"
echo "Using temporary directory: ${TMP_DIR}"

cleanup() {
    rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

# Allow write in drc folder (required for spice translation)
#chmod 777 "${DEST_DRC}"

REPO_PR="https://github.com/LuighiV/globalfoundries-pdk-libs-gf180mcu_fd_pr.git"
COMMIT_PR="a263527893d34f0ea6b533508fbc878df54561ef"

DEST_PR="/foss/pdks/gf180mcuD/libs.tech/klayout/tech/scripts"

SRC_PR="${TMP_DIR}/repo_pr/cells/klayout/scripts"

# Clone PR repository
git clone "${REPO_PR}" "${TMP_DIR}/repo_pr"
pushd "${TMP_DIR}/repo_pr"
git checkout ${COMMIT_PR}
popd

rm -rf "${DEST_PR}"

cp -r "${SRC_PR}" "${DEST_PR}"
#cp "${TMP_DIR}/repo_pr/tech/klayout/gf180mcu.lyp" "/foss/pdks/gf180mcuD/libs.tech/klayout/tech"
