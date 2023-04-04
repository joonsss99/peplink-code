#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

if [ "$PL_BUILD_ARCH" = "ar7100" ]; then
	mkdir -p $abspath/$RAMFS_ROOT/usr/local/ilink/bin
	install -p -m 755 -T $FETCHEDDIR/etc/platform_specific_func.def $abspath/$RAMFS_ROOT/etc/platform_specific_func.def
	ln -sf platform_specific_func.def $abspath/$RAMFS_ROOT/etc/platform_specific_func
	install -p        -T $FETCHEDDIR/etc/fstab.plb30b $abspath/$RAMFS_ROOT/etc/fstab
	install -p -m 755 -T $FETCHEDDIR/etc/init.plb30b $abspath/$RAMFS_ROOT/init
	install -p -m 755    $FETCHEDDIR/bin/toggle_gpio.sh $abspath/$RAMFS_ROOT/usr/local/ilink/bin
	install -p -m 755    $FETCHEDDIR/bin/sdcard_func $abspath/$RAMFS_ROOT/usr/local/ilink/bin
	install -p -m 755    $FETCHEDDIR/bin/map_device_config $abspath/$RAMFS_ROOT/usr/local/ilink/bin
	install -p -m 755    $FETCHEDDIR/bin/*.awk $abspath/$RAMFS_ROOT/usr/local/ilink/bin
	install -p -m 755    $FETCHEDDIR/bin/hotplug $abspath/$RAMFS_ROOT/sbin/

	make $fmk -C $abspath/$FETCHEDDIR/balance_interface DOTCONFIG_DIR=.. DESTDIR=$abspath/$RAMFS_ROOT install || exit $?
elif [ "$BUILD_TARGET" = "ipq64" -o "$BUILD_TARGET" = "aponeax" ]; then
	install -p -m 755 -T $FETCHEDDIR/etc/init.ipq64 $abspath/$RAMFS_ROOT/init
fi
