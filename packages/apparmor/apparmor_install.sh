#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

cd ${FETCHEDDIR} || exit $?

TOOLS="parser/apparmor_parser"
install -s --strip-program=${HOST_PREFIX}-strip \
	-D -t "${abspath}/${MNT}/sbin" \
	${TOOLS} \
	|| exit $?

if [ "${BLD_CONFIG_SECURITY_APPARMOR_UTILS}" = "y" ]; then
	PYTOOLS="aa-easyprof aa-genprof aa-logprof aa-cleanprof aa-mergeprof
		aa-autodep aa-audit aa-complain aa-enforce aa-disable
		aa-status aa-unconfined"
	cd utils || exit $?
	install -D -t "${abspath}/${MNT}/sbin" ${PYTOOLS} || exit $?
	cd - || exit $?
fi

mkdir -p "${abspath}/${MNT}/usr/lib" || exit $?
cp -dpf libraries/libapparmor/src/.libs/libapparmor.so* \
	"${abspath}/${MNT}/usr/lib" || exit $?
${HOST_PREFIX}-strip ${abspath}/${MNT}/usr/lib/libapparmor.so* || exit $?

# /etc/apparmor

CONFS="parser/parser.conf"
if [ "${BLD_CONFIG_SECURITY_APPARMOR_UTILS}" = "y" ]; then
	CONFS="${CONFS} utils/logprof.conf utils/severity.db"
fi
install -D -t "${abspath}/${MNT}/etc/apparmor" ${CONFS} || exit $?

# /etc/apparmor.d

ABSTRACTIONS="apparmor_api authentication
	base
	consoles cups-client
	dbus*
	kerberosclient
	ldapclient likewise
	mdns
	nameservice nis
	openssl
	p11-kit php php5 postfix-common python
	ruby
	samba smbpass ssl_*
	winbind"
TUNABLES="alias apparmorfs
	global
	home home.d
	kernelvars
	multiarch multiarch.d
	ntpd
	proc
	securityfs share sys
	xdg-user-dirs xdg-user-dirs.d"
mkdir -p "${abspath}/${MNT}/etc/apparmor.d/abstractions" \
	"${abspath}/${MNT}/etc/apparmor.d/local" \
	"${abspath}/${MNT}/etc/apparmor.d/tunables" \
	|| exit $?
cd profiles/apparmor.d/abstractions \
	&& cp -dpRf ${ABSTRACTIONS} \
		"${abspath}/${MNT}/etc/apparmor.d/abstractions/" \
	&& cd - || exit $?
cd profiles/apparmor.d/tunables \
	&& cp -dpRf ${TUNABLES} \
		"${abspath}/${MNT}/etc/apparmor.d/tunables/" \
	&& cd - || exit $?

# /var/cache/apparmor
mkdir -p "${abspath}/${MNT}/var/cache/apparmor"
