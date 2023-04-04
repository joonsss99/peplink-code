#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

set_pkgrev $PACKAGE

common_fetch_cvs_version ${PACKAGE} ${PACKAGE} ${pkgrev} ${FETCHDIR} || exit 1
cd ${FETCHEDDIR}
tar zxf util-linux-2.12p.tar.gz
