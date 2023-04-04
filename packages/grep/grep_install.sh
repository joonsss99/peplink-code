#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

DESTDIR=${abspath}/${MNT}/bin

mkdir -p ${DESTDIR}
cp -pf ${FETCHEDDIR}/src/grep ${DESTDIR}/ || exit $?
$HOST_PREFIX-strip ${DESTDIR}/grep || exit $?
ln -snf grep ${DESTDIR}/egrep || exit $?

UPGRADER_DESTDIR=${abspath}/${UPGRADER_ROOT_DIR}/bin
mkdir -p ${UPGRADER_DESTDIR}
if [ "${HAS_UPGRADER}" = "y" ]; then
	cp -pf ${FETCHEDDIR}/src/grep ${UPGRADER_DESTDIR}/ || exit $?
	$HOST_PREFIX-strip ${UPGRADER_DESTDIR}/grep || exit $?
	ln -snf grep ${UPGRADER_DESTDIR}/egrep || exit $?
fi

