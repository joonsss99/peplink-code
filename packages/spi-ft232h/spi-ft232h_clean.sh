#!/bin/sh

make -C ${FETCHDIR}/$1 O=$KERNEL_OBJ KDIR=$KERNEL_OBJ clean || exit $?
