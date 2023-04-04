#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

for i in \
	usr/lib \
	usr/local/samba/private \
	var/run/samba/cores/nmbd \
	var/run/samba/cores/smbd \
	var/run/samba/locks \
	var/run/samba/private \
; do
	mkdir -p $abspath/$MNT/$i || exit $?
done

cd ${FETCHEDDIR} || exit $?
install --mode=644 -D smb.conf.pepos \
	"${abspath}/${MNT}/etc/smb.conf" || exit $?

cd source3/bin || exit $?
install -s --strip-program=${HOST_PREFIX}-strip \
	--mode=755 -D -t "${abspath}/${MNT}/sbin" \
	net \
	nmbd \
	ntlm_auth \
	smbd \
	winbindd \
	|| exit $?
install -s --strip-program=${HOST_PREFIX}-strip \
	-D -t "${abspath}/${MNT}/usr/local/samba/lib/charset" \
	CP437.so \
	CP850.so \
	|| exit $?
for i in libtalloc libtdb libtevent libwbclient; do
	cp -dpf $i.so* $abspath/$MNT/usr/lib/ || exit $?
	${HOST_PREFIX}-strip $abspath/$MNT/usr/lib/$i.so* || exit $?
done
