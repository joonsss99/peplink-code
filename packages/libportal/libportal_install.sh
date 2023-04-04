#!/bin/sh

PACKAGE=$1

. ${PACKAGESDIR}/common/common_functions

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

mkdir -p $abspath/$MNT/usr/local/ilink/bin/
cp -pPf $abspath/${FETCHEDDIR}/portal $abspath/$MNT/usr/local/ilink/bin/ || exit $?
cp -pPf $abspath/${FETCHEDDIR}/script/portal_ic2_cache.sh $abspath/$MNT/usr/local/ilink/bin/ || exit $?
cp -pPf $abspath/${FETCHEDDIR}/script/portal_coova_hotspotsystem_hc.sh $abspath/$MNT/usr/local/ilink/bin/ || exit $?

adproxy_path=$abspath/$MNT/web/adproxy
mkdir -p $adproxy_path/cgi
install -s --strip-program=${HOST_PREFIX}-strip \
	$abspath/${FETCHEDDIR}/adproxy/cgi/cgibox.cgi \
	$adproxy_path/cgi/ || exit $?
ln -snf cgibox.cgi $adproxy_path/cgi/cookie_get.cgi
ln -snf cgibox.cgi $adproxy_path/cgi/cookie_set.cgi
ln -snf cgibox.cgi $adproxy_path/cgi/device_info.cgi
ln -snf /var/run/ilink/adproxy/ad $adproxy_path/ad
