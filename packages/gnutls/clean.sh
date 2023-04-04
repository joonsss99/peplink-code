#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

#
# nettle
#

NETTLEDIR=${FETCHEDDIR}/devel/nettle
if [ -f ${NETTLEDIR}/Makefile ]; then
	make -C ${NETTLEDIR} distclean
fi
rm -f ${NETTLEDIR}/configure

#
# gnutls
#

if [ -f ${FETCHEDDIR}/Makefile ]; then
	make -C ${FETCHEDDIR} distclean
fi
rm -f ${FETCHEDDIR}/configure
