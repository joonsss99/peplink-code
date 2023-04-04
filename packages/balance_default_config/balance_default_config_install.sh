#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}
FETCHEDDIR_CONFIG=${FETCHDIR}/${PACKAGE}/build_config

. ${PACKAGESDIR}/common/common_functions

abspath=`pwd`

if [ ${BUILD_TARGET} = "maxotg" ]; then
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMAXOTG* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMMKT* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMSOHO* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMAXBR1* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1ES* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1L* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1M* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1P* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1S* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMAXBR2* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR2P* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMUBR* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMAXBR4* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMSOHOB* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMOD* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMOE* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMSFE* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMAXTM* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PXPMUL* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PXPDU* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PLIT* ${abspath}/${MNT}/usr/local/manga/conf/
elif [ ${BUILD_TARGET} = "maxbr1ac" ]; then
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1G* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMHSP* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMSOHO3* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMOD* ${abspath}/${MNT}/usr/local/manga/conf/
elif [ ${BUILD_TARGET} = "maxdcs" ]; then
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMDCS* ${abspath}/${MNT}/usr/local/manga/conf/
elif [ ${BUILD_TARGET} = "maxbr1" ]; then
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMAXBR1* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1M* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1P* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMBR1S* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMAXBR2* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMAXBR4* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMSOHOB* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PWMOD* ${abspath}/${MNT}/usr/local/manga/conf/
elif [ ${BUILD_TARGET} = "balance310" ]; then
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PLB210B* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PLB310B* ${abspath}/${MNT}/usr/local/manga/conf/
elif [ ${BUILD_TARGET} = "plsw" ]; then
    cp -f ${FETCHEDDIR_CONFIG}/config.def.PLSW* ${abspath}/${MNT}/usr/local/manga/conf/
elif [ ${BUILD_TARGET} = "aponeac" ]; then
    cp -f ${FETCHEDDIR_CONFIG}/config.def.AP1ENT* ${abspath}/${MNT}/usr/local/manga/conf/
    cp -f ${FETCHEDDIR_CONFIG}/config.def.AP1RUG* ${abspath}/${MNT}/usr/local/manga/conf/
elif [ ${BUILD_TARGET} = "sfchn" ]; then
    cp -f ${FETCHEDDIR_CONFIG}/config.def.SFCHN* ${abspath}/${MNT}/usr/local/manga/conf/
else
	make -C ${FETCHEDDIR} BUILD_PATH=${abspath}/${MNT} install 
fi

if [ "${PL_BUILD_ARCH}" = "x86" -o "${PL_BUILD_ARCH}" = "x86_64" ]; then
	rm -f ${abspath}/${MNT}/usr/local/manga/conf/config.def
fi

