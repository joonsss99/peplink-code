#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

KRBLIBDIR=${FETCHEDDIR}/src/lib

${HOST_PREFIX}-strip ${FETCHEDDIR}/src/clients/kinit/kinit || exit $?
cp -f ${FETCHEDDIR}/src/clients/kinit/kinit ${abspath}/${MNT}/usr/local/ilink/bin || exit $?

${HOST_PREFIX}-strip ${FETCHEDDIR}/src/clients/kdestroy/kdestroy || exit $?
cp -f ${FETCHEDDIR}/src/clients/kdestroy/kdestroy ${abspath}/${MNT}/usr/local/ilink/bin || exit $?

${HOST_PREFIX}-strip ${FETCHEDDIR}/src/clients/klist/klist || exit $?
cp -f ${FETCHEDDIR}/src/clients/klist/klist ${abspath}/${MNT}/usr/local/ilink/bin || exit $?

cp -fL ${KRBLIBDIR}/libcom_err.so.3.0 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libgssapi_krb5.so.2.2 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libgssrpc.so.4.2 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libk5crypto.so.3.1 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libkadm5clnt_mit.so.11.0 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libkadm5srv_mit.so.11.0 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libkdb5.so.9.0 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libkrad.so.0.0 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libkrb5.so.3.3 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libkrb5support.so.0.1 ${abspath}/${MNT}/usr/lib || exit $?
cp -fL ${KRBLIBDIR}/libverto.so.0.0 ${abspath}/${MNT}/usr/lib || exit $?

cd ${abspath}/${MNT}/usr/lib
${HOST_PREFIX}-strip libcom_err.so.3.0 || exit $?
ln -sf libcom_err.so.3.0 libcom_err.so.3 || exit $?
ln -sf libcom_err.so.3.0 libcom_err.so || exit $?

${HOST_PREFIX}-strip libgssapi_krb5.so.2.2 || exit $?
ln -sf libgssapi_krb5.so.2.2 libgssapi_krb5.so.2 || exit $?
ln -sf libgssapi_krb5.so.2.2 libgssapi_krb5.so || exit $?

${HOST_PREFIX}-strip libgssrpc.so.4.2 || exit $?
ln -sf libgssrpc.so.4.2 libgssrpc.so.4 || exit $?
ln -sf libgssrpc.so.4.2 libgssrpc.so || exit $?

${HOST_PREFIX}-strip libk5crypto.so.3.1 || exit $?
ln -sf libk5crypto.so.3.1 libk5crypto.so.3 || exit $?
ln -sf libk5crypto.so.3.1 libk5crypto.so || exit $?

${HOST_PREFIX}-strip libkadm5clnt_mit.so.11.0 || exit $?
ln -sf libkadm5clnt_mit.so.11.0 libkadm5clnt_mit.so.11 || exit $?
ln -sf libkadm5clnt_mit.so.11.0 libkadm5clnt_mit.so || exit $?

${HOST_PREFIX}-strip libkadm5srv_mit.so.11.0 || exit $?
ln -sf libkadm5srv_mit.so.11.0 libkadm5srv_mit.so.11 || exit $?
ln -sf libkadm5srv_mit.so.11.0 libkadm5srv_mit.so || exit $?

${HOST_PREFIX}-strip libkdb5.so.9.0 || exit $?
ln -sf libkdb5.so.9.0 libkdb5.so.9 || exit $?
ln -sf libkdb5.so.9.0 libkdb5.so || exit $?

${HOST_PREFIX}-strip libkrad.so.0.0 || exit $?
ln -sf libkrad.so.0.0 libkrad.so.0 || exit $?
ln -sf libkrad.so.0.0 libkrad.so || exit $?

${HOST_PREFIX}-strip libkrb5.so.3.3 || exit $?
ln -sf libkrb5.so.3.3 libkrb5.so.3 || exit $?
ln -sf libkrb5.so.3.3 libkrb5.so || exit $?

${HOST_PREFIX}-strip libkrb5support.so.0.1 || exit $?
ln -sf libkrb5support.so.0.1 libkrb5support.so.0 || exit $?
ln -sf libkrb5support.so.0.1 libkrb5support.so || exit $?

${HOST_PREFIX}-strip libverto.so.0.0 || exit $?
ln -sf libverto.so.0.0 libverto.so.0 || exit $?
ln -sf libverto.so.0.0 libverto.so || exit $?
