#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

HOSTARG="--host=${HOST_PREFIX}"

make -C ${FETCHEDDIR} HOSTARG="${HOSTARG}" HOSTCC=gcc || exit $?
