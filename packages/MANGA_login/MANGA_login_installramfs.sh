#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

#becasue the firmware is for all balance models
#login.bs will detect the balance model and
#check corresponding password

mkdir -p ${abspath}/${RAMFS_ROOT}/bin
cp -pf ${FETCHEDDIR}/login.bs ${abspath}/${RAMFS_ROOT}/bin/
ln -snf login.bs ${abspath}/${RAMFS_ROOT}/bin/login
