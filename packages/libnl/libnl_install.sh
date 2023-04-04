#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`
DST_DIR="${abspath}/${MNT}/usr/lib"

mkdir -p "${DST_DIR}" || exit $?

cd ${FETCHEDDIR}/lib/.libs || exit $?

for i in libnl-3.so* libnl-genl-3.so* libnl-route-3.so*; do
	case "$i" in
	*T)	continue ;;
	esac
	cp -dpf "$i" "${DST_DIR}/" || exit $?
	if [ ! -L "$i" ]; then
		${HOST_PREFIX}-strip "${DST_DIR}/$i" || exit $?
	fi
done
