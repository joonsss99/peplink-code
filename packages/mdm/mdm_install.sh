#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf
. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ ! -d $abspath/$MNT/web/mdm ]; then
	mkdir -p $abspath/$MNT/web/mdm
fi

if [ ! -d $abspath/$MNT/web/mdm/html ]; then
	mkdir -p $abspath/$MNT/web/mdm/html
fi

if [ ! -d $abspath/$MNT/web/mdm/mdm_js ] ; then
	mkdir -p $abspath/$MNT/web/mdm/mdm_js
fi

if [ ! -d $abspath/$MNT/web/mdm/mdm_css/images ] ; then
	mkdir -p $abspath/$MNT/web/mdm/mdm_css/images
fi

cd $FETCHEDDIR/web
cp -apf html/* $abspath/$MNT/web/mdm/html/
cp -apf certs/* $abspath/$MNT/web/mdm/
cp -apf certs/mdm.default.pem $abspath/$MNT/etc/nginx/certs/
cp -apf cgibox.cgi $abspath/$MNT/web/mdm/
cp -apf api.cgi $abspath/$MNT/web/mdm/
cp -apf index.cgi $abspath/$MNT/web/mdm/
cp -apf mdm_css/* $abspath/$MNT/web/mdm/mdm_css/
cp -apf mdm_js/* $abspath/$MNT/web/mdm/mdm_js/
cp -apf mdm_images $abspath/$MNT/web/mdm/

cd $abspath/$MNT/web/mdm
ln -sf /web/mdm/cgibox.cgi mdm.cgi
ln -sf /web/mdm/cgibox.cgi mdmprofile_process.cgi
ln -sf /web/mdm/cgibox.cgi server.cgi
ln -sf /web/mdm/cgibox.cgi checkin.cgi
ln -sf /web/mdm/cgibox.cgi mdm_poll_device.cgi
ln -sf /web/mdm/cgibox.cgi connicon.cgi
ln -sf /web css
ln -sf /web/en/images icon
ln -sf /web/MANGA/images images
ln -sf /web/MANGA js

$HOST_PREFIX-strip  $abspath/$MNT/web/mdm/cgibox.cgi
$HOST_PREFIX-strip  $abspath/$MNT/web/mdm/api.cgi
$HOST_PREFIX-strip  $abspath/$MNT/web/mdm/index.cgi
