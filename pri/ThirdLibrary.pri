#第三方依赖库  

LIBS += -losgEarthSplat -losgEarthAnnotation -losgEarthSymbology -losgEarthQt -losgEarthUtil -losgEarthFeatures -losgEarth 

myPackagesExist(openscenegraph) {
    MYPKGCONFIG *= openscenegraph-osgQt
} else {
    LIBS +=  -losg -losgDB -losgFX -losgGA -losgParticle -losgSim -losgText -losgUtil -losgTerrain -losgManipulator -losgViewer -losgWidget -losgShadow -losgAnimation -losgVolume -lOpenThreads
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
