#!/bin/sh

MODE=""
VERSION=""

usage () {
echo "Usage: $0 [-d|-v version [-f]] [-t version]
         -d: Print current build number
         -v: Print version in format \"version build BUILD_NUMBER\"
         -t: Print version and date in Pepwave TAG format"
}

ARGV=`getopt "dv:ft:" "$*"`
if [ -z $? ]; then
   usage
   exit 1
fi
set -- $ARGV
while [ ! -z "$1" ]; do
   case "$1" in
   	-d) MODE="PDATE"
	    ;;
	-v) 
	    if [ "$MODE" != "" ]; then
	    	usage
		exit 1
	    fi
	    MODE="PVERSION"
	    VERSION="$2"
	    shift
	    ;;
	-f) 
	    if [ "$MODE" != "PVERSION" ]; then
	    	usage
		exit 1
	    fi
	    MODE="PFVERSION"
	    shift
	    ;;
	-t)
	    version=$2
	    date +$version%%%y%m%d%%%H%M%S
	    exit 0
	    ;;
	--)
	    break
	    ;;
	*)  usage
	    exit 1
	    ;;
   esac
   shift
done

#BUILD_DATE=`/usr/bin/rdate -s 210.0.235.14 ; /bin/date +%y%m%d%H%M%S`
BUILD_DATE=`cat ${abspath}/plb.bno`

case "$MODE" in
PDATE)
	echo -n "$BUILD_DATE"
	;;
PVERSION)
	echo -n "v$VERSION build $BUILD_DATE"
	;;
PFVERSION)
	echo -n "v$VERSION"
	;;
*)
	usage
esac

