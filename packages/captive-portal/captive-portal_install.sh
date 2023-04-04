#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/captive-portal

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

cd ${FETCHEDDIR}
mkdir -p $abspath/$MNT/web/guest
cp -f cgibox.cgi $abspath/$MNT/web/guest/ || exit $?
$HOST_PREFIX-strip $abspath/$MNT/web/guest/cgibox.cgi || exit $?
for dir in js:js css:css build_html:html; do
	mkdir -p $abspath/$MNT/web/guest/${dir##*:}
	cp -pPRf ${dir%%:*}/* $abspath/$MNT/web/guest/${dir##*:} || exit $?
done
mkdir -p $abspath/$MNT/usr/local/manga/conf
cp -f portal.def $abspath/$MNT/usr/local/manga/conf/ || exit $?
cp -f portal.oem.def $abspath/$MNT/usr/local/manga/conf/ || exit $?
cd $abspath/$MNT/web/guest/
ln -sf /web/MANGA/jquery.js js/jquery.js
ln -sf /web/css/font-awesome.css css/font-awesome.css
ln -sf /web/en/images images
mkdir -p webfonts
ln -sf /web/webfonts/fa-brands-400.woff webfonts/fa-brands-400.woff
ln -sf /web/webfonts/fa-brands-400.woff2 webfonts/fa-brands-400.woff2
ln -sf /web/webfonts/fa-regular-400.woff webfonts/fa-regular-400.woff
ln -sf /web/webfonts/fa-regular-400.woff2 webfonts/fa-regular-400.woff2
ln -sf /web/webfonts/fa-solid-900.woff webfonts/fa-solid-900.woff
ln -sf /web/webfonts/fa-solid-900.woff2 webfonts/fa-solid-900.woff2
ln -sf cgibox.cgi auth.cgi
ln -sf cgibox.cgi login.cgi
ln -sf cgibox.cgi logo.cgi
ln -sf cgibox.cgi logoff.cgi
ln -sf cgibox.cgi logon.cgi
ln -sf cgibox.cgi json_status.cgi
ln -sf cgibox.cgi json_logon.cgi
ln -sf cgibox.cgi json_logoff.cgi
ln -sf cgibox.cgi portal.cgi
ln -sf cgibox.cgi preview.cgi
ln -sf cgibox.cgi redirect.cgi
ln -sf cgibox.cgi success.cgi
ln -sf cgibox.cgi portal_cdn.cgi
ln -sf cgibox.cgi subscription.cgi
ln -sf cgibox.cgi subscription_success.cgi
ln -sf cgibox.cgi api.cgi
ln -sf cgibox.cgi portal_admin_upload.cgi
ln -sf /var/run/portal/cache $abspath/$MNT/web/guest/cdn

