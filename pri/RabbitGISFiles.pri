
SOURCES += main.cpp \
        mainwindow.cpp \
        Global/Log.cpp \
        Global/GlobalDir.cpp

HEADERS += mainwindow.h \
        Global/Log.h \
        Global/GlobalDir.h

FORMS    += mainwindow.ui

RESOURCES += \
    $$PWD/../Resource/Resource.qrc \
    $$PWD/../Resource/sink/dark/style.qrc

android{
    RESOURCES += \
        $$PWD/../Resource/translations/Translations.qrc \
        $$PWD/../Resource/Android.qrc
}
