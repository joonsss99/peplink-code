#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

[ ! -f "${FETCHEDDIR}/Makefile" ] || make -C "${FETCHEDDIR}" distclean || exit $?

rm -rf tmp/contenthub_packages/libraries/ruby tmp/contenthub_packages/ruby.cfg
