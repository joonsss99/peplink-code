#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ ! -d ${FETCHEDDIR}/etc ]; then
echo "${PACKAGE}: ${FETCHEDDIR}/etc - no such directory"
exit 1
fi

cp -f $FETCHEDDIR/etc/inittab $abspath/$MNT/etc || exit 1

cd ${abspath}/${FETCHEDDIR}/etc
tar --exclude=CVS -cf - * | ( cd ${abspath}/${MNT}/etc ; tar xvf - )
[ $? -ne 0 ] && exit 1

cd ${abspath}/${FETCHEDDIR}/bin
tar --exclude=CVS -cf - * | ( cd ${abspath}/${MNT}/usr/local/ilink/bin ; tar xvf - )
[ $? -ne 0 ] && exit 1

rm -f ${abspath}/${MNT}/etc/rc.sysinit
mv -f ${abspath}/${MNT}/etc/rc.sysinit.x86 ${abspath}/${MNT}/etc/rc.sysinit || exit 1

rm -f ${abspath}/${MNT}/usr/local/manga/conf/config.def.*
cp -Rfp ${abspath}/${FETCHEDDIR}/master_config/config.def.* ${abspath}/${MNT}/usr/local/manga/conf/ || exit 1

ln -sf conn ${abspath}/${MNT}/usr/local/ilink/bin/connstart
ln -sf conn ${abspath}/${MNT}/usr/local/ilink/bin/connstop

ln -sf /usr/local/ilink/bin/vm_license_helper ${abspath}/${MNT}/usr/local/ilink/bin/wtpevent

chmod a+x ${abspath}/${MNT}/usr/local/ilink/bin/*
mkdir -p ${abspath}/${MNT}/var/run/ilink/bin

make -C ${abspath}/${FETCHEDDIR}/src install CROSS_COMPILE=$HOST_PREFIX- PREFIX=/usr/local/ilink DESTDIR=$abspath/$MNT || exit $?

mkdir -p ${abspath}/${MNT}/var/run/ilink/vpn/peers
mkdir -p ${abspath}/${MNT}/etc/speedfusion
mkdir -p ${abspath}/${MNT}/dev/shm
mkdir -p ${abspath}/${MNT}/mnt/info

#generate a set magic files for each model, for vm version
if [ "${HOST_MODE}" = "vm" ]; then
	HOST_TOOLS_DIR=$abspath/tools/host/bin
	mkdir -p ${abspath}/${MNT}/usr/local/manga/magic_block_file
	mkdir -p ${abspath}/${MNT}/usr/local/manga/vm_license
	
	case ${BUILD_TARGET} in
	fhvm)
		MB_MODEL="FHBVM"
		MB_VARIANT="GENERIC"
		MB_OEMID="PEPLINK"
		MB_SERIAL="1824-C792-89C0"
		;;
	*)
		echo "invalid HOST_MODE"
		exit 1
		;;
	esac
	
	${HOST_TOOLS_DIR}/sethwinfo -f ${abspath}/${MNT}/usr/local/manga/magic_block_file/magic_block -m ${MB_MODEL} -v ${MB_VARIANT} -o ${MB_OEMID} -s ${MB_SERIAL} -E -p "" -x 1 -w 1 -b || exit $?
	cp -f ${abspath}/${FETCHEDDIR}/vm_license/vm_license.fhvm ${abspath}/${MNT}/usr/local/manga/vm_license/vm_license || exit $?
fi

inittab_install $abspath add respawn "/usr/local/ilink/bin/wan_link_usage_hourly"

if [ "$FW_CONFIG_KDUMP" = "y" ] ; then
        cp $abspath/$FETCHEDDIR/kdump/init $abspath/$KDUMP_ROOT_DIR
fi
