#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

INSTALL_TARGETS=
[ "${BLD_CONFIG_MEDIAFAST_WEBPROXY}" = "y" ] \
	&& INSTALL_TARGETS="${INSTALL_TARGETS} install-webproxy"
[ "${BLD_CONFIG_MEDIAFAST_CONTENTHUB}" = "y" ] \
	&& INSTALL_TARGETS="${INSTALL_TARGETS} install-contenthub"
[ "${BLD_CONFIG_MEDIAFAST_DOCKER}" = "y" ] \
	&& INSTALL_TARGETS="${INSTALL_TARGETS} install-docker"
[ "${BLD_CONFIG_KVM}" = "y" ] \
	&& INSTALL_TARGETS="${INSTALL_TARGETS} install-kvm"
[ -n "${INSTALL_TARGETS}" ] || exit $?
make -C ${FETCHEDDIR} ${INSTALL_TARGETS} || exit $?
(cd $FETCHEDDIR/build ; tar -cf - . | tar -C $abspath/$MNT --keep-directory-symlink -xf -) || exit $?

if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	cp -pfv images/*.pcpkg $abspath/$MNT/usr/share/ || true
fi
