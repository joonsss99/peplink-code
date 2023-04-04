#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	DESTDIR_LIST=${abspath}/tmp/contenthub_packages/libraries/host-essential
else
	DESTDIR_LIST=${abspath}/${MNT}
	[ "${PL_BUILD_ARCH}" = "powerpc" -o  "$PL_BUILD_ARCH" = "ar7100" ] \
		&& DESTDIR_LIST="${DESTDIR_LIST} ${abspath}/${UPGRADER_ROOT_DIR}"
fi

for _DESTDIR in ${DESTDIR_LIST}; do
	mkdir -p ${_DESTDIR}/usr/bin
        mkdir -p ${_DESTDIR}/usr/lib
	make -C ${FETCHEDDIR} DESTDIR=${_DESTDIR} install_runtime || exit $?
	$HOST_PREFIX-strip $_DESTDIR/usr/bin/openssl
	$HOST_PREFIX-strip $_DESTDIR/usr/lib/libcrypto.so.*
	$HOST_PREFIX-strip $_DESTDIR/usr/lib/libssl.so.*
	# EDDY: We don't need this perl script
	rm -f $_DESTDIR/usr/bin/c_rehash
done
