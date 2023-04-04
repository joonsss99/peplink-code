#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

cd "${FETCHEDDIR}/build" || exit $?

INTER_INSTALL_DIR="${abspath}/${FETCHEDDIR}/build/install"
rm -rf "${INTER_INSTALL_DIR}"
mkdir -p "${INTER_INSTALL_DIR}" || exit $?
make DESTDIR="${INTER_INSTALL_DIR}" install || exit $?
rm -rf \
	"${INTER_INSTALL_DIR}/etc/logrotate.d" \
	"${INTER_INSTALL_DIR}/etc/libvirt/qemu" \
	"${INTER_INSTALL_DIR}/usr/include" \
	"${INTER_INSTALL_DIR}/usr/lib/sysctl.d" \
	"${INTER_INSTALL_DIR}/usr/share/augeas" \
	"${INTER_INSTALL_DIR}/usr/share/doc" \
	"${INTER_INSTALL_DIR}/usr/share/libvirt/cpu_map/ppc"* \
	"${INTER_INSTALL_DIR}/usr/share/libvirt/test"* \
	"${INTER_INSTALL_DIR}/usr/share/locale" \
	"${INTER_INSTALL_DIR}/usr/share/man" \
	"${INTER_INSTALL_DIR}/usr/lib"*/pkgconfig \
	"${INTER_INSTALL_DIR}/usr/lib"*/*.la \
	"${INTER_INSTALL_DIR}/usr/lib"*/libvirt/*/*.la \
	"${INTER_INSTALL_DIR}/var" \
	|| exit $?

${HOST_PREFIX}-strip \
	"${INTER_INSTALL_DIR}/usr/lib"*/*.so* \
	"${INTER_INSTALL_DIR}/usr/bin/"* \
	"${INTER_INSTALL_DIR}/usr/sbin/"* \
	|| true # expects error when attempting to strip ASCII files

if [ ! "${BLD_CONFIG_SECURITY_APPARMOR}" = "y" ]; then
	rm -rf "${INTER_INSTALL_DIR}/etc/apparmor.d"
fi

rsync -aK "${INTER_INSTALL_DIR}/" "${abspath}/${MNT}/" || exit $?

# symlinks to permanent storage, i.e.
#   /var/*/libvirt -> /etc/libvirt/(storage)/volume/*/libvirt
# excludes /var/log, which will be mounted as tmpfs at run time
for i in cache lib run; do
	mkdir -p "${abspath}/${MNT}/var/$i" || exit $?
	ln -sf /etc/libvirt/disk/volume/$i/libvirt "${abspath}/${MNT}/var/$i/" \
		|| exit $?
done
