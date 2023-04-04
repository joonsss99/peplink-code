#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

cp ${FETCHEDDIR}/defconfigs/$BUILD_TARGET ${FETCHEDDIR}/.config
