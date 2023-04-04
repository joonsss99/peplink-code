#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

DST_DIR="${abspath}/${MNT}/usr/lib"
mkdir -p "${DST_DIR}" || exit $?
cp -dpf ${FETCHEDDIR}/.libs/libxml2.so* "${DST_DIR}/" || exit $?
${HOST_PREFIX}-strip ${DST_DIR}/libxml2.so* || exit $?

if [ "${BLD_CONFIG_KVM}" = "y" ]; then
	install -s --strip-program="${HOST_PREFIX}-strip" \
		-D -t "${abspath}/${MNT}/usr/bin" \
		${FETCHEDDIR}/.libs/xmllint \
		|| exit $?
fi
