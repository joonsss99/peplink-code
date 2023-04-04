#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

install_files()
{
	# create ic2 folder which is monitored by inotify (wtp)
	mkdir -p $1/var/run/ilink/ic2

	# create ac directory because some applications inotify files in it
	[ "$BUILD_MODEL" = "bs" ] && mkdir -p $1/var/run/ilink/ac

	if [ "$BUILD_TARGET" = "apone" ] || [ "$BUILD_TARGET" = "aponeac" ] || [ "$BUILD_TARGET" = "aponeax" ] ; then
		CONTROLLER_MGMT="WLC_MGMT=y"
	fi

	fmk="-f $PROJECT_MAKE/Makefile"
	make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$1 $CONTROLLER_MGMT install || exit $?
}

install_files $abspath/$MNT || exit $?
if [ "$BLD_CONFIG_PREBUILT_EXPORT" = "y" ] ; then
	create_prebuilt_install_dir $TOP_PREBUILT_EX/$PACKAGE/tmp/mnt
	install_files $TOP_PREBUILT_EX/$PACKAGE/tmp/mnt || exit $?
	# package tarball
	create_prebuilt_tarball $PACKAGE || exit $?
fi
exit 0
