#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

FMK="-f ${PROJECT_MAKE}/Makefile"

abspath=`pwd`

CGI_BIN=${abspath}/${MNT}/web/cgi-bin

mkdir -p ${CGI_BIN}/switch
install -p -m 755 ${FETCHEDDIR}/sw_event.cgi ${CGI_BIN}/switch

make ${FMK} ${MAKE_OPTS} -C ${FETCHEDDIR} DESTDIR=${abspath}/${MNT} CROSS_COMPILE=$HOST_PREFIX- install || exit $?

