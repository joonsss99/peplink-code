#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?

mkdir -p "${abspath}/${MNT}/usr/bin" || exit $?
install -s --strip-program=${HOST_PREFIX}-strip \
	-D -t "${abspath}/${MNT}/usr/bin" \
	ivshmem-client ivshmem-server \
	qemu-ga qemu-img qemu-io qemu-nbd \
	scsi/qemu-pr-helper \
	x86_64-softmmu/qemu-system-x86_64 \
	|| exit $?

mkdir -p "${abspath}/${MNT}/usr/libexec" || exit $?
install -s --strip-program=${HOST_PREFIX}-strip \
	-D -t "${abspath}/${MNT}/usr/libexec" \
	qemu-bridge-helper \
	|| exit $?

mkdir -p "${abspath}/${MNT}/usr/share/qemu" || exit $?
cd "${STAGING}/usr/share/qemu" || exit $?
rsync -aK \
	--exclude='edk2-*' --exclude='firmware' --exclude='hppa*' \
	--exclude='*.lid' --exclude='openbios*' --exclude='opensbi*.bin' \
	--exclude='ppc*.bin' \
	. "${abspath}/${MNT}/usr/share/qemu/" || exit $?
