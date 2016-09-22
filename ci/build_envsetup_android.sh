#注意：修改后的本文件不要上传代码库中

#bash用法：  
#   在用一sh进程中执行脚本script.sh:
#   source script.sh
#   . script.sh
#   注意这种用法，script.sh开头一行不能包含 #!/bin/sh
#   相当于包含关系

#   新建一个sh进程执行脚本script.sh:
#   sh script.sh
#   ./script.sh
#   注意这种用法，script.sh开头一行必须包含 #!/bin/sh  

#需要设置下面变量，也可以把它们设置在环境变量中：  
#export JAVA_HOME="/C/Program Files/Java/jdk1.7.0_51"             #指定 jdk 根目录  
#export ANDROID_SDK_ROOT=/D/software/android-sdk-windows     #指定 android sdk 根目录,在msys2下需要注意路径符号："/"  
#export ANDROID_NDK_ROOT=/D/software/android-ndk-r10e   #指定 android ndk 根目录  
export ANDROID_NDK=$ANDROID_NDK_ROOT            #指定 android ndk 根目录  
export ANDROID_SDK=$ANDROID_SDK_ROOT
export ANDROID_NDK_ABI_NAME=armeabi-v7a 

#ANT=/usr/bin/ant         #ant 程序  
#QT_ROOT=/c/Qt/Qt5.7.0/5.7/android_armv7       #QT 安装根目录,默认为:${RabbitGISRoot}/ThirdLibrary/android/qt  
JOM=make #/c/Qt/Qt5.3.1/Tools/QtCreator/bin/jom   #设置 QT make 工具 JOM  
if [ -z "$RABBITGIS_CLEAN" ]; then
    RABBITGIS_CLEAN=TRUE #编译前清理  
fi
RABBITGIS_BUILD_STATIC="static" #设置编译静态库，注释掉，则为编译动态库  
#RABBITGIS_USE_REPOSITORIES="FALSE" #下载指定的压缩包。省略，则下载开发库。  
#RABBITGIS_BUILD_TOOLCHAIN_VERSION=4.8   #工具链版本号,默认 4.8  
#RABBITGIS_BUILD_PLATFORMS_VERSION=16   #android ndk api (平台)版本号,默认 18
if [ -z "${RABBITGIS_MAKE_JOB_PARA}" ]; then
    RABBITGIS_MAKE_JOB_PARA="-j`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`"  #make 同时工作进程参数
    if [ "$RABBITGIS_MAKE_JOB_PARA" = "-j1" ];then
        RABBITGIS_MAKE_JOB_PARA=
    fi
fi

if [ -z "$ANDROID_NDK_ROOT" -o -z "$ANDROID_NDK" -o -z "$ANDROID_SDK" -o -z "$ANDROID_SDK_ROOT"	-o -z "$JAVA_HOME" ]; then
    echo "Please set ANDROID_NDK_ROOT and ANDROID_NDK and ANDROID_SDK and ANDROID_SDK_ROOT and JAVA_HOME"
    exit 1
fi

#安装前缀  
if [ -n "${RabbitGISRoot}" ]; then
    RABBITGIS_BUILD_PREFIX=${RabbitGISRoot}/ThirdLibrary/android
else
    RABBITGIS_BUILD_PREFIX=`pwd`/../android    #修改这里为安装前缀  
fi

if [ ! -d ${RABBITGIS_BUILD_PREFIX} ]; then
    mkdir -p ${RABBITGIS_BUILD_PREFIX}
fi
if [ -z "${THIRD_LIBRARY_PATH}" ]; then
    export THIRD_LIBRARY_PATH=${RABBITGIS_BUILD_PREFIX}
fi

if [ -z "$RABBITGIS_USE_REPOSITORIES" ]; then
    RABBITGIS_USE_REPOSITORIES="TRUE" #下载开发库。省略，则下载指定的压缩包  
fi

#设置qt安装位置
if [ -z "$QT_ROOT" -a -d "${RABBITGIS_BUILD_PREFIX}/qt" ]; then
    QT_ROOT=${RABBITGIS_BUILD_PREFIX}/qt
fi
QMAKE=qmake
if [ -n "${QT_ROOT}" ]; then
    QT_BIN=${QT_ROOT}/bin       #设置用于 android 平台编译的 qt bin 目录  
    QMAKE=${QT_BIN}/qmake       #设置用于 unix 平台编译的 QMAKE。
                            #这里设置的是自动编译时的配置，你需要修改为你本地qt编译环境的配置.
fi

MAKE="make ${RABBITGIS_MAKE_JOB_PARA}"
#自动判断主机类型，目前只做了linux、windows判断
TARGET_OS=`uname -s`
case $TARGET_OS in
    MINGW* | CYGWIN* | MSYS*)
        RABBITGIS_BUILD_HOST="windows"
        #RABBITGIS_CMAKE_MAKE_PROGRAM=$ANDROID_NDK/prebuilt/${RABBITGIS_BUILD_HOST}/bin/make #这个用不着，只有在windows命令行下才有用 
        GENERATORS="MSYS Makefiles"
        ;;
    Linux* | Unix*)
        RABBITGIS_BUILD_HOST="linux-`uname -m`"    #windows、linux-x86_64
        GENERATORS="Unix Makefiles" 
        ;;
    *)
    echo "Please set RABBITGIS_BUILD_HOST. see build_envsetup_android.sh"
    return 2
    ;;
esac

if [ -z "${RABBITGIS_BUILD_TOOLCHAIN_VERSION}" ]; then
    RABBITGIS_BUILD_TOOLCHAIN_VERSION=4.8  #工具链版本号  
fi
if [ -z "${RABBITGIS_BUILD_PLATFORMS_VERSION}" ]; then
    RABBITGIS_BUILD_PLATFORMS_VERSION=18    #android ndk api (平台)版本号  
fi

RABBITGIS_BUILD_CROSS_ROOT=$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-${RABBITGIS_BUILD_TOOLCHAIN_VERSION}/prebuilt/${RABBITGIS_BUILD_HOST}
#交叉编译前缀 
RABBITGIS_BUILD_CROSS_PREFIX=${RABBITGIS_BUILD_CROSS_ROOT}/bin/arm-linux-androideabi-
#交叉编译平台的 sysroot 
RABBITGIS_BUILD_CROSS_SYSROOT=$ANDROID_NDK_ROOT/platforms/android-${RABBITGIS_BUILD_PLATFORMS_VERSION}/arch-arm
if [ -z "${RABBITGIS_BUILD_CROSS_HOST}" ]; then
    RABBITGIS_BUILD_CROSS_HOST=arm-linux-androideabi
fi
RABBITGIS_BUILD_CROSS_STL=${ANDROID_NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/${RABBITGIS_BUILD_TOOLCHAIN_VERSION}
RABBITGIS_BUILD_CROSS_STL_INCLUDE=${RABBITGIS_BUILD_CROSS_STL}/include
RABBITGIS_BUILD_CROSS_STL_LIBS=${RABBITGIS_BUILD_CROSS_STL}/libs
RABBITGIS_BUILD_CROSS_STL_INCLUDE_FLAGS="-I${RABBITGIS_BUILD_CROSS_STL_INCLUDE} -I${RABBITGIS_BUILD_CROSS_STL_LIBS}/${ANDROID_NDK_ABI_NAME}/include"

export ANDROID_API_VERSION=android-${RABBITGIS_BUILD_PLATFORMS_VERSION}
export PATH=${QT_BIN}:$PATH
#pkg-config帮助文档：http://linux.die.net/man/1/pkg-config
export PKG_CONFIG="pkg-config"
export PKG_CONFIG_PATH=${RABBITGIS_BUILD_PREFIX}/lib/pkgconfig
export PKG_CONFIG_LIBDIR=${PKG_CONFIG_PATH}
export PKG_CONFIG_SYSROOT_DIR=${RABBITGIS_BUILD_PREFIX}

echo "---------------------------------------------------------------------------"
echo "ANDROID_SDK:$ANDROID_SDK"
echo "ANDROID_SDK_ROOT:$ANDROID_SDK_ROOT"
echo "ANDROID_NDK:$ANDROID_NDK"
echo "ANDROID_NDK_ROOT:$ANDROID_NDK_ROOT"
echo "ANDROID_NDK_ABI_NAME:$ANDROID_NDK_ABI_NAME"
echo "RABBITGIS_BUILD_PREFIX:$RABBITGIS_BUILD_PREFIX"
echo "RABBITGIS_BUILD_TOOLCHAIN_VERSION:$RABBITGIS_BUILD_TOOLCHAIN_VERSION"
echo "RABBITGIS_BUILD_PLATFORMS_VERSION:$RABBITGIS_BUILD_PLATFORMS_VERSION"
echo "RABBITGIS_BUILD_CROSS_ROOT:$RABBITGIS_BUILD_CROSS_ROOT"
echo "RABBITGIS_BUILD_CROSS_STL:$RABBITGIS_BUILD_CROSS_STL"
echo "ANDROID_API_VERSION:$ANDROID_API_VERSION"
echo "QT_ROOT:$QT_ROOT"
echo "PKG_CONFIG_PATH:$PKG_CONFIG_PATH"
echo "PKG_CONFIG_SYSROOT_DIR:$PKG_CONFIG_SYSROOT_DIR"
echo "---------------------------------------------------------------------------"
