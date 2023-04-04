#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	DEST_DIR=$abspath/tmp/balance_sdk/python2
	rm -rf "${DEST_DIR}"
	mkdir -p "${DEST_DIR}" || exit $?
	cp -dpR ${FETCHEDDIR}/python-2.7/* "${DEST_DIR}/" || exit $?
fi
