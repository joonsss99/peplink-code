#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

if cd ${FETCHEDDIR}; then
	make distclean
	rm -f config.status
	git checkout configure # don't care if this fails
fi
