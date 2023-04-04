#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

[ -f "${FETCHEDDIR}/Makefile" ] && make -C "${FETCHEDDIR}" distclean

rm -rf "${FETCHEDDIR}/config.site" \
	tmp/contenthub_packages/python tmp/contenthub_packages/python.cfg
