
SOURCES += main.cpp \
        mainwindow.cpp \
        Global/Log.cpp \
        Global/GlobalDir.cpp \
        GpxModel/actfile.cpp \
        GpxModel/gpx_model.cpp \
        GpxModel/gpxfile.cpp \
        GpxModel/nmeafile.cpp \
        GpxModel/utils.c \
        GpxModel/uxmlpars.c \
        MeasureTool.cpp 
 
HEADERS += mainwindow.h \
        Global/Log.h \
        Global/GlobalDir.h \
        GpxModel/actfile.h \
        GpxModel/gpx_model.h \
        GpxModel/gpxfile.h \
        GpxModel/nmeafile.h \
        GpxModel/utils.h \
        GpxModel/uxmlpars.h \
        MeasureTool.h 

FORMS += mainwindow.ui \
      MeasureTool.ui 

RESOURCES += \
    $$PWD/../Resource/Resource.qrc \
    $$PWD/../Resource/sink/dark/style.qrc

android{
    RESOURCES += \
        $$PWD/../Resource/Android.qrc
        #$$PWD/../Resource/translations/Translations.qrc \
}
