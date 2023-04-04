#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

STRIP=$HOST_PREFIX-strip

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd ${FETCHEDDIR} || exit $?
if [ ! -x configure ]; then
	autoreconf -ivf || exit $?
fi
if [ ! -f Makefile ] ; then
	ac_cv_file__dev_random=yes \
		./configure --host=$HOST_PREFIX --enable-dhcpv6 || exit $?
fi
make $MAKE_OPTS || exit $?
mkdir -p build/sbin || exit $?
cp -pf client/dhclient build/sbin || exit $?
${STRIP} build/sbin/dhclient || exit $?
