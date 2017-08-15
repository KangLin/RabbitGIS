#第三方依赖库  
CONFIG(debug, debug|release) {
    LIBS += -losgEarthSplatd -losgEarthAnnotationd -losgEarthSymbologyd -losgEarthQtd -losgEarthUtild -losgEarthFeaturesd -losgEarthd 
} else {
    LIBS += -losgEarthSplat -losgEarthAnnotation -losgEarthSymbology -losgEarthQt5 -losgEarthUtil -losgEarthFeatures -losgEarth 
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

win32 : equals(QMAKE_HOST.os, Windows){
    Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/*osg*.dll \
        $${THIRD_LIBRARY_PATH}/bin/*gdal*.dll \
        $${THIRD_LIBRARY_PATH}/bin/*tiff*.dll \
        $${THIRD_LIBRARY_PATH}/bin/*OpenThreads*.dll
    Deployment_third_library_files_osg_plugin.target = Deployment_third_library_files_osg_plugin
    Deployment_third_library_files_osg_plugin.files = $${THIRD_LIBRARY_PATH}/bin/osgPlugins-$${OSG_VERSION}/*osg*.dll 
    Deployment_third_library_files_osg_plugin.path = $$system_path($$PREFIX)/osgPlugins-$${OSG_VERSION}
    Deployment_third_library_files_osg_plugin.CONFIG += directory no_check_exist
    INSTALLS += Deployment_third_library_files_osg_plugin
}

myPackagesExist(gdal) {
    MYPKGCONFIG *= gdal
    win32 : equals(QMAKE_HOST.os, Windows){
        Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/*gdal*.dll
    }
}

myPackagesExist(libcurl) {
    MYPKGCONFIG *= libcurl
}
win32 : equals(QMAKE_HOST.os, Windows){
    Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/*curl*.dll \
        $${THIRD_LIBRARY_PATH}/bin/*z*.dll
}

myPackagesExist(libcrypto) {
    MYPKGCONFIG *= libcrypto
}
win32 : equals(QMAKE_HOST.os, Windows){
    Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/*eay*.dll 
}

myPackagesExist(libqrencode) {
    DEFINES *= RABBITGIS_USE_LIBQRENCODE
    MYPKGCONFIG *= libqrencode
}
win32 : equals(QMAKE_HOST.os, Windows){
    Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/*qrencode*.dll
}

myPackagesExist(QZXing) {
    DEFINES *= RABBITGIS_USE_QZXING
    MYPKGCONFIG *= QZXing
    Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/lib/*QZXing*.dll
} else : msvc {
    exists("$${THIRD_LIBRARY_PATH}/include/QZXing.h"){
        DEFINES *= RABBITGIS_USE_QZXING
        LIBS += -lQZXing2
        Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/lib/*QZXing*.dll
    }
}
