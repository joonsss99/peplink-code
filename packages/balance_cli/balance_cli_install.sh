#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

abspath=`pwd`

fmk="-f $PROJECT_MAKE/Makefile"

make $fmk -C $FETCHEDDIR CROSS_COMPILE=$HOST_PREFIX- DESTDIR=$abspath/$MNT PREFIX=/usr/local/ilink install || exit $?

xmluser=etc/cli/xmls/user
xmladmin=etc/cli/xmls/admin
mkdir -p $abspath/$MNT/$xmluser
mkdir -p $abspath/$MNT/$xmladmin

for i in $(cd $abspath/$MNT/etc/cli/xmls/common; ls *.xml | grep -v info-mode); do
	rm -f $abspath/$MNT/$xmluser/$i $abspath/$MNT/$xmladmin/$i
	ln -s ../common/$i $abspath/$MNT/$xmluser/$i
	ln -s ../common/$i $abspath/$MNT/$xmladmin/$i
done
rm -f $abspath/$MNT/$xmladmin/info-mode.xml
rm -f $abspath/$MNT/$xmluser/info-mode.xml
ln -s ../common/info-mode.admin.xml $abspath/$MNT/$xmladmin/info-mode.xml
ln -s ../common/info-mode.user.xml $abspath/$MNT/$xmluser/info-mode.xml

mkdir -p $abspath/$MNT/usr/sbin
rm -f $abspath/$MNT/usr/sbin/sshd_cli
ln -s sshd $abspath/$MNT/usr/sbin/sshd_cli
