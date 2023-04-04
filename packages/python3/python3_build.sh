#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ${PACKAGESDIR}/common/common_pkg_config_vars.sh

. ./make.conf

prefix=
if [ "${HAS_CONTENTHUB_PACKAGES}" = "y" ]; then
	# [Bug#15462] ContentHub uses custom path prefix
	prefix="--prefix=/libraries/python3"
elif [ "${HAS_FIRMWARE_MODULES}" = "y" ]; then
	# The actual path mounted on the firmware, also the same path for
	#   setting the PYTHONHOME environment variable when running
	prefix="--prefix=/mnt/python3"
else
	prefix="--prefix=/usr" # not /usr/local
fi

# [Bug#19908] Prepend the installed path of Python-for-build to the PATH
#   variable, so that it will be configured and built using Python-for-build as
#   the python interpreter.
# Alternative way to specifying Python-for-build is to pass the
#   PYTHON_FOR_BUILD and PYTHON_FOR_REGEN variable into the configure, but one
#   must make sure the ABIFLAGS, MACHDEP, and MULTIARCH variables are all set
#   correctly across different platforms.
export PATH="${HOST_TOOL_DIR}/python3/usr/bin:${PATH}"

cd ${FETCHEDDIR} || exit $?

# [Bug#21501] Enable modules needed by AppArmor utilities (dev)
if [ "${BLD_CONFIG_SECURITY_APPARMOR_UTILS}" = "y" ]; then
	sed -i -e 's|^#\(readline readline.c .*\) -ltermcap\(.*\)|\1 -lncurses\2|' \
		Modules/Setup.dist
fi

if [ ! -f Makefile ]; then
	BUILD_PREFIX=`gcc -dumpmachine`
	cat > config.site << EOF
ac_cv_file__dev_ptmx=no
ac_cv_file__dev_ptc=no
EOF
	CFLAGS="-I${STAGING}/usr/include -I${STAGING}/usr/local/include" \
	CPPFLAGS="-I${STAGING}/usr/include -I${STAGING}/usr/local/include" \
	LDFLAGS="-L${STAGING}/usr/lib -L${STAGING}/usr/local/lib" \
	PYTHON_FOR_REGEN="${PYTHON_EXE}" \
	CONFIG_SITE=config.site \
	./configure \
		--host=${HOST_PREFIX} --build=${BUILD_PREFIX} \
		${prefix} \
		--with-openssl=${STAGING}/usr \
		--with-ssl-default-suites=openssl \
		--disable-ipv6 || exit $?
fi
make ${MAKE_OPTS} sharedmods || exit $?
