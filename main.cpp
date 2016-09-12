#include "mainwindow.h"
#include <QApplication>

#include <osg/Notify>
#include <osgViewer/CompositeViewer>
#include <osgGA/CameraManipulator>
#include <osg/Node>
#include <osgEarthUtil/ExampleResources>
#include <osgEarthUtil/EarthManipulator>
#include <osgEarthQt/ViewerWidget>

#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    // load an earth file
    osg::Node* node = osgDB::readNodeFile("C:/SXEarth2.6.5/bin/google.earth");
    if ( !node )
        qDebug() << "Failed to load earth file." ;
/*
    osgViewer::Viewer viewer;
    viewer.setThreadingModel( viewer.SingleThreaded );
    viewer.setRunFrameScheme( viewer.ON_DEMAND );
    viewer.setCameraManipulator( new osgEarth::Util::EarthManipulator() );
    viewer.setSceneData( node );
    QWidget* viewerWidget = new osgEarth::QtGui::ViewerWidget( &viewer );
    w.setCentralWidget(viewerWidget);
 */
    
    return a.exec();
}
