#!/bin/sh

PACKAGE=$1

. ${HELPERS}/functions

THISPACKAGE=${PACKAGESDIR}/${PACKAGE}
. ${THISPACKAGE}/${PACKAGE}.conf

# do the action
if [ -n "${install}" ]; then
	#${install} ${PACKAGE}
	install_time_it ${install} ${PACKAGE}
fi
