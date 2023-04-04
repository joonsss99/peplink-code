#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

cd $FETCHEDDIR/source3 || exit $?

if [ ! -f configure ] ; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ] ; then
	CFLAGS="-Os -fPIC -I$STAGING/usr/include" LDFLAGS="-L$STAGING/usr/lib" LIBS="-lz -lldap -llber -lssl -lcrypto -lkrb5 -lcom_err -lkrb5support -lk5crypto" ./configure \
		--prefix=/var/run/samba \
		--localstatedir=/var/run/samba \
		--with-configdir=/etc/samba \
		--enable-shared-libs \
		--with-libaddns \
		--with-ldap \
		--with-ads \
		--with-winbind \
		--with-libiconv=`${HOST_PREFIX}-gcc -print-sysroot`/usr \
		--with-krb5=../../kerberos/src/ \
		--cache-file=cross.cache \
		--disable-smbtorture4 \
		--disable-cups \
		--disable-fam \
		--disable-avahi \
		--without-dmapi \
		--without-automount \
		--without-pam \
		--without-sys-quotas \
		--without-cluster-support \
		--without-acl-support \
		--without-readline \
		ac_cv_header_ifaddrs_h=${ac_cv_header_ifaddrs_h=no} \
		libreplace_cv_HAVE_GETIFADDRS=${libreplace_cv_HAVE_GETIFADDRS=no} \
		PKG_CONFIG=/tmp/tmp \
		--host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS CC=$HOST_PREFIX-gcc all || exit $?
