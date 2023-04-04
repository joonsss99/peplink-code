#!/bin/sh

PACKAGE=balance_kmod

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C $FETCHEDDIR empty_defconfig
make -C $FETCHEDDIR ${TARGET_SERIES}_defconfig
make -C $FETCHEDDIR ${PL_BUILD_ARCH}_defconfig

ILINK_OUT_INC_DIR=${STAGING}/usr/include/ilink_out

mkdir -p $ILINK_OUT_INC_DIR

cp -a ${FETCHEDDIR}/lib/ilink_out/ct_sess.h ${ILINK_OUT_INC_DIR}
cp -a ${FETCHEDDIR}/lib/ilink_out/ilink.h ${ILINK_OUT_INC_DIR}
cp -a ${FETCHEDDIR}/lib/ilink_out/config.h ${ILINK_OUT_INC_DIR}
cp -a ${FETCHEDDIR}/lib/ilink_out/iface.h ${ILINK_OUT_INC_DIR}
cp -a ${FETCHEDDIR}/lib/ilink_out/bslicense_kernel.h ${ILINK_OUT_INC_DIR}
cp -a ${FETCHEDDIR}/lib/ilink_out/lb_rule.h ${ILINK_OUT_INC_DIR}
cp -a ${FETCHEDDIR}/lib/ilink_out/lb_dns.h ${ILINK_OUT_INC_DIR}

NDPI_INC_DIR=${STAGING}/usr/include/ndpi

mkdir -p $NDPI_INC_DIR

cp -a ${FETCHEDDIR}/lib/ndpi/src/include/clienttype_info.h ${NDPI_INC_DIR}
