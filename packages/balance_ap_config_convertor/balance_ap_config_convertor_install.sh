#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

make -C ${FETCHEDDIR} install BUILD_PATH=${abspath}/${MNT} || exit $?
$HOST_PREFIX-strip --remove-section=.note --remove-section=.comment $abspath/$MNT/usr/local/ilink/bin/*_config_convertor
