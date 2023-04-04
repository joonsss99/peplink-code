#!/bin/sh

PACKAGE=$1

. ${HELPERS}/functions

default_cvs_fetch=$PACKAGESDIR/common/default_cvs_fetch.sh
default_svn_fetch=$PACKAGESDIR/common/default_svn_fetch.sh
default_git_fetch=$PACKAGESDIR/common/default_git_fetch.sh
default_git_submodule_fetch=$PACKAGESDIR/common/default_git_submodule_fetch.sh

THISPACKAGE=${PACKAGESDIR}/${PACKAGE}
. ${THISPACKAGE}/${PACKAGE}.conf || exit $?

if [ -n "${fetch}" ]; then
	fetch_time_it ${fetch} "${PACKAGE}"
fi
