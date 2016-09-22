#!/bin/bash
set -ev

if [  "$BUILD_TARGERT" = "windows_mingw" ]; then
    export PATH=/C/Qt/Tools/mingw${toolchain_version}_32/bin:$PATH
    export LIBRARY_PATH=/C/Qt/Tools/mingw${toolchain_version}_32/i686-w64-mingw32/lib:$LIBRARY_PATH
    export LDLIBRARY_PATH=/C/Qt/Tools/mingw${toolchain_version}_32/i686-w64-mingw32/lib:$LIBRARY_PATH
fi

SOURCE_DIR=`pwd`
if [ -n "$1" ]; then
    SOURCE_DIR=$1
fi
SCRIPT_DIR=${SOURCE_DIR}/ci
cd ${SCRIPT_DIR}
SOURCE_DIR=${SCRIPT_DIR}/../src

#下载预编译库
if [ -n "$DOWNLOAD_FILE" ]; then
   echo "wget -q -c -O ${SCRIPT_DIR}/../${BUILD_TARGERT}.zip ${DOWNLOAD_FILE}"
   wget -q -c -O ${SCRIPT_DIR}/../${BUILD_TARGERT}.zip ${DOWNLOAD_FILE}
   unzip -q ${SCRIPT_DIR}/../${BUILD_TARGERT}.zip -d ${SCRIPT_DIR}/../${BUILD_TARGERT}
   if [ "$APPVEYOR_PROJECT_NAME" != "rabbitim-third-library" and  "$BUILD_TARGERT" != "windows_msvc" ]; then
       bash ${SCRIPT_DIR}/../${BUILD_TARGERT}/change_prefix.sh
   fi
fi

if [ "$BUILD_TARGERT" = "android" ]; then
    export ANDROID_SDK_ROOT=${SCRIPT_DIR}/../Tools/android-sdk
    export ANDROID_NDK_ROOT=${SCRIPT_DIR}/../Tools/android-ndk
    export JAVA_HOME="/C/Program Files (x86)/Java/jdk1.8.0"
    export QT_ROOT=${SCRIPT_DIR}/../Tools/Qt/${QT_VERSION}/${QT_VERSION_DIR}/android_armv7
    if [ "${QT_VERSION}" = "5.2.1" ]; then
        export QT_ROOT=${SCRIPT_DIR}/../Tools/Qt/${QT_VERSION}/android_armv7
    fi
    export PATH=${SCRIPT_DIR}/../Tools/apache-ant/bin:$JAVA_HOME:$PATH
fi
if [ "$BUILD_TARGERT" = "windows_mingw" ]; then
    RABBITIM_MAKE_JOB_PARA="-j`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`"  #make 同时工作进程参数
    if [ "$RABBITIM_MAKE_JOB_PARA" = "-j1" ];then
            RABBITIM_MAKE_JOB_PARA="-j2"
    fi
    export RABBITIM_MAKE_JOB_PARA
fi

./build_RabbitGIS.sh ${BUILD_TARGERT}
