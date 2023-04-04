#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

if [ ! -f ${FETCHEDDIR}/Makefile ]; then
	cd ${FETCHEDDIR}
	CONFIG_SITE=config.site ./configure \
		${CONFIGURE_PREFIX_OPT} \
		--prefix=/usr \
		--disable-ipv6 || exit $?
	cd ${abspath}
fi

# For building on system without Python installed
#   See https://bugs.python.org/issue21480
make -C "${FETCHEDDIR}" touch
# [Bug#15834] Initially used by cross-compiling Python.
#   Build and install python binary and its modules.
make -C "${FETCHEDDIR}" ${MAKE_OPTS} \
	DESTDIR="${HOST_TOOL_DIR}/python" \
	install || exit $?
