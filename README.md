[![Logon](Resource/png/AppIcon.png) RabbitGIS ![Logon](Resource/png/AppIcon.png)](https://github.com/KangLin/RabbitGIS)

[![Build status](https://ci.appveyor.com/api/projects/status/qjqrq2pyo4qejxtv?svg=true)](https://ci.appveyor.com/project/KangLin/RabbitGis)

=============================================================================

* Author：KangLin（email:kl222@126.com ; QQ:16614119)
* Project：https://github.com/KangLin/rabbitGIS  

|[<img src="Resource/png/China.png" alt="Chinese" title="Chinese" width="16" height="16" />Chinese](README_ZH.md)|

-----------------------------------------------------------------------------
## Build and package
### 1. Download Precompiled or compiled third-party libraries
#### 1.1. Download the precompiled third-party libraries
Download from https://sourceforge.net/projects/rabbitim-third-library/files/release/ 

File format: RabbitIm_$(Platform)$(Version)_$(Architecture)_$(QT_VERSION).zip

|Platform|Compiler|Versioin|Architecture|Qt Version|
|:--:|:--:|:--:|:--:|:--:|
|windows_msvc|VS2015|14|x86|qt5.9.1|
|windows_msvc|VS2015|14|x86|qt5.8.0|
|windows_msvc|VS2015|14|x86|qt5.7.1|
|windows_msvc|VS2015|14|x86|qt5.6.2|
|windows_msvc|VS2015|14|x86_64|qt5.9.1|
|windows_msvc|VS2015|14|x86_64|qt5.8.0|
|windows_msvc|VS2015|14|x86_64|qt5.7.1|
|windows_msvc|VS2013|12|x86|qt5.9.1|
|windows_msvc|VS2013|12|x86|qt5.8.0|
|windows_msvc|VS2013|12|x86|qt5.7.1|
|windows_msvc|VS2013|12|x86|qt5.6.2|
|windows_msvc|VS2013|12|x86_64|qt5.9.1|
|windows_msvc|VS2013|12|x86_64|qt5.8.0|
|windows_msvc|VS2013|12|x86_64|qt5.7.1|
|windows_mingw|gcc 5.3.0|530|x86|qt5.8.0|
|windows_mingw|gcc 5.3.0|530|x86|qt5.7.1|
|windows_mingw|gcc 4.9.2|530|x86|qt5.6.2|
|windows_mingw|gcc 5.3.0|530|x86_64|qt5.8.0|
|windows_mingw|gcc 5.3.0|530|x86_64|qt5.7.1|
|unix|gcc 5.3.0|530|x86|qt5.8.0|
|unix|gcc 5.3.0|530|x86|qt5.7.1|
|unix|gcc 5.3.0|530|x86_64|qt5.8.0|
|unix|gcc 5.3.0|530|x86_64|qt5.7.1|
|android|gcc 4.8|4.8|arm|qt5.8.0|
|android|gcc 4.8|4.8|arm|qt5.7.1|
|android|gcc 4.8|4.8|x86|qt5.8.0|
|android|gcc 4.8|4.8|x86|qt5.7.1|


#### 2.2. compiled third-party libraries
See [RabbitThirdLibrary](https://github.com/KangLin/RabbitThirdLibrary)

### 2. Set up the compilation environment
#### 2.1 Set up build environment
Open "project->build and run->build->build environment"

    PKG_CONFIG=              #[option]Set pkg_config programe, Note: If the windows in the use of ming32 pkg-config, can not use msys2 pkg-config

Add git path to PATH environment. if no git, set GIT_VERSION in qmake paramter.

#### 2.2 Set up run environment
Open "project->build and run->run->run environment"

    OSGEARTH_DEFAULT_FONT=simsun.ttc #Set font, The example is to set the Chinese font to simsun.

#### 2.3 Set qmake parameter

    THIRD_LIBRARY_PATH=      #Set third library path, The default is ${SOURCE_ROOT}/ThirdLibrary/${PLATFORM}

If no git, set GIT_VERSION in qmake paramter.

### 3. compiling

    qmake
    make

#### 3.1 Automatically build the generated application
https://github.com/KangLin/RabbitGIS/releases

#### 3.2 Manual packing
##### 3.2.1 windows
1. Copy Install/Install.nsi to output directory

    cp Install/Install.nsi build_${BUILD_TARGERT}

2. Execute

    "/C/Program Files (x86)/NSIS/makensis.exe" "build_${BUILD_TARGERT}/Install.nsi"

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
