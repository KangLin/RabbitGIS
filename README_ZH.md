[![Logon](Resource/png/AppIcon.png) RabbitGIS ![Logon](Resource/png/AppIcon.png)](https://github.com/KangLin/RabbitGIS)

[![Build status](https://ci.appveyor.com/api/projects/status/qjqrq2pyo4qejxtv?svg=true)](https://ci.appveyor.com/project/KangLin/RabbitGis)

=============================================================================

* 作者：康林（email:kl222@126.com ; QQ:16614119)
* 项目位置：https://github.com/KangLin/rabbitGIS  


|[<img src="Resource/png/English.png" alt="English" title="English" width="16" height="16" />英语](README.md)|

-----------------------------------------------------------------------------
## 编译和打包
### 1. 下载预编译或编译第三方依赖库
#### 1.1. 下载预编译第三方依赖库
从 https://sourceforge.net/projects/rabbitim-third-library/files/release/ 下载与你编译器和QT版本相同的库。

文件格式： RabbitIm_$(平台)$(版本号)_$(架构)_$(QT 版本).zip

|编译器|版本号|平台|架构|
|:--:|:--:|:--:|:--:|
|VS2015|14|windows_msvc|x86|
|VS2013|12|windows_msvc|x86|
|gcc 5.3.0|530|windows_mingw|x86|
|gcc 4.9.2|492|windows_mingw|x86|
|gcc 4.9.1|491|windows_mingw|x86|
|gcc 4.8.2|482|windows_mingw|x86|
|gcc 4.8|4.8|android|arm|

#### 2.2. 编译第三方依赖库
See [RabbitThirdLibrary](https://github.com/KangLin/RabbitThirdLibrary)

### 2. 设置环境变量
#### 2.1 设置编译环境变量
打开 "project->build and run->build->build environment"

    PKG_CONFIG=              #[可选]设置 pkg_config 程序

#### 2.2 设置运行环境变量
打开 "project->build and run->run->run environment"

    OSGEARTH_DEFAULT_FONT=simsun.ttc #设置字体，例如：设置宋体

#### 2.3 设置 qmake 参数

    THIRD_LIBRARY_PATH=      #设置第三方依赖库路径，默认位置是 ${SOURCE_ROOT}/ThirdLibrary/${PLATFORM}

### 3. 编译

    qmake
    make

#### 3.1 自动编译产生的应用程序
下载：https://sourceforge.net/projects/rabbitgis/files/

#### 3.2 手动打包
##### 3.2.1 windows
1. 把Install/Install.nsi复制到编译输出目录下

    cp Install/Install.nsi build_${BUILD_TARGERT}

2. 执行

    "/C/Program Files (x86)/NSIS/makensis.exe" "build_${BUILD_TARGERT}/Install.nsi"

## 第三方依赖库
* osgearth
* osg
* gdal
* libcurl
* libpng
* jpeg
* libgif
* libtiff
* freetype
