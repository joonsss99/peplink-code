#!/bin/sh

PACKAGE=$1

abspath=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_pkg_config_vars.sh

. ./make.conf

cd ${FETCHEDDIR}

if [ ! -x configure ]; then
	# Prevent configure from searching hardcoded paths on the build system
	sed -i -e "s|^\(LIBVIRT_SBIN_PATH\)=.*|\1=\"${STAGING}/usr/bin\"|" configure.ac
	autoreconf --verbose --force --install || exit $? # see autogen.sh
fi

# Since libvirt version 5.10+
#   "... mandate to have the build directory different than the directory"
#     from Installation of the libvirt README
mkdir -p build && cd build || exit $?

if [ ! -f Makefile ]; then
	EXTRA_CFG_OPTS= EXTRA_CFG_LIBS=
	if [ "${BLD_CONFIG_SECURITY_APPARMOR}" = "y" ]; then
		EXTRA_CFG_OPTS="--with-secdriver-apparmor
			--with-apparmor=${STAGING}/usr
			--with-apparmor-profiles=/etc/apparmor.d/libvirt/TEMPLATE.lxc"
		EXTRA_CFG_LIBS="-lapparmor"
	else
		EXTRA_CFG_OPTS="--without-secdriver-apparmor"
	fi
	DMIDECODE=/usr/sbin/dmidecode \
	TC=/usr/bin/tc \
	UDEVADM=/bin/udevadm \
	MODPROBE=/sbin/modprobe \
	RMMOD=/sbin/rmmod \
	MOUNT=/bin/mount \
	UMOUNT=/bin/umount \
	IP_PATH=/bin/ip \
	IPTABLES_PATH=/sbin/iptables \
	IP6TABLES_PATH=/sbin/ip6tables \
	EBTABLES_PATH=/bin/ebtables \
	PARTED=/usr/bin/parted \
	PVCREATE=/usr/sbin/pvcreate \
	VGCREATE=/usr/sbin/vgcreate \
	LVCREATE=/usr/sbin/lvcreate \
	PVREMOVE=/usr/sbin/pvremove \
	VGREMOVE=/usr/sbin/vgremove \
	LVREMOVE=/usr/sbin/lvremove \
	LVCHANGE=/usr/sbin/lvchange \
	VGCHANGE=/usr/sbin/vgchange \
	VGSCAN=/usr/sbin/vgscan \
	PVS=/usr/sbin/pvs \
	VGS=/usr/sbin/vgs \
	LVS=/usr/sbin/lvs \
	QEMU_BRIDGE_HELPER=/usr/libexec/qemu-bridge-helper \
	LIBXML_CFLAGS="-I${STAGING}/usr/include/libnl3 -I${STAGING}/usr/include -I${STAGING}/usr/include/libxml2" \
	LIBXML_LIBS="-L${STAGING}/usr/lib -lz -lxml2" \
	LIBNL_CFLAGS="-I${STAGING}/usr/include/libnl3" \
	LIBNL_LIBS="-L${STAGING}/usr/lib -lnl-3" \
	DBUS_CFLAGS="-I${STAGING}/usr/include/dbus-1.0 -I${STAGING}/usr/lib/dbus-1.0/include" \
	DBUS_LIBS="-L${STAGING}/usr/lib -ldbus-1" \
	CFLAGS="-I${STAGING}/usr/include/libnl3 -I${STAGING}/usr/include -I${STAGING}/usr/include/tirpc" \
	CPPFLAGS="-I${STAGING}/usr/include/libnl3 -I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	LIBS="-ldl -lyajl -ldevmapper -lnl-3 -lnl-route-3 -lz -lxml2" \
	LIBS="${LIBS} -lsasl2 -ldbus-1 -lcrypto -lsqlite3 -lffi" \
	LIBS="${LIBS} -lglib-2.0 -lgmodule-2.0 -lgio-2.0 -lgobject-2.0" \
	LIBS="${LIBS} -lgmp -lnettle -lhogweed -ltasn1 -lunistring -lgnutls" \
	LIBS="${LIBS} ${EXTRA_CFG_LIBS}" \
		../configure \
		--srcdir=.. \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--prefix=/usr \
		--libdir=/usr/lib \
		--host=${HOST_PREFIX} \
		--with-yajl \
		--with-sasl="${STAGING}/usr" \
		--without-blkid \
		--without-bhyve \
		--without-curl \
		--without-dbus \
		--without-dtrace \
		--without-firewalld \
		--without-fuse \
		--without-glusterfs \
		--without-hal \
		--without-libpcap \
		--without-libxl \
		--without-netcf \
		--without-numad \
		--without-openwsman \
		--without-pciaccess \
		--without-pm-utils \
		--without-polkit \
		--without-readline \
		--without-ssh2 \
		--without-secdriver-selinux \
		--without-storage-fs \
		--without-storage-lvm \
		--without-storage-iscsi \
		--without-storage-iscsi-direct \
		--without-storage-scsi \
		--without-storage-mpath \
		--without-storage-disk \
		--without-storage-rbd \
		--without-storage-sheepdog \
		--without-storage-gluster \
		--without-storage-zfs \
		--without-storage-vstorage \
		--without-test-suite \
		--without-udev \
		--without-wireshark-dissector \
		--without-ws-plugindir \
		--disable-werror \
		--with-qemu-user=root \
		--with-qemu-group=root \
		${EXTRA_CFG_OPTS} \
		|| exit $?
fi

make ${MAKE_OPTS} || exit $?
