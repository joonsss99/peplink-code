#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/${MNT}/usr/bin

[ ! -f ${FETCHEDDIR}/tcpserver ] && echo "missing binary" && exit 1

mkdir -p ${DESTDIR}
cp -pf ${FETCHEDDIR}/tcpserver ${DESTDIR}/

[ ! -f ${FETCHEDDIR}/tcpclient ] && echo "missing binary" && exit 1

cp -pf ${FETCHEDDIR}/tcpclient ${DESTDIR}/

