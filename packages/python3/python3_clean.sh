#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

[ -f "${FETCHEDDIR}/Makefile" ] && make -C "${FETCHEDDIR}" distclean
rm -f "${FETCHEDDIR}/Makefile" "${FETCHEDDIR}/config.site"

if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	rm -rf tmp/contenthub_packages/python3 \
		tmp/contenthub_packages/python3.cfg
elif [ "${HAS_FIRMWARE_MODULES}" = "y" ]; then
	rm -rf "${abspath}/tmp/python3" \
		"${abspath}/tmp/python3.squashfs"
fi
