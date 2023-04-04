#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f Makefile ]; then
	# --without-ensurepip for building on build system without libffi-dev
	#   See https://bugs.python.org/issue31652
	CONFIG_SITE=config.site ./configure \
		--without-ensurepip \
		--prefix=/usr \
		--disable-ipv6 || exit $?
fi
make ${MAKE_OPTS} DESTDIR="${HOST_TOOL_DIR}/python3" install || exit $?
