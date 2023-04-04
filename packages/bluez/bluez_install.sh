#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

INSTALL_OPTS="-D -m 0755 -s --strip-program=${HOST_PREFIX}-strip"

cd ${FETCHEDDIR} || exit $?

install ${INSTALL_OPTS} -t ${abspath}/${MNT}/usr/lib/ \
	lib/libbluetooth.so || exit $?
install ${INSTALL_OPTS} -t ${abspath}/${MNT}/usr/bin/ \
	tools/hciconfig tools/hcitool || exit $?
