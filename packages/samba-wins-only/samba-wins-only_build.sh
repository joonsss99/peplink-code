#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd $FETCHEDDIR/source3

if [ ! -f configure ] ; then
	./autogen.sh || exit $?
fi

if [ ! -f Makefile ] ; then
	CFLAGS="-Os -I$STAGING/usr/include" LDFLAGS="-L$STAGING/usr/lib" LIBS="-lz" ./configure \
		--localstatedir=/var/run/samba \
		--disable-cups \
		--disable-iprint \
		--disable-pie \
		--disable-fam \
		--enable-shared-libs \
		--disable-dnssd \
		--disable-avahi \
		--disable-largefile \
		--disable-swat \
		--without-ldap \
		--without-readline \
		--without-dnsupdate \
		--without-pam \
		--without-utmp \
		--without-libnetapi \
		--without-libsmbclient \
		--without-libsmbsharemodes \
		--without-acl-support \
		--without-sendfile-support \
		--without-wbclient \
		--without-winbind \
		--without-ads \
		--with-included-popt \
		--with-included-iniparser \
		ac_cv_header_ifaddrs_h=${ac_cv_header_ifaddrs_h=no} \
		libreplace_cv_HAVE_GETIFADDRS=${libreplace_cv_HAVE_GETIFADDRS=no} \
		PKG_CONFIG=/tmp/tmp \
		--host=$HOST_PREFIX || exit $?
fi

make $MAKE_OPTS modules libtdb libtalloc bin/nmbd || exit $?

cd $abspath/$FETCHEDDIR

rm -rf build
mkdir -p build/etc \
	build/sbin \
	build/var/run/samba/cores/nmbd \
	build/var/run/samba/cores/smbd \
	build/var/run/samba/locks \
	build/usr/local/samba/lib/charset \
	build/usr/local/samba/private

cp -pf source3/bin/nmbd build/sbin
$HOST_PREFIX-strip build/sbin/nmbd

cp -pf smb.conf.pepos build/etc/smb.conf
cp -pf source3/bin/CP850.so build/usr/local/samba/lib/charset
cp -pf source3/bin/CP437.so build/usr/local/samba/lib/charset
