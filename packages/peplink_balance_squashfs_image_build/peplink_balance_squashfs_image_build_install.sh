#!/bin/sh

PACKAGE=$1

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

RDISKIMAGE=${abspath}/images/rdisk.sfs
LIB_PATH=${abspath}/tmp/usr/local/lib
MKSQUASHFS_EXE=$HOST_TOOL_DIR/bin/mksquashfs

rm -f ${RDISKIMAGE}

if [ "$BLD_CONFIG_USE_SQUASHFS4" = "y" ]; then
	LD_LIBRARY_PATH=${LIB_PATH} ${MKSQUASHFS_EXE} ${abspath}/${MNT} ${RDISKIMAGE} -comp "xz" -noappend -all-root || exit $?
else
	$FAKEROOT_CMD ${MKSQUASHFS_EXE}-lzma ${abspath}/${MNT} ${RDISKIMAGE} -noappend -be -all-root || exit $?
fi
ln -sf ${RDISKIMAGE} ${abspath}/images/rdisk.gz

fakeroot_session_end

