#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

[ ! -f ${FETCHEDDIR}/ssh ] && echo "missing binary" && exit 1
[ ! -f ${FETCHEDDIR}/sshd ] && echo "missing binary" && exit 1

# files for /etc/ssh/
mkdir -p ${abspath}/${MNT}/etc/ssh || exit $?
for i in ssh_config sshd_config certs/ssh_host_dsa_key certs/ssh_host_rsa_key moduli ; do
	cp -Rpf $FETCHEDDIR/$i $abspath/$MNT/etc/ssh || exit $?
done

# /root/.ssh/authorized_keys
mkdir -p ${abspath}/${MNT}/root/.ssh || exit $?
cp -pf ${FETCHEDDIR}/keys/authorized_keys ${abspath}/${MNT}/root/.ssh/ || exit $?

# strict directory and file permissions
chmod 700 $abspath/$MNT/root
chmod 700 $abspath/$MNT/root/.ssh
chmod 600 $abspath/$MNT/root/.ssh/authorized_keys 
chmod 600 $abspath/$MNT/etc/ssh/ssh_host_dsa_key 
chmod 600 $abspath/$MNT/etc/ssh/ssh_host_rsa_key 

# binaries
cp -Rpf ${FETCHEDDIR}/ssh ${abspath}/${MNT}/usr/bin/ || exit $?
cp -Rpf ${FETCHEDDIR}/sshd ${abspath}/${MNT}/usr/sbin/ || exit $?

$HOST_PREFIX-strip $abspath/$MNT/usr/bin/ssh || exit $?
$HOST_PREFIX-strip $abspath/$MNT/usr/sbin/sshd || exit $?

ln -sf ../../bin/ssh $abspath/$MNT/usr/local/bin/ssh

# BUG#20641 Remark this device is running legacy openssh
touch $abspath/$MNT/etc/openssh-legacy
