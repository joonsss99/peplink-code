#!/bin/sh

if [ ! -d "${TOP_PREBUILT_IM}" -a -n "${BLD_CONFIG_PREBUILT_IMPORT_LINK}" ]; then
	wget --reject="index.html*" -r -np -nd -P ${TOP_PREBUILT_IM} ${BLD_CONFIG_PREBUILT_IMPORT_LINK}/${BUILD_TARGET}/latest/ || exit 1
fi

[ ! -d "${TOP_PREBUILT_IM}" ] && exit 1

mkdir -p ${STAGING}
mkdir -p ${MNT}/tmp/var
mkdir -p ${MNT}/tmp/etc
ln -sf tmp/etc ${MNT}/etc
ln -sf tmp/var ${MNT}/var

prj_list=`ls ${TOP_PREBUILT_IM}`
for prj in $prj_list ; do
	tar -xzf ${TOP_PREBUILT_IM}/$prj -C ${TOP} || exit $?
done
