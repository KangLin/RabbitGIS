#第三方依赖库  

myPackagesExist(openscenegraph) {
    MYPKGCONFIG *= openscenegraph
}

LIBS += -losgEarthQt -losgEarthUtil -losgEarthSplat -losgEarthSymbology -losgEarthFeatures -losgEarthAnnotation -losgEarth 
#LIBS +=  -losg -losgDB -losgFX -losgGA -losgParticle -losgSim -losgText -losgUtil -losgTerrain -losgManipulator -losgViewer -losgWidget -losgShadow -losgAnimation -losgVolume -lOpenThreads
