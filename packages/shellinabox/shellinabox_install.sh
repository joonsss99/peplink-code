#!/bin/sh

PACKAGE=$1
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

mkdir -p ${MNT}/usr/local/ilink/bin || exit $?
install -s --strip-program=${HOST_PREFIX}-strip \
	${FETCHEDDIR}/shellinaboxd ${MNT}/usr/local/ilink/bin || exit $?
