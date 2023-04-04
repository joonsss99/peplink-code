#!/bin/sh

PACKAGE=$1

FETCHEDDIR=$FETCHDIR/$PACKAGE

. ${PACKAGESDIR}/common/common_pkg_config_vars.sh

. ./make.conf

cd $FETCHEDDIR

if [ ! -f configure ]; then
	autoreconf -vif || exit $?
fi

if [ ! -f Makefile ] ; then
	CPPFLAGS=-I$STAGING/usr/include \
	LDFLAGS="-L$STAGING/usr/lib -Wl,-rpath-link=$STAGING/usr/lib" \
	./configure --disable-symbol-hiding \
	--build=$(gcc -dumpmachine) \
	--host=$HOST_PREFIX \
	--prefix=/usr --with-ssl --disable-ldap \
	--disable-ftp --disable-rtsp --disable-dict --disable-pop3 \
	--disable-imap --disable-smb --disable-smtp --disable-gopher \
	--disable-manual --disable-ipv6 \
	--disable-cookies \
	--disable-crypto-auth \
	--disable-file \
	--disable-proxy \
	--disable-rtmp \
	--disable-scp \
	--disable-sftp \
	--disable-telnet \
	--disable-tftp \
	--disable-unix-sockets \
	--disable-verbose \
	--disable-versioned-symbols \
	--disable-mime \
	--disable-dateparse \
	--disable-netrc \
	--disable-dnsshuffle \
	--disable-progress-meter \
	--enable-maintainer-mode \
	--enable-werror \
	--without-brotli \
	--without-gssapi \
	--without-libgsasl \
	--without-libidn2 \
	--without-libpsl \
	--without-librtmp \
	--without-libssh2 \
	--without-nghttp2 \
	--without-ntlm-auth \
	|| exit $?
fi

make $MAKE_OPTS || exit $?
make DESTDIR=$STAGING $MAKE_OPTS install || exit $?
