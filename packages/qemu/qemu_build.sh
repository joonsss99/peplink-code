#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_pkg_config_vars.sh

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -x config.status ]; then
	# bypass glib version detection by pkg-config for g_test_trap_subprocess
	#   (assume yes)
	# use libgcrypt-config from staging
	# fixed possible typo of pragma_diagnostic_available
	# fixed possible missing variable atomic64
	# bypass glib modules version detection by pkg-config
	#   force adding glib flags to QEMU_CFLAGS and LIBS
	sed -i -e '/^glib_subprocess=yes/ { n; s/^if /if false \&\& / }' \
		-e "s|libgcrypt-config|${STAGING}/usr/bin/&|g" \
		-e 's|^pragma_disable_unused_but_set=|pragma_diagnostic_available=|' \
		-e '/# See if 64-bit atomic operations are supported./ iatomic64=no' \
		-e '/^for i in $glib_modules/,/^done/ { /^done/ {' \
			-e "aQEMU_CFLAGS=\"-I${STAGING}/usr/include/glib-2.0 \$QEMU_CFLAGS\"" \
			-e "aQEMU_CFLAGS=\"-I${STAGING}/usr/lib/glib-2.0/include \$QEMU_CFLAGS\"" \
			-e "aLIBS=\"-L${STAGING}/usr/lib -lpcre -lglib-2.0 \$LIBS\"" \
			-e '}; s/^/#/ }' \
		configure
	# generates config.status, config-host.mak, config-all-diags.mak,
	#   */config-target.mak, */*/config.mak, etc.
	# bypass all pkg-config probing
	PYTHON="python2.7" \
	./configure \
	--prefix=/usr \
	--cross-prefix="$HOST_PREFIX-" \
	--target-list=x86_64-softmmu \
	--host-cc=gcc \
	--extra-cflags="-I${STAGING}/usr/include -I${STAGING}/usr/include/glib-2.0 -I${STAGING}/usr/lib/glib-2.0/include" \
	--extra-cxxflags="-I${STAGING}/usr/include" \
	--extra-ldflags="-L${STAGING}/usr/lib -L${STAGING}/usr/lib -lpcre -lglib-2.0 -pthread -lffi -lsqlite3 -lcrypto -lz"  \
	--disable-werror \
	--audio-drv-list=oss \
	--disable-xfsctl \
	--disable-docs \
	--disable-sdl \
	--disable-curses \
	--disable-curl \
	--disable-brlapi \
	--disable-bluez \
	--disable-gtk \
	--disable-gnutls \
	--disable-nettle \
	--disable-vte \
	--disable-virglrenderer \
	--disable-xen \
	--disable-linux-aio \
	--disable-mpath \
	--enable-vhost-scsi \
	--enable-vhost-net \
	--enable-vhost-vsock \
	--enable-vhost-user \
	--disable-cap-ng \
	--disable-spice \
	--disable-smartcard \
	--disable-smartcard \
	--disable-libusb \
	--disable-usb-redir \
	--disable-opengl \
	--disable-lzo \
	--disable-snappy \
	--disable-bzip2 \
	--disable-libiscsi \
	--disable-libnfs \
	--disable-seccomp \
	--disable-rbd \
	--disable-glusterfs \
	--disable-vxhs \
	|| exit $?
fi

make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?
