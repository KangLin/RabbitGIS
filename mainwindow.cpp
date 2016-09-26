#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <vector>
#include <QFileDialog>
#include <QDebug>
#include "Global/GlobalDir.h"
#include "Global/Log.h"
#include "GpxModel/gpx_model.h"
#include <osgEarthAnnotation/FeatureNode>
#include <osgEarthFeatures/Feature>
#include <osgEarthSymbology/Style>
#include <osgEarthUtil/EarthManipulator>
#include <osgEarthAnnotation/PlaceNode>
#include <osgEarthUtil/MouseCoordsTool>
#include <osgEarthUtil/LatLongFormatter>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    osg::Node* mapNode = osgDB::readNodeFile(
              CGlobalDir::Instance()->GetApplicationEarthFile().toStdString());
    if(!mapNode)
        LOG_MODEL_ERROR("MainWindow", "Open node file fail: %s",
              CGlobalDir::Instance()->GetApplicationEarthFile().toStdString());
    m_MapNode = osgEarth::MapNode::get(mapNode);
    osgViewer::Viewer* viewer = (osgViewer::Viewer*)m_MapViewer.getViewer();
    viewer->setSceneData(m_MapNode);
    this->setCentralWidget(&m_MapViewer);
    
    const osgEarth::SpatialReference* geoSRS = 
            m_MapNode->getMapSRS()->getGeographicSRS();
    
    osgEarth::Util::EarthManipulator* em =
            (osgEarth::Util::EarthManipulator*)viewer->getCameraManipulator();
    if(!em)
    {   
        LOG_MODEL_ERROR("MainWindow", "getCameraManipulator fail");
        return;
    }
    em->setViewpoint(osgEarth::Viewpoint("China", 105, 35, 0, 0, -90,
                   geoSRS->getEllipsoid()->getRadiusEquator() * 2), 3); //3s, China
    
    // Create canvas
    m_Canvas = osgEarth::Util::Controls::ControlCanvas::getOrCreate(viewer);
    osgEarth::Util::Controls::HBox* bottom = new osgEarth::Util::Controls::HBox();
    bottom->setBackColor(0, 0, 0, 0.2);        
    bottom->setMargin(10);
    bottom->setChildSpacing(145);
    bottom->setVertAlign(osgEarth::Util::Controls::Control::ALIGN_BOTTOM);
    bottom->setHorizAlign(osgEarth::Util::Controls::Control::ALIGN_CENTER);
    
    bottom->addControl(new osgEarth::Util::Controls::LabelControl(
                           tr("Coordinate:").toStdString()));
    osgEarth::Util::Controls::LabelControl* mouseLabel =
            new osgEarth::Util::Controls::LabelControl();
    bottom->addControl(mouseLabel);
    viewer->addEventHandler(new osgEarth::Util::MouseCoordsTool(m_MapNode,
                            mouseLabel)); 
                                  /*new osgEarth::Util::LatLongFormatter(
                   osgEarth::Util::LatLongFormatter::FORMAT_DEFAULT)));*/
    m_Canvas->addControl(bottom);

}

MainWindow::~MainWindow()
{    
    delete ui;
}

void MainWindow::on_actionOpen_O_triggered()
{
    QString szFile = QFileDialog::getOpenFileName(this, tr("Open map file"), 
                             QString(), tr("Map file(*.earth);; All(*.*)"));
    if(szFile.isEmpty())
        return;
    
    osg::Node* mapNode = osgDB::readNodeFile(szFile.toLocal8Bit().data());
    if(!mapNode)
        LOG_MODEL_ERROR("MainWindow", "Open node file fail: %s",
                        szFile.toStdString());
    osgViewer::Viewer* viewer = (osgViewer::Viewer*)m_MapViewer.getViewer();
    m_MapNode = osgEarth::MapNode::get(mapNode);
    viewer->setSceneData(m_MapNode);
    
    // Set view port
    const osgEarth::SpatialReference* geoSRS = 
            m_MapNode->getMapSRS()->getGeographicSRS();
    
    osgEarth::Util::EarthManipulator* em =
            (osgEarth::Util::EarthManipulator*)viewer->getCameraManipulator();
    if(!em)
    {   
        LOG_MODEL_ERROR("MainWindow", "getCameraManipulator fail");
        return;
    }
    em->setViewpoint(osgEarth::Viewpoint("China", 105, 35, 0, 0, -90,
                   geoSRS->getEllipsoid()->getRadiusEquator() * 2), 3); //3s, China
}

void MainWindow::on_actionOpen_track_T_triggered()
{

    QString szFile = QFileDialog::getOpenFileName(this, tr("Open track file"), 
                QString(),
                tr("Track file(*.gpx);; nmea file(*.txt *.nmea);; All(*.*)"));
    if(szFile.isEmpty())
        return;
    
    GPX_model gpx("RabbitGIS");
    if(GPX_model::GPXM_OK != gpx.load(szFile.toStdString()))
    {
        LOG_MODEL_ERROR("MainWindow", "Open track file fail:%s",
                        szFile.toStdString());
        return;
    }
    
    // Add track path
    osgEarth::Symbology::LineString* path =
            new osgEarth::Symbology::LineString();
    std::vector<GPX_trkType>::iterator it;
    for(it = gpx.trk.begin(); it != gpx.trk.end(); it++)
    {
        std::vector<GPX_trksegType>::iterator itSeg;
        for(itSeg = it->trkseg.begin(); itSeg != it->trkseg.end(); itSeg++)
        {
            std::vector<GPX_wptType>::iterator itWpt;
            for(itWpt = itSeg->trkpt.begin(); itWpt != itSeg->trkpt.end();
                itWpt++)
            {
                path->push_back(itWpt->longitude, itWpt->latitude); //, itWpt->geoidheight);
            }
        }
    }
    
    const osgEarth::SpatialReference* geoSRS = 
            m_MapNode->getMapSRS()->getGeographicSRS();
   
    osgEarth::Annotation::Features::Feature* pathFeature = 
            new osgEarth::Annotation::Features::Feature(path, geoSRS);
    pathFeature->geoInterp() = osgEarth::GEOINTERP_GREAT_CIRCLE;
   
    osgEarth::Style pathStyle;
    pathStyle.getOrCreate<osgEarth::Symbology::LineSymbol>()->stroke()->color()
            = osgEarth::Color::Yellow;
    pathStyle.getOrCreate<osgEarth::Symbology::LineSymbol>()->stroke()->width()
            = 20.0f;
    pathStyle.getOrCreate<osgEarth::Symbology::LineSymbol>()->tessellationSize()
            = 75000;
    /*pathStyle.getOrCreate<osgEarth::Symbology::PointSymbol>()->size() = 5;
    pathStyle.getOrCreate<osgEarth::Symbology::PointSymbol>()->fill()->color()
            = osgEarth::Color::Green;*/
    pathStyle.getOrCreate<osgEarth::Symbology::AltitudeSymbol>()->technique()
            =  osgEarth::AltitudeSymbol::TECHNIQUE_GPU;
    
    osgEarth::Annotation::FeatureNode* pathNode = 
            new osgEarth::Annotation::FeatureNode(m_MapNode, pathFeature,
                                                  pathStyle);
 
    // Add start and end labels
    osg::Group* labelGroup = new osg::Group(); 
    m_MapNode->addChild(labelGroup); 
    osg::Vec3d start = path->at(0);
    osg::Vec3d end = path->at(path->size() - 1);
    osgEarth::Style pm;
    QString szStartIcon = CGlobalDir::Instance()->GetDirImage()
            + QDir::separator()
            + "Start.png";
    pm.getOrCreate<osgEarth::IconSymbol>()->url()->setLiteral(
                szStartIcon.toStdString()); 
    pm.getOrCreate<osgEarth::IconSymbol>()->declutter() = true; 
    pm.getOrCreate<osgEarth::TextSymbol>()->halo() = osgEarth::Color("#5f5f5f"); 
    labelGroup->addChild( new osgEarth::Annotation::PlaceNode(m_MapNode, 
                       osgEarth::GeoPoint(geoSRS, start.x(), start.y()),
                                        tr("Start").toStdString(), pm));
    QString szEndIcon = CGlobalDir::Instance()->GetDirImage()
            + QDir::separator()
            + "End.png";
    pm.getOrCreate<osgEarth::IconSymbol>()->url()->setLiteral(
                szEndIcon.toStdString()); 
    labelGroup->addChild( new osgEarth::Annotation::PlaceNode(m_MapNode, 
                           osgEarth::GeoPoint(geoSRS, end.x(), end.y()),
                                          tr("End").toStdString(), pm));
    m_MapNode->addChild(pathNode);
    
    // Set view port
    osgViewer::Viewer* viewer = (osgViewer::Viewer*)m_MapViewer.getViewer();
    osgEarth::Util::EarthManipulator* em =
            (osgEarth::Util::EarthManipulator*)viewer->getCameraManipulator();
    if(!em)
    {   
        LOG_MODEL_ERROR("MainWindow", "getCameraManipulator fail");
        return;
    }
    double range = path->getBounds().width() > path->getBounds().height()
            ? path->getBounds().width()
            : path->getBounds().height();
    em->setViewpoint(osgEarth::Viewpoint("track", 
                 path->getBounds().center2d().x(),
                 path->getBounds().center2d().y(),
                 0, 0, -90,
                 range + geoSRS->getEllipsoid()->getRadiusEquator() * 0.2), 3);
}
