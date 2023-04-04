#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`
objtree="$abspath/$OBJTREE/busybox"

make -C $FETCHEDDIR install O=$objtree CROSS_COMPILE=$HOST_PREFIX- || exit $?
[ -d $objtree/_install ] || exit $?
cp -pRf $objtree/_install/* ${abspath}/$RAMFS_ROOT || exit $?

# TODO: reboot command
REBOOT_FILE=${abspath}/${RAMFS_ROOT}/sbin/reboot
rm -f ${REBOOT_FILE}
cat > ${REBOOT_FILE} << EOF
#!/bin/sh

echo 0 > /proc/sys/kernel/printk
echo "System is rebooting..." > /dev/console
echo 1 > /proc/sys/kernel/panic
kill -1 1
EOF
chmod 755 ${REBOOT_FILE} || exit $?
