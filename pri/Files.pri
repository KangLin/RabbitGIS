
SOURCES += main.cpp \
        Mainwindow.cpp \
        Global/Log.cpp \
        Global/GlobalDir.cpp \
        Global/Global.cpp \
        Common/Tool.cpp \
        GpxModel/actfile.cpp \
        GpxModel/gpx_model.cpp \
        GpxModel/gpxfile.cpp \
        GpxModel/nmeafile.cpp \
        GpxModel/utils.c \
        GpxModel/uxmlpars.c \
        MeasureTool.cpp \
        Widgets\DlgAbout\DlgAbout.cpp
 
HEADERS += Mainwindow.h \
        Global/Log.h \
        Global/GlobalDir.h \
        Global/Global.h \
        Common/Tool.h \
        GpxModel/actfile.h \
        GpxModel/gpx_model.h \
        GpxModel/gpxfile.h \
        GpxModel/nmeafile.h \
        GpxModel/utils.h \
        GpxModel/uxmlpars.h \
        MeasureTool.h \
        Widgets\DlgAbout\DlgAbout.h

FORMS += Mainwindow.ui \
      MeasureTool.ui \
      Widgets\DlgAbout\DlgAbout.ui

RESOURCES += \
    $$PWD/../Resource/Resource.qrc \
    $$PWD/../Resource/sink/dark/style.qrc

android{
    RESOURCES += \
        $$PWD/../Resource/Android.qrc
        #$$PWD/../Resource/translations/Translations.qrc \
}
