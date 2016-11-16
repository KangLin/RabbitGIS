[![Logon](Resource/png/AppIcon.png) RabbitGIS ![Logon](Resource/png/AppIcon.png)](https://github.com/KangLin/RabbitGIS)

[![Build status](https://ci.appveyor.com/api/projects/status/qjqrq2pyo4qejxtv?svg=true)](https://ci.appveyor.com/project/KangLin/rabbitgis)

=============================================================================

* 作者：康林（msn、email:kl222@126.com ; QQ:16614119)
* 项目位置：https://github.com/KangLin/rabbitGIS  


|[<img src="Resource/png/English.png" alt="English" title="English" width="16" height="16" />英语](README.md)|

-----------------------------------------------------------------------------
## 编译
### 1. 下载预编译或编译第三方依赖库
#### 1.1. 下载预编译第三方依赖库

#### 2.2. 编译第三方依赖库
See [rabbitim-third-library](https://github.com/KangLin/rabbitim-third-library)

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
