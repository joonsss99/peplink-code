#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

# we don't use make install as it will copy the conf/ files
# which we have separate project to handle the configs now
DESTDIR=${abspath}/${MNT}/usr/sbin

mkdir -p ${DESTDIR}
cp -f $FETCHEDDIR/objs/nginx ${DESTDIR}/
$HOST_PREFIX-strip ${DESTDIR}/nginx

MNTDIR=${abspath}/${MNT}
mkdir -p ${MNTDIR}/etc/nginx
mkdir -p ${MNTDIR}/var/run
mkdir -p ${MNTDIR}/var/log/nginx
