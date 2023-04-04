#!/bin/sh

# script to check whether timezone file exists
#
# tzcheck.sh <path-to-check> 
#
# path-to-check should be location where zoneinfo is (/usr/share/) or e.g. glibc_timezone/zoneinfo
#
# The script will also return error if any of the files are missing. no error when no missing.
#

zoneinfo_path=$1
tzlist="`$BALANCE_WEB_DIR/libtimezone/pepos-tz-list`"
missing=0

echo "Checking for missing timezone file"

for i in $tzlist ; do
	if [ ! -e $zoneinfo_path/$i ] ; then
		echo "  $zoneinfo_path/$i missing"
		missing=1
	fi
done

if [ $missing -eq 0 ] ; then
	echo "timezone file check OK"
fi

exit $missing

