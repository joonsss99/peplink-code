#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ "${BLD_CONFIG_MEDIAFAST_BUILT_IN}" = "y" ]; then
	cd $FETCHEDDIR
	make -C tools install DESTDIR=${abspath}/${MNT}/ \
		STRIP="--strip --strip-program=${HOST_PREFIX}-strip" || exit $?
	make -C libdm install_dynamic DESTDIR=${abspath}/${MNT}/ \
		STRIP="--strip --strip-program=${HOST_PREFIX}-strip" || exit $?
	# [Bug#15117] Disable the backup and archiving of volume metadata
	# (as plain text files at /etc/lvm by default) upon any modification
	mkdir -p $abspath/$MNT/etc/lvm
	echo "backup {
	backup = 0
	archive = 0
}" > $abspath/$MNT/etc/lvm/lvm.conf
	make -C libdm install_dynamic DESTDIR=${abspath}/${UPGRADER_ROOT_DIR}/ \
		STRIP="--strip --strip-program=${HOST_PREFIX}-strip" || exit $?
else # below are original procedures for fhvm and ar7100 /w RAMFS
cd $FETCHEDDIR/libdm/ioctl
tar cf - *.so* | tar -C ${abspath}/${MNT}/lib -xf - || exit 1
$HOST_PREFIX-strip $abspath/$MNT/lib/libdevmapper.so.*

cd $abspath/$FETCHEDDIR
cp -pf tools/dmsetup $abspath/$MNT/sbin/
$HOST_PREFIX-strip $abspath/$MNT/sbin/dmsetup
fi

cd $abspath

if [ "$FW_CONFIG_KDUMP" = "y" -a "$KDUMP_DM_CRYPT_PARTITION" = "y" ]; then
	cd $FETCHEDDIR/libdm/ioctl
	tar cf - *.so* | tar -C $abspath/$KDUMP_ROOT_DIR/lib -xf - || exit 1
	cd $abspath
fi
