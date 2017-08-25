#!/bin/bash
set -ev

if [ "$BUILD_TARGERT" = "windows_mingw" \
    -a -n "$APPVEYOR" ]; then
    export PATH=/C/Qt/Tools/mingw${TOOLCHAIN_VERSION}_32/bin:$PATH    
fi
export PKG_CONFIG=/c/msys64/mingw32/bin/pkg-config.exe

PROJECT_DIR=`pwd`
if [ -n "$1" ]; then
    PROJECT_DIR=$1
fi

cd ${PROJECT_DIR}
THIRDLIBRARY_DIR=${PROJECT_DIR}/ThirdLibrary
THIRD_LIBRARY_PATH=${THIRDLIBRARY_DIR}/${BUILD_TARGERT}
mkdir -p ${THIRDLIBRARY_DIR}

#下载预编译库
if [ -n "$DOWNLOAD_FILE" ]; then
   echo "wget -q -c -O ${THIRD_LIBRARY_PATH}.tar.gz ${DOWNLOAD_FILE}"
   wget -q -c -O ${THIRD_LIBRARY_PATH}.tar.gz ${DOWNLOAD_FILE}
   tar xzf ${THIRD_LIBRARY_PATH}.tar.gz -C ${THIRDLIBRARY_DIR}
   if [ "$PROJECT_NAME" != "RabbitThirdLibrary" \
        -a "$BUILD_TARGERT" != "windows_msvc" \
        -a -f "${THIRD_LIBRARY_PATH}/change_prefix.sh" ]; then
       cd ${THIRD_LIBRARY_PATH}
       echo "./change_prefix.sh /c/projects/rabbitthirdlibrary/build_script/../$BUILD_TARGERT `pwd`"
       ./change_prefix.sh /c/projects/rabbitthirdlibrary/build_script/../$BUILD_TARGERT `pwd`
       cd ${PROJECT_DIR}
   fi
fi

if [ "$BUILD_TARGERT" = "android" ]; then
    export ANDROID_SDK_ROOT=${PROJECT_DIR}/Tools/android-sdk
    export ANDROID_NDK_ROOT=${PROJECT_DIR}/Tools/android-ndk
    if [ -z "$APPVEYOR" ]; then
        export JAVA_HOME="/C/Program Files (x86)/Java/jdk1.8.0"
    fi
    export QT_ROOT=${PROJECT_DIR}/Tools/Qt/${QT_VERSION}/${QT_VERSION_DIR}/android_armv7
    if [ "${QT_VERSION}" = "5.2.1" ]; then
        export QT_ROOT=${PROJECT_DIR}/Tools/Qt/${QT_VERSION}/android_armv7
    fi
    export PATH=${PROJECT_DIR}/Tools/apache-ant/bin:$JAVA_HOME:$PATH
fi
if [ "$BUILD_TARGERT" != "windows_msvc" ]; then
    RABBIT_MAKE_JOB_PARA="-j`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`"  #make 同时工作进程参数
    if [ "$RABBIT_MAKE_JOB_PARA" = "-j1" ];then
        RABBIT_MAKE_JOB_PARA="-j2"
    fi
    export RABBIT_MAKE_JOB_PARA
fi

cd ${PROJECT_DIR}

mkdir -p build_${BUILD_TARGERT}
cd build_${BUILD_TARGERT}
 
echo "qmake ...."
QMAKE=${QT_ROOT}/bin/qmake 
MAKE=make
case ${BUILD_TARGERT} in
    windows_msvc)
        MAKE=nmake
        ;;
    windows_mingw)
        if [ "${RABBIT_BUILD_HOST}"="windows" ]; then
            MAKE=mingw32-make
        fi
        ;;
    *)
        MAKE=make
        ;;
esac

$QMAKE ../RabbitGIS.pro "CONFIG+=release"  \
       THIRD_LIBRARY_PATH=$THIRD_LIBRARY_PATH
echo "$MAKE install ...."
if [ "${BUILD_TARGERT}" == "android" ]; then
    $MAKE -f Makefile install INSTALL_ROOT="`pwd`/android-build"
    ${QT_ROOT}/bin/androiddeployqt --input "`pwd`/android-libRabbitGISApp.so-deployment-settings.json" --output "`pwd`/android-build" --verbose
else
    $MAKE -f Makefile
    echo "$MAKE install ...."
    $MAKE install
fi
