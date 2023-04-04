#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

if [ -f ${FETCHEDDIR}/GNUmakefile -a -f ${STAGING}/usr/lib/libevent.so ]; then
	make -C ${FETCHEDDIR} LIBEVENT_BASE=${STAGING}/usr clean distclean
fi
