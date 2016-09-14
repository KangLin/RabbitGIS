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

    osg::ArgumentParser arguments(&argc,argv);
    if ( arguments.read("--stencil") )
        osg::DisplaySettings::instance()->setMinimumNumStencilBits(8);

    
    osgViewer::Viewer viewer(arguments);
    viewer.setThreadingModel( viewer.SingleThreaded );
    viewer.setRunFrameScheme( viewer.ON_DEMAND );
    viewer.setCameraManipulator( new osgEarth::Util::EarthManipulator() );
    // load an earth file
    osg::Node* node = osgEarth::Util::MapNodeHelper().load(arguments, &viewer);
    if ( !node )
        qDebug() << "Failed to load earth file.";
    else
        viewer.setSceneData(node);

    QWidget* viewerWidget = new osgEarth::QtGui::ViewerWidget(&viewer);
    w.setCentralWidget(viewerWidget);
    
    return a.exec();
}
