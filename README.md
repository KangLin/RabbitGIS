[![Logon](Resource/png/AppIcon.png) RabbitGIS ![Logon](Resource/png/AppIcon.png)](https://github.com/KangLin/RabbitGIS)

[![Build status](https://ci.appveyor.com/api/projects/status/qjqrq2pyo4qejxtv?svg=true)](https://ci.appveyor.com/project/KangLin/rabbitgis)

=============================================================================

* Author：KangLin（email:kl222@126.com ; QQ:16614119)
* Project：https://github.com/KangLin/rabbitGIS  

|[<img src="Resource/png/China.png" alt="Chinese" title="Chinese" width="16" height="16" />Chinese](README_ZH.md)|

-----------------------------------------------------------------------------
## Build
### 1. Download Precompiled or compiled third-party libraries
#### 1.1. Download the precompiled third-party libraries

#### 2.2. compiled third-party libraries
See [rabbitim-third-library](https://github.com/KangLin/rabbitim-third-library)

### 2. Set up the compilation environment
#### 2.1 Set up build environment
Open "project->build and run->build->build environment"

    PKG_CONFIG=              #[option]Set pkg_config programe

#### 2.2 Set up run environment
Open "project->build and run->run->run environment"

    OSGEARTH_DEFAULT_FONT=simsun.ttc #Set font, The example is to set the Chinese font to simsun.

#### 2.3 Set qmake parameter

    THIRD_LIBRARY_PATH=      #Set third library path, The default is ${SOURCE_ROOT}/ThirdLibrary/${PLATFORM}

### 3. compiling

    qmake
    make

## depend third-party libraries
* osgearth
* osg
* gdal
* libcurl
* libpng
* jpeg
* libgif
* libtiff
* freetype
