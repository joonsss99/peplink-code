#!/bin/sh

make -C ${FETCHDIR}/$1 clean || exit $?
