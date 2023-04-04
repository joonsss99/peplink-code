#!/bin/sh

PACKAGE=$1

ABSPATH=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}
TCLDIR=${ABSPATH}/${FETCHDIR}/tcl/unix

EXPATINCDIR=${STAGING}/usr/include
EXPATLIBDIR=${STAGING}/usr/lib

PCREINCDIR=${ABSPATH}/${FETCHDIR}/pcre
PCRELIBDIR=${ABSPATH}/${FETCHDIR}/pcre/.libs

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -f configure ]; then
	autoreconf -f -i -Wall,no-obsolete || exit $?
fi

# Add below options to allow traffer_server process running as root.root
#   CPPFLAGS=-DBIG_SECURITY_HOLE
#   --with-user=root --with-group=root
if [ ! -f Makefile ]; then
	CPPFLAGS="-I${STAGING}/usr/include -DBIG_SECURITY_HOLE" \
		LDFLAGS="-L${STAGING}/usr/lib" \
		./configure --host=${HOST_PREFIX} \
		--enable-layout=MediaFast \
		--enable-reclaimable-freelist \
		--with-user=root --with-group=root \
		--with-tcl="${TCLDIR}" \
		--with-openssl="${STAGING}/usr" \
		--with-xml=expat --with-expat="${EXPATINCDIR}:${EXPATLIBDIR}" \
		--with-pcre="${PCREINCDIR}:${PCRELIBDIR}" || exit $?
fi

make ${MAKE_OPTS} CC=$HOST_PREFIX-gcc || exit $?
