#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

mkdir -p $abspath/$MNT/etc/nginx
cd $FETCHEDDIR
tar cf - * | (cd $abspath/$MNT/etc/nginx/ ; tar xf - )
# we shouldn't allow other people to read our keys (certs should be ok, but why not?)
chmod 640 $abspath/$MNT/etc/nginx/certs/*
