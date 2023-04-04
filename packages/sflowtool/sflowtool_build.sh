#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

# Install headers to the staging
install_headers()
{
	cp -rf src/include/sflowtool ${STAGING}/usr/include
}

cd ${FETCHEDDIR}

# Check if it is building demo web.
# If yes, just install the necessary header files.
if [ "$TARGET_SERIES" = "native" ]; then
	install_headers
	exit
fi

if [ ! -f configure ]; then
	autoreconf -vis || exit $?
fi

if [ ! -f Makefile ]; then
	CPPFLAGS=-I$STAGING/usr/include \
	LDFLAGS="-L$STAGING/usr/lib -Wl,-rpath-link=$STAGING/usr/lib" \
	LIBS="-lstrutils -ljansson -lpthread -lpepos -lpepinfo -lswitch -lz" \
	./configure --host=${HOST_PREFIX} --prefix=/usr || exit $?
fi

make || exit $?

install_headers
