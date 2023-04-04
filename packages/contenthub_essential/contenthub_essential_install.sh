#!/bin/sh

abspath=`pwd`

#
# Create .cfg file for contenthub_packager
#
CHUB_PKGS_DIR="${abspath}/tmp/contenthub_packages"
ESSENTIAL_NAME="host-essential"
ESSENTIAL_DEST_CFG="${CHUB_PKGS_DIR}/${ESSENTIAL_NAME}.cfg"
ESSENTIAL_VERSION_XYZ="`expr "${FIRMWARE_VERSION}" \
	: '\([0-9]\{1,\}\.[0-9]\{1,2\}\.[0-9]\{1,2\}\)'`"
mkdir -p "${CHUB_PKGS_DIR}"
cat > "${ESSENTIAL_DEST_CFG}" << EOF
NAME="${ESSENTIAL_NAME}"
FULLNAME="ContentHub Essential"
VERSION_NAME="${ESSENTIAL_VERSION_XYZ}"
ENVIRONMENT="PATH:<MOUNTPOINT>/bin:<MOUNTPOINT>/usr/bin"
ENVIRONMENT="LD_LIBRARY_PATH:<MOUNTPOINT>/lib:<MOUNTPOINT>/usr/lib"
EOF
