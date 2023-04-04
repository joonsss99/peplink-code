#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ ! -f ${FETCHEDDIR}/ssh ] && echo "missing binary" && exit 1
[ ! -f ${FETCHEDDIR}/sshd ] && echo "missing binary" && exit 1
[ ! -f ${FETCHEDDIR}/scp ] && echo "missing binary" && exit 1

# binaries
mkdir -p ${abspath}/${MNT}/usr/bin
mkdir -p ${abspath}/${MNT}/usr/sbin
cp -Rpf ${FETCHEDDIR}/ssh ${abspath}/${MNT}/usr/bin/ || exit $?
cp -Rpf ${FETCHEDDIR}/sshd ${abspath}/${MNT}/usr/sbin/ || exit $?
cp -Rpf ${FETCHEDDIR}/scp ${abspath}/${MNT}/usr/sbin/ || exit $?

$HOST_PREFIX-strip $abspath/$MNT/usr/bin/ssh || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/sbin/sshd || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/sbin/scp || exit $?

mkdir -p $abspath/$MNT/usr/local/bin
ln -sf ../../bin/ssh $abspath/$MNT/usr/local/bin/ssh
