#!/bin/sh

PACKAGE=$1

. ${PACKAGESDIR}/common/common_functions

# Check rootdisk size
if [ -n "${RDISK_SIZE}" ]; then
	rdisk_path="`readlink images/rdisk.gz`"
	if [ ${RDISK_SIZE} -lt `stat -c %s $rdisk_path` ]; then
		# Error if rdisk size is too large.
		echo_error "Root disk size is too large!"
		exit 1
	fi
fi

if [ -n "${BLD_CONFIG_DYNAMIC_ROOTFS_SIZE}" ]; then

	NEW_KERNEL_SIZE="`stat -c %s images/uImage.fit.pep.all`"
	NEW_FS_SIZE="`stat -c %s images/rdisk.sfs`"
	if [ ${NEW_KERNEL_SIZE:-0} -eq 0 -o ${NEW_FS_SIZE:-0} -eq 0 ]; then
		echo_error "invalid kernel or rdisk size"
		exit 1
	fi

	NEW_KERNEL_SIZE_ROUND=`common_roundup $NEW_KERNEL_SIZE 65536`
	NEW_FW_SIZE_ROUND=`common_roundup $NEW_FS_SIZE 65536`
	NEW_TOTAL_SIZE=$((NEW_KERNEL_SIZE_ROUND+NEW_FW_SIZE_ROUND))
	if [ $NEW_TOTAL_SIZE -gt $BLD_CONFIG_DYNAMIC_ROOTFS_SIZE ]; then
		echo_error "Exceed firmware size limit"
		sync
		exit 1
	fi
fi

case $PL_BUILD_ARCH in
x86*)
	$PACKAGESDIR/$PACKAGE/x86_install.sh $PACKAGE || exit $?
	;;
ar7100|powerpc|arm|arm64|ramips)
	$PACKAGESDIR/$PACKAGE/${PL_BUILD_ARCH}_install.sh $PACKAGE || exit $?
	;;
*)
	echo_error "arch $PL_BUILD_ARCH not supported"
	exit 1
	;;
esac
