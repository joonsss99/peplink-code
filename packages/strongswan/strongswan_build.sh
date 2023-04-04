#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR || exit $?

if [ ! -f ./configure ]; then
	./autogen.sh || exit $?
fi

if [ ! -f ./Makefile ]; then
       if [ "${BLD_CONFIG_CRYPTO_FIPS_COCO_FIRMWARE}" = "y" ]; then
               CONFIGURE_EXTRA="--enable-openssl --with-fips-mode=0"
               CFLAGS_EXTRA="-DOPENSSL_FIPS=1"
       fi
       if [ "${BLD_CONFIG_FHVM}" = "y" ]; then
	       CFLAGS_FHVM="-DCONFIG_FUSIONHUB_BUILD"
       fi
       CPPFLAGS="-I${STAGING}/usr/include" \
		./configure \
		--prefix="" \
		--libexecdir="/usr/libexec" \
		--libdir="/usr/lib" \
		--includedir="${STAGING}/usr/include" \
		--host=$HOST_PREFIX \
		--enable-static=no \
		--enable-monolithic \
		--enable-openssl \
		--disable-attr \
		--disable-cmac \
		--disable-constraints \
		--disable-dnskey \
		--disable-fips-prf \
		--disable-pgp \
		--disable-pki \
		--disable-pubkey \
		--disable-rc2 \
		--disable-resolve \
		--disable-revocation \
		--with-routing-table=154 \
		--with-routing-table-prio=32999 \
		--disable-scepclient \
		--disable-sshkey \
		--disable-swanctl \
		--disable-vici \
		--disable-xauth-generic \
		--disable-xcbc \
		--without-lib-prefix \
		--disable-gmp \
		${CONFIGURE_EXTRA} \
		CFLAGS="-I${STAGING}/usr/include ${CFLAGS_EXTRA} ${CFLAGS_FHVM}" \
		LDFLAGS="-L${STAGING}/usr/lib" LIBS="-lcrypto" \
		|| exit $?
fi

make $MAKE_OPTS || exit $?

make DESTDIR=${abspath}/${FETCHEDDIR}/build install || exit $?
