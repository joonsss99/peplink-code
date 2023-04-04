#!/bin/sh

cpu_cnt=`nproc 2> /dev/null`;

if [ "$cpu_cnt" != "" ]; then
	sed -i "s/MAKE_OPTS=\"-j.*\"/MAKE_OPTS=\"-j$((cpu_cnt+1))\"/g" ${TOP}/make.conf
fi
