#!/bin/sh

PACKAGE=$1

abspath=`pwd`
CHUB_PKGS_DIR="${abspath}/tmp/contenthub_packages"
ESSENTIAL_NAME="host-essential"
ESSENTIAL_DEST_CFG="${CHUB_PKGS_DIR}/${ESSENTIAL_NAME}.cfg"
ESSENTIAL_DEST_DIR="${CHUB_PKGS_DIR}/libraries/${ESSENTIAL_NAME}"

rm -rf "${ESSENTIAL_DEST_CFG}" "${ESSENTIAL_DEST_DIR}"
