#!/bin/sh

#
# Supports only x86_64
# - Skip PowerPC, until [ibmruntimes/v8ppc issue#119] is fixed
# - Skip ARM64, until the building of `mksnapshot` host executable, which links
#   against target libraries unexpectedly, can be skipped
#
if [ ! "${BLD_CONFIG_ARCH}" = "x86_64" ]; then
	echo "$BLD_CONFIG_ARCH not supported yet" >&2
	exit 1
fi

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
STAGINGDIR=staging

. ./make.conf

abspath=`pwd`

CONFIGURE_OPTS=
if [ "${BLD_CONFIG_MEDIAFAST_CONTENTHUB}" = "y" ]; then
	# [Bug#15462] ContentHub uses custom path prefix
	CONFIGURE_OPTS="${CONFIGURE_OPTS} --prefix=/libraries/nodejs"
fi
if [ "${BLD_CONFIG_ARCH}" = "arm64" ]; then
	# [Bug#26304] Remove the building of some host executables that are
	#   being linked against target (not host) libraries unexpectedly
	CONFIGURE_OPTS="${CONFIGURE_OPTS} --dest-cpu=arm64"
fi

cd ${FETCHEDDIR} || exit $?

PYTHONHOME="${HOST_TOOL_DIR}/python3/usr"
PYTHON_EXE="${PYTHONHOME}/bin/python3.8"
PYTHONPATH="${PYTHONHOME}/lib/python3.8"
PYTHONHOME=${PYTHONHOME} ${PYTHON_EXE} --version || exit $?

# building node.js 16+ requires Python 3.6+ with bz2 as interpreter
# configure
# --cross-compiling:  enable cross-compiling for v16.x.x...
# --without-intl:     not download intl packages
# --without-snapshot: (nodejs #4860) not calling `mksnapshot` host executable
# --without-node-snapshot: replacement of the above obsoleted option?
# --shared-openssl:   workaround to "Argument list too long" make error
if [ ! -f "config.gypi" ]; then
	CC=${HOST_PREFIX}-gcc \
	CXX=${HOST_PREFIX}-g++ \
	AR=${HOST_PREFIX}-ar \
	CC_host=gcc \
	CXX_host=g++ \
	AR_host=ar \
	CC_target=${HOST_PREFIX}-gcc \
	CXX_target=${HOST_PREFIX}-g++ \
	AR_target=${HOST_PREFIX}-ar \
	PYTHONHOME="${PYTHONHOME}" PYTHONPATH="${PYTHONPATH}" ${PYTHON_EXE} \
		configure \
		${CONFIGURE_OPTS} \
		--cross-compiling \
		--dest-os=linux \
		--shared-openssl \
		--shared-openssl-includes="${abspath}/${STAGINGDIR}/usr/include" \
		--shared-openssl-libpath="${abspath}/${STAGINGDIR}/usr/lib" \
		--shared-zlib \
		--shared-zlib-includes="${abspath}/${STAGINGDIR}/usr/include" \
		--shared-zlib-libpath="${abspath}/${STAGINGDIR}/usr/lib" \
		--without-intl \
		--without-node-snapshot \
		--verbose || exit $?
fi

# build
CC=${HOST_PREFIX}-gcc \
CXX=${HOST_PREFIX}-g++ \
AR=${HOST_PREFIX}-ar \
CC_host=gcc \
CXX_host=g++ \
AR_host=ar \
CC_target=${HOST_PREFIX}-gcc \
CXX_target=${HOST_PREFIX}-g++ \
AR_target=${HOST_PREFIX}-ar \
PYTHON="PYTHONPATH=${PYTHONPATH} ${PYTHON_EXE}" \
DESTDIR=${abspath}/tmp/contenthub_packages \
make ${MAKE_OPTS} all || exit $?
