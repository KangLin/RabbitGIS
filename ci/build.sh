#!/bin/bash
set -ev

if [ "$BUILD_TARGERT" = "windows_mingw" \
    -a -n "$APPVEYOR" ]; then
    export PATH=/C/Qt/Tools/mingw${TOOLCHAIN_VERSION}_32/bin:$PATH
fi

SOURCE_DIR=`pwd`
if [ -n "$1" ]; then
    SOURCE_DIR=$1
fi

SCRIPT_DIR=${SOURCE_DIR}/build_script
if [ -d ${SOURCE_DIR}/ThirdLibrary/build_script ]; then
    SCRIPT_DIR=${SOURCE_DIR}/ThirdLibrary/build_script
fi
cd ${SCRIPT_DIR}
SOURCE_DIR=${SCRIPT_DIR}/../src

#下载预编译库
if [ -n "$DOWNLOAD_FILE" ]; then
   echo "wget -q -c -O ${SCRIPT_DIR}/../${BUILD_TARGERT}.zip ${DOWNLOAD_FILE}"
   wget -q -c -O ${SCRIPT_DIR}/../${BUILD_TARGERT}.zip ${DOWNLOAD_FILE}
   unzip -q ${SCRIPT_DIR}/../${BUILD_TARGERT}.zip -d ${SCRIPT_DIR}/../${BUILD_TARGERT}
   if [ "$PROJECT_NAME" != "RabbitThirdLIbrary" \
        -a "$BUILD_TARGERT" != "windows_msvc" \
        -a -f "${SCRIPT_DIR}/../${BUILD_TARGERT}/change_prefix.sh" ]; then
       bash ${SCRIPT_DIR}/../${BUILD_TARGERT}/change_prefix.sh
   fi
fi

if [ "$BUILD_TARGERT" = "android" ]; then
    export ANDROID_SDK_ROOT=${SCRIPT_DIR}/../Tools/android-sdk
    export ANDROID_NDK_ROOT=${SCRIPT_DIR}/../Tools/android-ndk
    if [ -z "$APPVEYOR" ]; then
        export JAVA_HOME="/C/Program Files (x86)/Java/jdk1.8.0"
    fi
    export QT_ROOT=${SCRIPT_DIR}/../Tools/Qt/${QT_VERSION}/${QT_VERSION_DIR}/android_armv7
    if [ "${QT_VERSION}" = "5.2.1" ]; then
        export QT_ROOT=${SCRIPT_DIR}/../Tools/Qt/${QT_VERSION}/android_armv7
    fi
    export PATH=${SCRIPT_DIR}/../Tools/apache-ant/bin:$JAVA_HOME:$PATH
fi
if [ "$BUILD_TARGERT" != "windows_msvc" ]; then
    RABBIT_MAKE_JOB_PARA="-j`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`"  #make 同时工作进程参数
    if [ "$RABBIT_MAKE_JOB_PARA" = "-j1" ];then
            RABBIT_MAKE_JOB_PARA="-j2"
    fi
    export RABBIT_MAKE_JOB_PARA
fi

bash build_RabbitGIS.sh