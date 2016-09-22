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

#需要设置下面变量：
#QT_ROOT=/home/l/Qt5.6.0/5.6/gcc_64  #QT 安装根目录,默认为:${RabbitGISRoot}/ThirdLibrary/unix/qt
JOM=${MAKE} #设置 QT make 工具 JOM
if [ -z "$RABBITGIS_CLEAN" ]; then
    RABBITGIS_CLEAN=TRUE #编译前清理
fi
#RABBITGIS_BUILD_STATIC="static" #设置编译静态库，注释掉，则为编译动态库
#RABBITGIS_USE_REPOSITORIES="FALSE" #下载指定的压缩包。省略，则下载开发库。
if [ -z "${RABBITGIS_MAKE_JOB_PARA}" ]; then
    RABBITGIS_MAKE_JOB_PARA="-j`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`"  #make 同时工作进程参数
    if [ "$RABBITGIS_MAKE_JOB_PARA" = "-j1" ];then
        RABBITGIS_MAKE_JOB_PARA=
    fi
fi
MAKE="make ${RABBITGIS_MAKE_JOB_PARA}"
#   RABBITGIS_BUILD_PREFIX=`pwd`/../${RABBITGIS_BUILD_TARGERT}  #修改这里为安装前缀
#   RABBITGIS_BUILD_CROSS_PREFIX     #交叉编译前缀
#   RABBITGIS_BUILD_CROSS_SYSROOT  #交叉编译平台的 sysroot

if [ -n "${RabbitGISRoot}" ]; then
    RABBITGIS_BUILD_PREFIX=${RabbitGISRoot}/ThirdLibrary/unix
else
    RABBITGIS_BUILD_PREFIX=`pwd`/../unix    #修改这里为安装前缀 
fi
if [ "$RABBITGIS_BUILD_STATIC" = "static" ]; then
    RABBITGIS_BUILD_PREFIX=${RABBITGIS_BUILD_PREFIX}_static
fi
if [ ! -d ${RABBITGIS_BUILD_PREFIX} ]; then
    mkdir -p ${RABBITGIS_BUILD_PREFIX}
fi

if [ -z "$RABBITGIS_USE_REPOSITORIES" ]; then
    RABBITGIS_USE_REPOSITORIES="TRUE" #下载开发库。省略，则下载指定的压缩包
fi

if [ -z "$QT_ROOT" -a -d "${RABBITGIS_BUILD_PREFIX}/qt" ]; then
    QT_ROOT=${RABBITGIS_BUILD_PREFIX}/qt
fi
QMAKE=qmake
if [ -n "$QT_ROOT" ]; then
    QT_BIN=${QT_ROOT}/bin       #设置用于 android 平台编译的 qt bin 目录
    QMAKE=${QT_BIN}/qmake       #设置用于 unix 平台编译的 QMAKE。
                            #这里设置的是自动编译时的配置，你需要修改为你本地qt编译环境的配置.
fi
echo "QT_BIN:$QT_BIN"

TARGET_OS=`uname -s`
case $TARGET_OS in
    MINGW* | CYGWIN* | MSYS*)
        GENERATORS="MSYS Makefiles"
        ;;
    Linux* | Unix*)
        GENERATORS="Unix Makefiles" 
        ;;
    *)
    echo "Please set RABBITGIS_BUILD_HOST. see build_envsetup_windows_mingw.sh"
    return 2
    ;;
esac

#pkg-config帮助文档：http://linux.die.net/man/1/pkg-config
export PKG_CONFIG=pkg-config 
if [ "${RABBITGIS_BUILD_THIRDLIBRARY}" = "TRUE" ]; then
    #不用系统的第三方库,用下面
    export PKG_CONFIG_PATH=${RABBITGIS_BUILD_PREFIX}/lib/pkgconfig 
    export PKG_CONFIG_LIBDIR=${PKG_CONFIG_PATH}
    export PKG_CONFIG_SYSROOT_DIR=${RABBITGIS_BUILD_PREFIX}
else
    #如果用系统的库,就用下面  
    export PKG_CONFIG_PATH=${RABBITGIS_BUILD_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}
fi
export PATH=${QT_BIN}:$PATH

