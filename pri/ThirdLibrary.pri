#第三方依赖库  
CONFIG(debug, debug|release) {
    LIBS += -losgEarthSplatd -losgEarthAnnotationd -losgEarthSymbologyd -losgEarthQtd -losgEarthUtild -losgEarthFeaturesd -losgEarthd 
} else {
    LIBS += -losgEarthSplat -losgEarthAnnotation -losgEarthSymbology -losgEarthQt -losgEarthUtil -losgEarthFeatures -losgEarth 
}

CONFIG(debug, debug|release) {
    LIBS += -losgQtd -losgd -losgDBd -losgFXd -losgGAd -losgParticled -losgSimd -losgTextd -losgUtild -losgTerraind -losgManipulatord -losgViewerd -losgWidgetd -losgShadowd -losgAnimationd -losgVolumed -lOpenThreadsd
} else {
    myPackagesExist(openscenegraph) {
        MYPKGCONFIG *= openscenegraph-osgQt
    } else {
        LIBS += -losgQt -losg -losgDB -losgFX -losgGA -losgParticle -losgSim -losgText -losgUtil -losgTerrain -losgManipulator -losgViewer -losgWidget -losgShadow -losgAnimation -losgVolume -lOpenThreads
    }
}

myPackagesExist(gdal) {
    MYPKGCONFIG *= gdal
}

myPackagesExist(libcurl) {
    MYPKGCONFIG *= libcurl
}

myPackagesExist(libcrypto) {
    MYPKGCONFIG *= libcrypto
}
