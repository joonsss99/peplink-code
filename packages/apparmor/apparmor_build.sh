#!/bin/sh

PACKAGE=$1

ABSPATH=`pwd`
FETCHEDDIR=${FETCHDIR}/${PACKAGE}

LIBAA_EXT_OPT=
if [ "${BLD_CONFIG_SECURITY_APPARMOR_UTILS}" = "y" ]; then
	export PYTHON="${HOST_TOOL_DIR}/python3/usr/bin/python3"
	export PYTHONPATH="${HOST_TOOL_DIR}/python3"
	export PYTHON_VERSION="3"
	export PYTHON_VERSIONS="python3"
	LIBAA_EXT_OPT="--with-python"
fi

. ./make.conf

cd ${FETCHEDDIR}/libraries/libapparmor || exit $?
if [ ! -f Makefile ]; then
	./autogen.sh || exit $?
	CFLAGS="-I${STAGING}/usr/include" LDFLAGS="-L${STAGING}/usr/lib" \
	./configure --prefix=/usr --host=${HOST_PREFIX} ${LIBAA_EXT_OPT} \
		|| exit $?
fi
make ${MAKE_OPTS} || exit $?
make ${MAKE_OPTS} DESTDIR=${STAGING} install || exit $?

cd ${ABSPATH}/${FETCHEDDIR} || exit $?
CFLAGS="-I${STAGING}/usr/include" \
	LDFLAGS="-L${STAGING}/usr/lib" \
	CXX="${HOST_PREFIX}-g++" \
	make -C parser ${MAKE_OPTS} || exit $?

rm -f ${STAGING}/usr/lib/libapparmor.la

# Python3 packages

if [ "${BLD_CONFIG_SECURITY_APPARMOR_UTILS}" = "y" ]; then
	DEST_DIR="${ABSPATH}/tmp"
	mkdir -p "${DEST_DIR}" || exit $?

	rm -rf "${DEST_DIR}/apparmor"
	cp -dpR "utils/apparmor" "${DEST_DIR}/" || exit $?

	rm -rf "${DEST_DIR}/LibAppArmor"
	find "libraries/libapparmor/swig/python/build" -name "LibAppArmor" \
		| xargs -i cp -dpR {} "${DEST_DIR}/" || exit $?
fi
