#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C ${FETCHEDDIR}/src DESTDIR=${abspath}/${MNT} install-strip || exit $?
rm -f ${abspath}/${MNT}/usr/share/man/man8/ipset.8
