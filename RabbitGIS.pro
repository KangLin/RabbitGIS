#-------------------------------------------------
#
# Project created by QtCreator 2016-09-10T18:02:21
#
#-------------------------------------------------

### TODO:Modify osg version ###
OSG_VERSION=3.5.4

QT += core gui opengl

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = RabbitGIS
TEMPLATE = app

#Get app version use git, please set git path to environment variable PATH
isEmpty(BUILD_VERSION) {
    isEmpty(GIT) : GIT=$$(GIT)
    isEmpty(GIT) : GIT=git
    isEmpty(GIT_DESCRIBE) {
        GIT_DESCRIBE = $$system(cd $$system_path($$PWD) && $$GIT describe --tags)
        isEmpty(BUILD_VERSION) {
            BUILD_VERSION = $$GIT_DESCRIBE
        }
    }
    isEmpty(BUILD_VERSION) {
        BUILD_VERSION = $$system(cd $$system_path($$PWD) && $$GIT rev-parse --short HEAD)
    }
    
    isEmpty(BUILD_VERSION){
        error("Built without git, please add BUILD_VERSION to DEFINES or add git path to environment variable GIT or qmake parameter GIT")
    }
}
message("BUILD_VERSION:$$BUILD_VERSION")
DEFINES += BUILD_VERSION=\"\\\"$$quote($$BUILD_VERSION)\\\"\"

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
include(pri/Files.pri)

# Rules for creating/updating {ts|qm}-files
include(Resource/translations/translations.pri)

# Appcation Icon
RC_FILE = AppIcon.rc

OTHER_FILES += \
    .gitignore \
    appveyor.yml \
    .travis.yml \
    ci/* \
    Data/* 

DISTFILES += \
    LICENSE.md \
    README.md \
    README_ZH.md \
    Install/*

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
                    --libdir "$$system_path($${PREFIX})" \
                    $$system_path($${PREFIX}/$(TARGET)) \
                    $$system_path($$files($${THIRD_LIBRARY_PATH}/bin/*Qt*.dll, true))

    # Install third library dll
    Deployment_third_lib.target = Deployment_third_lib
    Deployment_third_lib.files = $${Deployment_third_library_files}
    Deployment_third_lib.path = $$system_path($$PREFIX)
    Deployment_third_lib.CONFIG += directory no_check_exist

    # Install map data
    Deployment_data_files.target = Deployment_data_files
    Deployment_data_files.files = $$system_path($$PWD/Data/*)
    Deployment_data_files.path = $$system_path($${PREFIX}/Data)
    Deployment_data_files.CONFIG += directory no_check_exist

    INSTALLS += Deployment_third_lib \
                Deployment_qtlib \
                Deployment_data_files

    # Copy third library dll to path of development when debug in development
    !exists("$$system_path($${TARGET_PATH}/Data/Map.earth)"){
        # Copy third library dll
        THIRD_LIBRARY_DLL = $${THIRD_LIBRARY_PATH}/bin/*.dll 
        !isEmpty(THIRD_LIBRARY_DLL){
            equals(QMAKE_HOST.os, Windows) : msvc | isEmpty(QMAKE_SH){
                THIRD_LIBRARY_DLL = $$system_path($${THIRD_LIBRARY_DLL})
                TARGET_PATH = $$system_path($${TARGET_PATH})
            }
            
            ThirdLibraryDll.commands = $${QMAKE_COPY} $${THIRD_LIBRARY_DLL} $${TARGET_PATH}
            ThirdLibraryDll.CONFIG += directory no_link no_clean no_check_exist
            ThirdLibraryDll.target = ThirdLibraryDll
            QMAKE_EXTRA_TARGETS += ThirdLibraryDll
            COPY_THIRD_DEPENDS.depends += ThirdLibraryDll
        }

        OSG_PLUGINS = $${THIRD_LIBRARY_PATH}/bin/osgPlugins-$${OSG_VERSION}
        OSG_PLUGINS_TARGET_PATH = $$TARGET_PATH/osgPlugins-$${OSG_VERSION}
        exists($${OSG_PLUGINS}){
            equals(QMAKE_HOST.os, Windows) : msvc | isEmpty(QMAKE_SH){
                OSG_PLUGINS = $$system_path($${OSG_PLUGINS})
                OSG_PLUGINS_TARGET_PATH = $$system_path($$OSG_PLUGINS_TARGET_PATH)
            }
            mkpath($${OSG_PLUGINS_TARGET_PATH})
            osg_plugins.commands = \
                $${QMAKE_COPY_DIR} $${OSG_PLUGINS} $${OSG_PLUGINS_TARGET_PATH}
            osg_plugins.CONFIG += directory no_link no_clean no_check_exist
            osg_plugins.target = osg_plugins
            QMAKE_EXTRA_TARGETS += osg_plugins
            COPY_THIRD_DEPENDS.depends += osg_plugins
        }

        DATA_FILES = $$PWD/Data
        DATA_FILES_TARGET_PATH = $$TARGET_PATH/Data
        exists($${DATA_FILES}){
            equals(QMAKE_HOST.os, Windows) : msvc | isEmpty(QMAKE_SH){
                DATA_FILES = $$system_path($$DATA_FILES)
                DATA_FILES_TARGET_PATH = $$system_path($$DATA_FILES_TARGET_PATH)
            }
            mkpath($${DATA_FILES_TARGET_PATH})
            data_files.commands = \
                $${QMAKE_COPY_DIR} $${DATA_FILES} $${DATA_FILES_TARGET_PATH}
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
