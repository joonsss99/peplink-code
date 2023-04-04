#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

#
# nettle
#

cd ${FETCHEDDIR}/devel/nettle || exit $?

DEST_LIB_DIR="${abspath}/${MNT}/usr/lib"
mkdir -p "${DEST_LIB_DIR}" || exit $?
for i in libnettle.so libhogweed.so; do
	cp -dpf "${STAGING}/usr/lib/${i}"* "${DEST_LIB_DIR}/" || exit $?
	${HOST_PREFIX}-strip "${DEST_LIB_DIR}/${i}"* || exit $?
done

cd - || exit $?

#
# gnutls
#

cd ${FETCHEDDIR} || exit $?

DEST_LIB_DIR="${abspath}/${MNT}/usr/lib"
mkdir -p "${DEST_LIB_DIR}" || exit $?
cp -dpf lib/.libs/libgnutls*.so* "${DEST_LIB_DIR}/" || exit $?
rm -f "${DEST_LIB_DIR}/libgnutls"*T
${HOST_PREFIX}-strip "${DEST_LIB_DIR}/libgnutls"* || exit $?
