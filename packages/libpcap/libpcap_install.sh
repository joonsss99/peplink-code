#!/bin/sh

set -e

PACKAGE=$1
FETCHEDDIR=${FETCHDIR}/${PACKAGE}
abspath=`pwd`

cd ${FETCHEDDIR}
make install-shared DESTDIR=${abspath}/${MNT}
${HOST_PREFIX}-strip --strip-all $abspath/$MNT/usr/lib/libpcap.*
