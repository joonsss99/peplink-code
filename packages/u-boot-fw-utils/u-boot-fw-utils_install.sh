#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

binpath=${FETCHEDDIR}/tools/env/
bin=fw_printenv
[ ! -f ${binpath}/${bin} ] && exit 1

mkdir -p ${abspath}/${MNT}/sbin/ ${abspath}/${MNT}/etc/ ${abspath}/${MNT}/var/lock/ || exit $?
cp -pf ${binpath}/${bin} ${abspath}/${MNT}/sbin/ || exit $?
ln -snf ${bin} ${abspath}/${MNT}/sbin/fw_setenv || exit $?
cp -pf ${FETCHEDDIR}/tools/env/fw_env-${PL_BUILD_ARCH}.config ${abspath}/${MNT}/etc/fw_env.config || exit $?

if [ "$HAS_UPGRADER" = "y" ]; then
	mkdir -p ${UPGRADER_ROOT_DIR}/sbin/ ${UPGRADER_ROOT_DIR}/etc/ ${UPGRADER_ROOT_DIR}/var/lock/ || exit $?
	cp -pf ${binpath}/${bin} ${abspath}/${UPGRADER_ROOT_DIR}/sbin/ || exit $?
	ln -snf ${bin} ${abspath}/${UPGRADER_ROOT_DIR}/sbin/fw_setenv || exit $?
	cp -pf ${FETCHEDDIR}/tools/env/fw_env-${PL_BUILD_ARCH}.config ${abspath}/${UPGRADER_ROOT_DIR}/etc/fw_env.config || exit $?
fi
