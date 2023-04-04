#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "$TARGET_SERIES" = "native" ]; then
	exit 0
fi
rm -f ${abspath}/${MNT}/usr/local/ilink/lib/*.o
make -C ${FETCHEDDIR} CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT PREFIX=/usr/local/ilink install || exit $?
if [ "$BLD_CONFIG_PREBUILT_EXPORT" = "y" ] ; then
	# export staging files
	make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX $MAKE_OPTS DESTDIR=$TOP_PREBUILT_EX/$PACKAGE/staging PREFIX=/usr install-dev || exit $?
	# export install files
	create_prebuilt_install_dir $TOP_PREBUILT_EX/$PACKAGE/tmp/mnt
	make -C ${FETCHEDDIR} CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$TOP_PREBUILT_EX/$PACKAGE/tmp/mnt PREFIX=/usr/local/ilink install || exit $?
	# package tarball
	create_prebuilt_tarball $PACKAGE || exit $?
fi
