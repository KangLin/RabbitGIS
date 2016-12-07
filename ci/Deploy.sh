#!/bin/bash

set -e

#分发包到sourceforge.net  

SOURCE_DIR=`pwd`
if [ -n "$1" ]; then
    SOURCE_DIR=$1
fi

cd ${SOURCE_DIR}
if [ "${BUILD_TARGERT}" != "android" ]; then
    zip -rq RabbitGIS_${BUILD_TARGERT}${TOOLCHAIN_VERSION}_${AUTOBUILD_ARCH}_${QT_VERSION}_v${BUILD_VERSION}.zip build_${BUILD_TARGERT}
fi
expect ${SOURCE_DIR}/ci/scp.exp frs.sourceforge.net kl222,rabbitgis ${PASSWORD} RabbitGIS_${BUILD_TARGERT}${TOOLCHAIN_VERSION}_${AUTOBUILD_ARCH}_${QT_VERSION}_v${BUILD_VERSION}.zip pfs/.
