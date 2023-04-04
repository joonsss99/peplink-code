#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#
# run all the make install first
#

cd $FETCHEDDIR || exit $?

TARGET_LIB=$abspath/$MNT/lib
TARGET_LOCAL=$abspath/$MNT/usr/bin

cat > target.cfg << GENERATE_TARGET_CFG_EOL
# That file will be included in the Makefiles to configure where to install files on the target
# The directory on the local build file system to which  the files need to be installed
TARGET_LOCAL=$TARGET_LOCAL
GENERATE_TARGET_CFG_EOL

make DESTDIR=$abspath/$MNT CROSS_COMPILE=$HOST_PREFIX- ARCH=$ARCH install || exit $?

#install libloragw.so
install -s --strip-program=${HOST_PREFIX}-strip \
	-D -t "${TARGET_LIB}" \
	libloragw/libloragw.so \
	|| exit $?

#Remove unused stuff
for f in test_loragw_* net_downlink reset_lgw.sh; do
	rm -f $TARGET_LOCAL/$f
done
#Strip binaries
for f in lora_pkt_fwd chip_id spectral_scan; do
	$HOST_PREFIX-strip --remove-section=.note --remove-section=.comment $TARGET_LOCAL/$f || exit $?
done
