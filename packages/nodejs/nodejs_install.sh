#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf # yes, it compiles during installation

abspath=`pwd`

#
# (Build and) Install
#
PYTHONHOME="${HOST_TOOL_DIR}/python3/usr"
PYTHON_EXE="${PYTHONHOME}/bin/python3.8"
PYTHONPATH="${PYTHONHOME}/lib/python3.8"
PYTHONHOME=${PYTHONHOME} ${PYTHON_EXE} --version || exit $?

CC=${HOST_PREFIX}-gcc \
CXX=${HOST_PREFIX}-g++ \
AR=${HOST_PREFIX}-ar \
CC_host=gcc \
CXX_host=g++ \
AR_host=ar \
CC_target=${HOST_PREFIX}-gcc \
CXX_target=${HOST_PREFIX}-g++ \
AR_target=${HOST_PREFIX}-ar \
PYTHON="PYTHONPATH=${PYTHONPATH} ${PYTHON_EXE}" \
DESTDIR=${abspath}/tmp/contenthub_packages \
make -C ${FETCHEDDIR} ${MAKE_OPTS} install || exit $?

#
# Create .cfg file for contenthub_packager
#
CHUB_PKGS_DIR="${abspath}/tmp/contenthub_packages"
NODEJS_DEST_CFG="${CHUB_PKGS_DIR}/nodejs.cfg"
NODEJS_VERSION_XYZ=`PYTHONPATH=${PYTHONPATH} ${PYTHON_EXE} ${FETCHEDDIR}/tools/getnodeversion.py`
cat > "${NODEJS_DEST_CFG}" << EOF
NAME="nodejs"
FULLNAME="Node.js"
VERSION_NAME="${NODEJS_VERSION_XYZ}"
ENVIRONMENT="PATH:<MOUNTPOINT>/bin"
ENVIRONMENT="NODE_PATH:<MOUNTPOINT>/lib/node_modules"
EOF
