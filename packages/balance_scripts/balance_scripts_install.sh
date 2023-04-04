#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#
# run all the make install first
#

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR DESTDIR=$abspath/$MNT CROSS_COMPILE=$HOST_PREFIX- install || exit $?
# Install kdump
if [ "$FW_CONFIG_KDUMP" = "y" ]; then
  make $fmk -C $FETCHEDDIR/kdump DESTDIR=$abspath/$KDUMP_ROOT_DIR CROSS_COMPILE=$HOST_PREFIX- install || exit $?
fi

if [ "$BLD_CONFIG_OPENSSH" = "y" ] ; then
	# openssh-data
	chmod 700 $abspath/$MNT/root/.ssh/
	chmod 600 $abspath/$MNT/root/.ssh/authorized_keys
	chmod 600 $abspath/$MNT/etc/ssh/ssh_host_dsa_key
	chmod 600 $abspath/$MNT/etc/ssh/ssh_host_rsa_key
	# used by openssh for privilege separation
	mkdir -p $abspath/$MNT/var/empty
	chmod 700 $abspath/$MNT/var/empty
	chmod 700 $abspath/$MNT/root
fi

mkdir -p $abspath/$MNT/var/service

chmod 600 ${abspath}/${MNT}/etc/.ssh/*

#
# now tweak the $abspath/$MNT contents
#

# This is particular needed for CLI login with root previllege
chmod +s ${abspath}/${MNT}/usr/local/ilink/bin/cli_helper

if [ "${BUILD_TARGET}" = "m600" -o "${BUILD_TARGET}" = "m700" -o "${BUILD_TARGET}" = "maxotg" -o "${BUILD_TARGET}" = "maxbr1" -o "${BUILD_TARGET}" = "maxhd4" -o "${BUILD_TARGET}" = "plsw" -o "${BUILD_TARGET}" = "maxdcs" -o "${BUILD_TARGET}" = "maxdcs_ppc" -o "${BUILD_TARGET}" = "maxbr1ac" ]; then
       if [ "`grep modem_hc ${abspath}/${MNT}/etc/inittab`" = "" ]; then
		inittab_install $abspath add respawn "/usr/local/ilink/bin/priority_log"
       fi
fi

mkdir -p ${abspath}/${MNT}/var/run/ilink/cert/self
mkdir -p ${abspath}/${MNT}/var/run/ilink/cert/device

# create symlink for IC2 web admin tunneling (RA to IC2)
# for debug and kill IC2 web admin tunneling related processes
mkdir -p ${abspath}/${MNT}/usr/bin
ln -snf ssh ${abspath}/${MNT}/usr/bin/ssh_ic2
# create symlink for IC2 OOBM LAN access
ln -snf ssh ${abspath}/${MNT}/usr/bin/ssh_oobm

case $PL_BUILD_ARCH in
x86_64)
	#b/w in balance 700 is higher then 200/300, more burst rate
	if [ -f ${abspath}/${MNT}/usr/local/ilink/bin/qos ] ; then
		sed -i "s/ 15k/ 250k/g" ${abspath}/${MNT}/usr/local/ilink/bin/qos
	fi
	;;
ar7100)
	#b/w in balance 210/310 is higher then 200/300, more burst rate
	sed -i "s/ 15k/ 200k/g" ${abspath}/${MNT}/usr/local/ilink/bin/qos
	sed -i "s/console:/console.real:/g" ${abspath}/${MNT}/etc/inittab
	;;
powerpc)
	#b/w in balance 210/310 is higher then 200/300, more burst rate
	sed -i "s/ 15k/ 200k/g" ${abspath}/${MNT}/usr/local/ilink/bin/qos
	sed -i "s/console:/ttyS0:/g" ${abspath}/${MNT}/etc/inittab
	;;
arm|arm64|ramips)
	case $BUILD_TARGET in
	ipq|apone|aponeax|maxdcs_ipq|ipq64|sfchn)
		#b/w in balance 210/310 is higher then 200/300, more burst rate
		sed -i "s/ 15k/ 200k/g" ${abspath}/${MNT}/usr/local/ilink/bin/qos
		sed -i "s/console:/ttyMSM0:/g" ${abspath}/${MNT}/etc/inittab
		;;
	mtk5g|ramips|maxdcs_ramips|aponeac)
		#b/w in balance 210/310 is higher then 200/300, more burst rate
		sed -i "s/ 15k/ 200k/g" ${abspath}/${MNT}/usr/local/ilink/bin/qos
		sed -i "s/console:/ttyS0:/g" ${abspath}/${MNT}/etc/inittab
		;;
	*)
		echo_error "arch $PL_BUILD_ARCH target $BUILD_TARGET not supported"
		exit 1
		;;
	esac
	;;
*)
	echo_error "arch $PL_BUILD_ARCH not supported"
	exit 1
	;;
esac

# Rootdisk setup
mkdir -p ${abspath}/${UPGRADER_ROOT_DIR}/etc
cp -f ${abspath}/${MNT}/etc/platform_specific_func ${abspath}/${UPGRADER_ROOT_DIR}/etc/
