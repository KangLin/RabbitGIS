#第三方依赖库  
CONFIG(debug, debug|release) {
    LIBS += -losgEarthSplatd -losgEarthAnnotationd -losgEarthSymbologyd -losgEarthQt5d -losgEarthUtild -losgEarthFeaturesd -losgEarthd 
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
        $${THIRD_LIBRARY_PATH}/bin/*png*.dll \
        $${THIRD_LIBRARY_PATH}/bin/*OpenThreads*.dll 
    msvc : Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/*zlib*.dll
    mingw : Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/libz.dll
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
} else : win32 {
    msvc : LIBS += -lgdal_i
    mingw : LIBS = -lgdal
}

myPackagesExist(libcurl) {
    MYPKGCONFIG *= libcurl
}else:win32{
    LIBS += -llibcurl
}
win32 : equals(QMAKE_HOST.os, Windows){
    Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/*curl*.dll \
        $${THIRD_LIBRARY_PATH}/bin/*z*.dll
}

myPackagesExist(libcrypto) {
    MYPKGCONFIG *= libcrypto
}else:win32{
    LIBS += -llibssl -llibcrypto
}
win32 : equals(QMAKE_HOST.os, Windows){
    Deployment_third_library_files += $${THIRD_LIBRARY_PATH}/bin/*crypto*.dll \
        $${THIRD_LIBRARY_PATH}/bin/*ssl*.dll
}
