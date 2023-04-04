#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

# $1 MNT path
install_files()
{
	mkdir -p $1/var/run/ilink/vpn
	mkdir -p $1/var/run/ilink/cert/speedfusion/hash

	mkdir -p $1/etc/speedfusion
	make -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$1 install || exit $?

	# until we can make install this...
	cp $FETCHEDDIR/libvpnstatus/vpnstatus.schema $1/etc/speedfusion/ || exit $?
	cp $FETCHEDDIR/daemon/vpndaemon.schema $1/etc/speedfusion/ || exit $?

	for e in upevent downevent dropin; do
		if [ "`grep vpn_daemon $1/usr/local/ilink/bin/$e`" = "" ]; then
			echo "kill -HUP \`cat /var/run/vpn_daemon.pid\`" >> $1/usr/local/ilink/bin/$e
		fi
	done
}

install_files $abspath/$MNT
if [ "$BLD_CONFIG_PREBUILT_EXPORT" = "y" ] ; then
	# export staging files
	make -C $FETCHEDDIR $common_flags PREFIX=$TOP_PREBUILT_EX/$PACKAGE/staging/usr install-dev || exit $?
	create_prebuilt_install_dir $TOP_PREBUILT_EX/$PACKAGE/tmp/mnt
	install_files $TOP_PREBUILT_EX/$PACKAGE/tmp/mnt || exit $?
	# package tarball
	create_prebuilt_tarball $PACKAGE || exit $?
fi
