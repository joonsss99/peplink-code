#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

make -C ${FETCHEDDIR} $MAKE_OPTS DESTDIR=${abspath}/${MNT} install || exit 1
${HOST_PREFIX}-strip ${abspath}/${MNT}/usr/sbin/ifmetric
if [ -f ${abspath}/${MNT}/usr/man/man8/ifmetric.8 ]; then
	rm -f ${abspath}/${MNT}/usr/man/man8/ifmetric.8
	find ${abspath}/${MNT}/usr/man/ -type d -empty -delete
fi
