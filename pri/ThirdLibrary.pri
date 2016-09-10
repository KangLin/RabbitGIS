#第三方依赖库  

CONFIG(release, debug|release) {
    myPackagesExist(osgearth) {
        MYPKGCONFIG *= osgearth
    } else : msvc {
        LIBS += -lqxmpp0
    }
}
