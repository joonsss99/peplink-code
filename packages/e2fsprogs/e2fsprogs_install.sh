#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

E_BIN=${FETCHEDDIR}/e2fsck/e2fsck
BLKID_BIN=${FETCHEDDIR}/misc/blkid
MKE2FS_BIN=${FETCHEDDIR}/misc/mke2fs
RESIZEFS_BIN=${FETCHEDDIR}/resize/resize2fs

if [ ! -f ${E_BIN} ]; then
	echo "missing binary"
	exit 1
fi

sbin_utils="${E_BIN} ${BLKID_BIN}" # [Bug#18159] reverted Bug#18098 rev. 19490

if [ "${HAS_STORAGE_MGMT_TOOLS}" = "y" ]; then
	sbin_utils+=" ${MKE2FS_BIN}"
fi

if [ "$BLD_CONFIG_RESIZE_FS" = "y" ]; then
	sbin_utils+=" ${RESIZEFS_BIN}"
fi

for p in ${sbin_utils}; do
	cp -pf ${p} ${abspath}/${MNT}/sbin/ || exit 1
	$HOST_PREFIX-strip ${abspath}/${MNT}/sbin/`basename ${p}`
done
