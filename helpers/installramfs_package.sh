#!/bin/sh

PACKAGE=$1

. ${HELPERS}/functions

THISPACKAGE=${PACKAGESDIR}/${PACKAGE}
. ${THISPACKAGE}/${PACKAGE}.conf

# do the action
if [ -n "${installramfs}" ]; then
	#${installramfs} ${PACKAGE}
	installramfs_time_it ${installramfs} ${PACKAGE}
fi
