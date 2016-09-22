#-------------------------------------------------
#
# Project created by QtCreator 2016-09-10T18:02:21
#
#-------------------------------------------------

### TODO:Modify osg version ###
OSG_VERSION=3.5.3

QT += core gui opengl

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = RabbitGIS
TEMPLATE = app

# Set TARGET_PATH
win32{
    CONFIG(debug, debug|release) {
        TARGET_PATH=$${OUT_PWD}/Debug
    } else {
        TARGET_PATH=$${OUT_PWD}/Release
    }
}else{
    TARGET_PATH=$$OUT_PWD
}
# Set prefix
isEmpty(PREFIX) {
    android {
       PREFIX = /.
    } else {
        PREFIX = $$OUT_PWD/install
    } 
}

CONFIG += c++0x
!msvc{
    QMAKE_CXXFLAGS += " -std=c++0x "
}

CONFIG += link_prl

# The third library
include(pri/ThirdLibraryConfig.pri)
include(pri/ThirdLibrary.pri)
include(pri/ThirdLibraryJoin.pri)
include(pri/RabbitGISFiles.pri)

# Rules for creating/updating {ts|qm}-files
include(Resource/translations/translations.pri)

# Appcation Icon
RC_FILE = AppIcon.rc

OTHER_FILES += README.md \
    .gitignore \
    appveyor.yml \
    ci/*

other.files = LICENSE.md Authors.txt ChangeLog.md
other.path = $$PREFIX
other.CONFIG += directory no_check_exist 
target.path = $$PREFIX
!android : INSTALLS += other target

win32 : equals(QMAKE_HOST.os, Windows){
    # Install qt dll
    Deployment_qtlib.target = Deployment_qtlib
    Deployment_qtlib.path = $$system_path($${PREFIX})
    Deployment_qtlib.commands = "$$system_path($$[QT_INSTALL_BINS]/windeployqt)" \
                    --compiler-runtime \
                    --verbose 7 \
                    "$$system_path($${PREFIX}/$(TARGET))" \
                    "$$system_path($${PREFIX}/osgEarthQt.dll)"

    # Install third library dll
    Deployment_third_lib.target = Deployment_third_lib
    Deployment_third_lib.files = $$system_path($${THIRD_LIBRARY_PATH}/lib/*.dll)
    Deployment_third_lib.path = $$system_path($$PREFIX)
    Deployment_third_lib.CONFIG += directory no_check_exist

    Deployment_third_bin.target = Deployment_third_bin
    Deployment_third_bin.files = $$system_path($${THIRD_LIBRARY_PATH}/bin/*.dll)
    Deployment_third_bin.path = $$system_path($$PREFIX)
    Deployment_third_bin.CONFIG += directory no_check_exist

    Deployment_osg_plugins.target = Deployment_osg_plugins
    Deployment_osg_plugins.files = $$system_path($${THIRD_LIBRARY_PATH}/bin/osgPlugins-$${OSG_VERSION}/*)
    Deployment_osg_plugins.path = $$system_path($$PREFIX/osgPlugins-$${OSG_VERSION})
    Deployment_osg_plugins.CONFIG += directory no_check_exist

    # Install map data
    Deployment_data_files.target = Deployment_data_files
    Deployment_data_files.files = $$system_path($$PWD/Data/*)
    Deployment_data_files.path = $$system_path($$PREFIX/Data)
    Deployment_data_files.CONFIG += directory no_check_exist

    INSTALLS += Deployment_third_lib \
                Deployment_third_bin \
                Deployment_osg_plugins \
                Deployment_data_files \
                Deployment_qtlib
    #QMAKE_EXTRA_TARGETS += Deployment_qtlib Deployment_third_lib Deployment_third_bin
    
    # Copy third library dll to path of development when debug in development
    !exists($$system_path($${TARGET_PATH}/platforms)){

        # Copy qt plugins 
        PlatformsPlugins.commands = \
            $(COPY_DIR) $$system_path($$[QT_INSTALL_PLUGINS]/platforms) $$system_path($${TARGET_PATH}/platforms)
        PlatformsPlugins.CONFIG += directory no_link no_clean no_check_exist
        PlatformsPlugins.target = PlatformsPlugins
        QMAKE_EXTRA_TARGETS += PlatformsPlugins
        COPY_THIRD_DEPENDS.depends = PlatformsPlugins

        # Copy third library dll
        THIRD_LIBRARY_DLL = $${THIRD_LIBRARY_PATH}/bin/*.dll
        exists($${THIRD_LIBRARY_DLL}){
            equals(QMAKE_HOST.os, Windows){#:isEmpty(QMAKE_SH){
                THIRD_LIBRARY_DLL = $$system_path($$THIRD_LIBRARY_DLL)
                TARGET_PATH = $$system_path($$TARGET_PATH)
            }
            ThirdLibraryDll.commands = \
                $${QMAKE_COPY} $${THIRD_LIBRARY_DLL} $${TARGET_PATH}
            ThirdLibraryDll.CONFIG += directory no_link no_clean no_check_exist
            ThirdLibraryDll.target = ThirdLibraryDll
            QMAKE_EXTRA_TARGETS += ThirdLibraryDll
            COPY_THIRD_DEPENDS.depends += ThirdLibraryDll
        }
    
        THIRD_LIBRARY_LIB = $${THIRD_LIBRARY_PATH}/lib/*.dll
        exists($${THIRD_LIBRARY_LIB}){
            equals(QMAKE_HOST.os, Windows){#:isEmpty(QMAKE_SH){
                THIRD_LIBRARY_LIB = $$system_path($$THIRD_LIBRARY_LIB)
                TARGET_PATH = $$system_path($$TARGET_PATH)
            }
            ThirdLibraryLib.commands = \
                $${QMAKE_COPY} $${THIRD_LIBRARY_LIB} $${TARGET_PATH}
            ThirdLibraryLib.CONFIG += directory no_link no_clean no_check_exist
            ThirdLibraryLib.target = ThirdLibraryLib
            QMAKE_EXTRA_TARGETS += ThirdLibraryLib
            COPY_THIRD_DEPENDS.depends += ThirdLibraryLib
        }
    
        OSG_PLUGINS = $${THIRD_LIBRARY_PATH}/bin/osgPlugins-$${OSG_VERSION}/
        exists($${OSG_PLUGINS}){
            equals(QMAKE_HOST.os, Windows){#:isEmpty(QMAKE_SH){
                OSG_PLUGINS = $$system_path($$OSG_PLUGINS)
                OSG_PLUGINS_TARGET_PATH = $$system_path($$TARGET_PATH/osgPlugins-$${OSG_VERSION})
            }
            mkpath($${OSG_PLUGINS_TARGET_PATH})
            osg_plugins.commands = \
                $${QMAKE_COPY} $${OSG_PLUGINS} $${OSG_PLUGINS_TARGET_PATH}
            osg_plugins.CONFIG += directory no_link no_clean no_check_exist
            osg_plugins.target = osg_plugins
            QMAKE_EXTRA_TARGETS += osg_plugins
            COPY_THIRD_DEPENDS.depends += osg_plugins
        }

        DATA_FILES = $$PWD/Data/
        exists($${DATA_FILES}){
            equals(QMAKE_HOST.os, Windows){#:isEmpty(QMAKE_SH){
                DATA_FILES = $$system_path($$DATA_FILES)
                DATA_FILES_TARGET_PATH = $$system_path($$TARGET_PATH/Data)
            }
            mkpath($${DATA_FILES_TARGET_PATH})
            data_files.commands = \
                $${QMAKE_COPY} $${DATA_FILES} $${DATA_FILES_TARGET_PATH}
            data_files.CONFIG += directory no_link no_clean no_check_exist
            data_files.target = data_files
            QMAKE_EXTRA_TARGETS += data_files
            COPY_THIRD_DEPENDS.depends += data_files
        }

        COPY_THIRD_DEPENDS.target = COPY_THIRD_DEPENDS
        COPY_THIRD_DEPENDS.commands = @echo copy third depends
        QMAKE_EXTRA_TARGETS += COPY_THIRD_DEPENDS
        POST_TARGETDEPS += COPY_THIRD_DEPENDS  

    }
}

DISTFILES += \
    LICENSE.md
