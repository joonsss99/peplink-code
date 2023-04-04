#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

# FIXME should never copy from staging when installing...
DST_DIR=${abspath}/${MNT}/usr/lib
mkdir -p "${DST_DIR}" || exit $?
for i in libgio-2.0 \
	libglib-2.0 \
	libgmodule-2.0 \
	libgobject-2.0 \
	libgthread-2.0 \
; do
	cp -dpf ${STAGING}/usr/lib/$i.so* ${DST_DIR}/ || exit $?
	${HOST_PREFIX}-strip ${DST_DIR}/$i.so* || exit $?
done
