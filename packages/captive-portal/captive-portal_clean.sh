#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/captive-portal

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

make -C ${FETCHEDDIR} clean

