#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

cd ${FETCHEDDIR} || exit $?

if [ ! -f Makefile ]; then
	CFLAGS="-I${STAGING}/usr/include" \
	CPPFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	./configure \
		--host=${HOST_PREFIX} --build=${BUILD_PREFIX} \
		--prefix="/usr" \
		--disable-static \
		--with-curses \
		|| exit $?
fi
make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?
