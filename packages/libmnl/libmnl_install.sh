#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C ${FETCHEDDIR} $MAKE_OPTS DESTDIR=${abspath}/${MNT} install-strip || exit $?
rm -f ${abspath}/${MNT}/usr/lib/libmnl.la
rm -f ${abspath}/${MNT}/usr/lib/pkgconfig/libmnl.pc
rm -f ${abspath}/${MNT}/usr/include/libmnl/libmnl.h
rmdir ${abspath}/${MNT}/usr/include/libmnl
