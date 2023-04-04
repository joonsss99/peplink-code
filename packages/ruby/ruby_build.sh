#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
STAGINGDIR=staging

. ./make.conf

abspath=`pwd`

CONFIGURE_PREFIX_OPT=
if [ "${BLD_CONFIG_MEDIAFAST_CONTENTHUB}" = "y" ]; then
	# [Bug#15462] ContentHub uses custom path prefix
	CONFIGURE_PREFIX_OPT="--prefix=/libraries/ruby"
fi

# building Ruby requires Ruby itself
# FIXME cannot pass RUBYLIB variable to --with-baseruby configure option,
#       setting baseruby as `ruby --disable-gems` does not help neither.
#       always passes RUBYLIB, hardcoded x86_64-linux for now.
RUBY_PFX="${abspath}/tools/host/ruby"
RUBY_EXE="${RUBY_PFX}/usr/local/bin/ruby"
RUBY_VERSION_XYZ=`${RUBY_EXE} --disable-gems --version | sed -n -e 's|^ruby \([0-9.]*\).*|\1|; p; q'`
RUBY_VERSION_XY=`${RUBY_EXE} --disable-gems --version | sed -n -e 's|^ruby \([0-9]*\.[0-9]*\).*|\1|; p; q'`
RUBY_LIB_VERSION="${RUBY_VERSION_XY}.0"
RUBYLIB="${RUBY_PFX}/usr/local/lib/ruby/${RUBY_LIB_VERSION}"
RUBYLIB="${RUBYLIB}:${RUBY_PFX}/usr/local/lib/ruby/${RUBY_LIB_VERSION}/x86_64-linux"
RUBY_VERSION=`RUBYLIB=${RUBYLIB} ${RUBY_EXE} -e 'print "#{ RUBY_VERSION }"'` || exit $?
[ "${RUBY_VERSION}" = "${RUBY_VERSION_XYZ}" ] || exit 1

cd ${FETCHEDDIR}
if [ ! -f "configure" ]; then
	autoconf || exit $?
fi
if [ ! -f "Makefile" ]; then
	BUILD_PREFIX=`gcc -dumpmachine`
	./configure \
		RUBYLIB="${RUBYLIB}" \
		CC=${HOST_PREFIX}-gcc \
		CXX=${HOST_PREFIX}-g++ \
		AR=${HOST_PREFIX}-ar \
		CFLAGS="-I${STAGING}/usr/include" \
		LDFLAGS="-L${STAGING}/usr/lib" \
		--build=${BUILD_PREFIX} \
		--target=${HOST_PREFIX} --host=${HOST_PREFIX} \
		--with-baseruby="${RUBY_EXE}" \
		--disable-install-doc \
		${CONFIGURE_PREFIX_OPT} || exit $?
fi
cd ${abspath}

make -C ${FETCHEDDIR} ${MAKE_OPTS} RUBYLIB="${RUBYLIB}" || exit $?
