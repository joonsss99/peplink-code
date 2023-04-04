#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#becasue the firmware is for all balance models
#login.bs will detect the balance model and
#check corresponding password

mkdir -p ${abspath}/${MNT}/bin
cp -pf ${FETCHEDDIR}/login.$BUILD_MODEL ${abspath}/${MNT}/bin/
ln -snf login.$BUILD_MODEL ${abspath}/${MNT}/bin/login
$HOST_PREFIX-strip ${abspath}/${MNT}/bin/login.$BUILD_MODEL
