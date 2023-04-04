#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

if [ -f ${FETCHEDDIR}/libnet/Makefile ]; then
	make -C ${FETCHEDDIR}/libnet distclean
fi
rm -f ${FETCHEDDIR}/libnet/configure
