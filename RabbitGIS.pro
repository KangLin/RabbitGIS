#-------------------------------------------------
#
# Project created by QtCreator 2016-09-10T18:02:21
#
#-------------------------------------------------

QT       += core gui opengl

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = RabbitGIS
TEMPLATE = app

CONFIG += c++0x
!msvc{
    QMAKE_CXXFLAGS += " -std=c++0x "
}

CONFIG += link_prl

#修改文件中的第三方库配置  
include(pri/ThirdLibraryConfig.pri)
include(pri/ThirdLibrary.pri)
include(pri/ThirdLibraryJoin.pri)
include(pri/RabbitGISFiles.pri)

OTHER_FILES += README.md \
    .gitignore \
    LICENSE 
