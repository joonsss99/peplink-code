#!/bin/bash

PACKAGE=$1

. ${HELPERS}/functions

THISPACKAGE=${PACKAGESDIR}/${PACKAGE}
. ${THISPACKAGE}/${PACKAGE}.conf


log=build_logs/$PACKAGE.log
err=build_logs/$PACKAGE.err.log

# do the action
if [ -n "${build}" ]; then
	case "$V" in
	0)
		build_time_it $build $PACKAGE > $log 2>&1
		;;
	1)
		build_time_it $build $PACKAGE > $log 2> >(tee $err >&2)
		;;
	177)
		export -f build_time_it
		# 177 is BUILDBOT mode
		# fake tty to gcc even we redirect the output to a file
		script -qfe -c "build_time_it $build $PACKAGE" /dev/null < /dev/null > $log
		;;
	2|*)
		#build_time_it $build $PACKAGE > >(tee $log) 2> >(tee $err >&2)
		build_time_it $build $PACKAGE
		;;
	esac

	err_ret=$?

	if [ -n "$BUILDBOT" -a $err_ret -ne 0 ] ; then
		ln -sf $log build_error.log
	fi

	exit $err_ret
fi
