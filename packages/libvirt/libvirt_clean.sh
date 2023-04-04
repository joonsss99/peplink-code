#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

if cd ${FETCHEDDIR} 2> /dev/null; then
	rm -rf configure build
	git checkout configure.ac # don't care if this fails
fi
