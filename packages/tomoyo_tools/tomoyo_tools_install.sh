#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?

make INSTALLDIR=${abspath}/${MNT}/ USRLIBDIR=/usr/lib install || exit $?
rm -f ${abspath}/${MNT}/usr/lib/tomoyo/*.tomoyo
${HOST_PREFIX}-strip --strip-all \
	${abspath}/${MNT}/sbin/tomoyo-init \
	${abspath}/${MNT}/usr/sbin/tomoyo-* \
	${abspath}/${MNT}/usr/lib/libtomoyo* \
	${abspath}/${MNT}/usr/lib/tomoyo/* || exit $?

mkdir -p ${abspath}/${MNT}/etc/tomoyo || exit $?
cp -af ./config/* ${abspath}/${MNT}/etc/tomoyo/ || exit $?
