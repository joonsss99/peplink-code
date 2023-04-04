#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
STAGINGDIR=staging

. ./make.conf

abspath=`pwd`

CONFIGURE_PREFIX_OPT=
if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	# [Bug#15462] ContentHub uses custom path prefix
	CONFIGURE_PREFIX_OPT="--prefix=/libraries/python"
fi

if true; then
	#
	# For Python 2.7.12+ at pepos-master-v2.7.12
	#
	# [Bug#15834] [Gerrit#13568] Supports building host-python on build
	#   machine without build-python installed
	# Must passes the PYTHON_FOR_BUILD variable to configure, to instruct
	#   configure NOT to look for python installed on the build machine.
	#   See configure and Makefile.pre.in for details.
	# Similar to PYTHON_FOR_BUILD, introduced PYTHON_FOR_BUILD_INSTALL for
	#   cross-compiling host-python modules during `make libinstall`, which
	#   requires setting build-python WITHOUT referencing host-library paths
	#
	BUILD_PREFIX=`gcc -dumpmachine`
	if [ ! -f ${FETCHEDDIR}/Makefile ]; then
		HOST_CPU=`echo ${HOST_PREFIX} | cut -d "-" -f 1`
		PYTHON_VERSION_XY=`sed -n -e "/^PACKAGE_VERSION='\(.*\)'/ { s||\1|; p; q }" ${FETCHEDDIR}/configure`
		cd ${FETCHEDDIR}
		cat > config.site << EOF
ac_cv_file__dev_ptmx=no
ac_cv_file__dev_ptc=no
EOF
		CC=${HOST_PREFIX}-gcc \
		CXX=${HOST_PREFIX}-g++ \
		AR=${HOST_PREFIX}-ar \
		RANLIB=${HOST_PREFIX}-ranlib \
		CONFIG_SITE=config.site \
		PYTHON_FOR_BUILD="_PYTHON_PROJECT_BASE=${FETCHEDDIR} _PYTHON_HOST_PLATFORM=linux2-${HOST_CPU} PYTHONPATH=build/lib.linux2-${HOST_CPU}-${PYTHON_VERSION_XY}/:./Lib:./Lib/plat-linux2 ${HOST_TOOL_DIR}/python/usr/bin/python" \
		PYTHON_FOR_BUILD_INSTALL="PYTHONPATH=${HOST_TOOL_DIR}/python/usr ${HOST_TOOL_DIR}/python/usr/bin/python" \
		./configure \
			--host=${HOST_PREFIX} --build=${BUILD_PREFIX} \
			${CONFIGURE_PREFIX_OPT} \
			--with-tcltk-includes=${abspath}/${STAGINGDIR}/usr/include \
			--with-tcltk-libs=${abspath}/${STAGINGDIR}/usr/lib \
			--disable-ipv6 || exit $?
		cd ${abspath}
	fi
	# For building on system without Python installed
	#   See also package scripts for python_for_build
	make -C "${FETCHEDDIR}" touch
	# The following modules are not (intended to be) built for Python 2.7.12+:
	#   _bsddb, _tkinter, bsddb185, bz2, dbm, dl, gdbm, imageop,
	#   linuxaudiodev, ossaudiodev, readline, sunaudiodev
	make -C "${FETCHEDDIR}" ${MAKE_OPTS} \
		BLDSHARED="${HOST_PREFIX}-gcc -shared" \
		CROSS_COMPILE=${HOST_PREFIX}- \
		HOSTARCH=${HOST_PREFIX}-gcc BUILDARCH=${BUILD_PREFIX} \
		PYTHON_XCOMPILE_DEPENDENCIES_PREFIX=${abspath}/${STAGINGDIR}/usr \
		sharedmods || exit $?
else
	#
	# For Python 2.7.3 with cross-compile patch at pepos-master-v2.7.3
	#
	HOSTPYTHON="python2.7"
	HOSTPGEN="pgen"
	which "${HOSTPYTHON}" && which "${HOSTPGEN}" || exit $?
	if [ ! -f ${FETCHEDDIR}/Makefile ]; then
		cd ${FETCHEDDIR}
		CC=${HOST_PREFIX}-gcc \
		CXX=${HOST_PREFIX}-g++ \
		AR=${HOST_PREFIX}-ar \
		RANLIB=${HOST_PREFIX}-ranlib \
		./configure --host=${HOST_PREFIX} \
			--build= ${CONFIGURE_PREFIX_OPT} || exit $?
		cd ${abspath}
	fi
	# The following modules are not (intended to be) built for Python 2.7.3:
	#   _bsddb, _tkinter, bsddb185, bz2, bm, dl, gdbm, imageop, nis,
	#   readline, sunaudiodev
	# PYTHONXCPREFIX, PYTHON_XCOMPILE_DEPENDENCIES_PREFIXX, HOSTARCH, and
	#   BUILDARCH are used by the patched setup.py
	# Note: If things are not working when using host Python with non-
	#   standard path prefix, you may want to try removing the -E Python
	#   option from setup.py in the sharedmods target of Makefile.pre.in,
	#   and then try make sharedmods again with all default PYTHON*
	#   environment variables unset except PYTHONHOME and PYTHONPATH below
	make -C "${FETCHEDDIR}" \
		HOSTPYTHON=${HOSTPYTHON} \
		HOSTPGEN=${HOSTPGEN} \
		BLDSHARED="${HOST_PREFIX}-gcc -shared" \
		CROSS_COMPILE=${HOST_PREFIX}- \
		CROSS_COMPILE_TARGET=yes \
		CC=${HOST_PREFIX}-gcc \
		LDSHARED="${HOST_PREFIX}-gcc -shared" \
		HOSTARCH=${HOST_PREFIX}-gcc BUILDARCH= \
		PYTHONXCPREFIX=${HOST_PREFIX} \
		PYTHON_XCOMPILE_DEPENDENCIES_PREFIX=${STAGINGDIR}/usr \
		sharedmods || exit $?
fi
