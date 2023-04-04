#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

if [ ! -f $KERNEL_OBJ/.config ]; then
	echo "${PACKAGE}: kernel .config file is missing"
	exit 1
fi

abspath=`pwd`
FIRMWARE_INSTALL_DIR="$abspath/$MNT/lib/firmware/"
FIRMWARE_HOTPLUG_DIR="$abspath/$MNT/etc/hotplug.d/firmware/"
#We have AK (Akronite IPQ806x), HK (Hawkeye IPQ807x) and CP (Cypress IPQ60xx) firmwares
HW="IPQ8074 IPQ6018"
#We have R (Retail) and E (Enterprise) firmware builds
#Using Enterprise fw build for now
FW=E
#Read fetched/qca-nss-firmware/README.md for details

cd ${FETCHEDDIR} || exit $?

for h in $HW; do
	install -D -t "${FIRMWARE_INSTALL_DIR}/$h" \
		BIN-NSS.$h/$FW/qca-nss*.bin \
		|| exit $?
	install -D -t "${FIRMWARE_INSTALL_DIR}/$h" \
		BIN-EIP197.$h/*.bin \
		|| exit $?
done


install -D -t "${FIRMWARE_HOTPLUG_DIR}" \
		etc/hotplug.d/01-qca-nss-bin \
		|| exit $?

install -D -t "${FIRMWARE_HOTPLUG_DIR}" \
		etc/hotplug.d/02-qca-eip197-bin \
		|| exit $?
