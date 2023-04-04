#!/bin/sh

PACKAGE=$1
FETCHEDDIR=$FETCHDIR/$PACKAGE

. ./make.conf

cd $FETCHEDDIR || exit $?

if [ ! -f configure ]; then
	autoreconf -vif || exit $?
fi

if [ ! -f Makefile ] ; then
	# [Bug#22533] SSL is no longer be needed, but it won't compile when
	#   configured with the option --disable-ssl
	FLAGS="-I$STAGING/usr/include"
	if [ "${BLD_CONFIG_MEDIAFAST_DOCKER}" = "y" ]; then
		FLAGS="-I$STAGING/usr/include -DPISMO_DOCKER_SUPPORT"
	fi
	CFLAGS="${FLAGS}" CPPFLAGS="${FLAGS}" \
	LDFLAGS="-L$STAGING/usr/lib" \
	./configure --host=${HOST_PREFIX} CC=$HOST_PREFIX-gcc \
		--disable-login \
		--disable-pam \
		--disable-runtime-loading \
		--disable-utmp \
		|| exit $?
fi

make $MAKE_OPTS || exit $?
