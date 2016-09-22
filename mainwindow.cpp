#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>
#include "Global/GlobalDir.h"
#include "Global/Log.h"
#include "GpxModel/gpx_model.h"
#include <vector>

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
    
    m_pMapNode = osgEarth::MapNode::get(mapNode);
    osgViewer::Viewer* viewer = (osgViewer::Viewer*)m_MapViewer.getViewer();
    viewer->setSceneData(m_pMapNode);
    this->setCentralWidget(&m_MapViewer);
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
    
    osg::Node* mapNode = osgDB::readNodeFile(szFile.toStdString());
    if(!mapNode)
        LOG_MODEL_ERROR("MainWindow", "Open node file fail: %s",
                        szFile.toStdString());
    osgViewer::Viewer* viewer = (osgViewer::Viewer*)m_MapViewer.getViewer();
    m_pMapNode = osgEarth::MapNode::get(mapNode);
    viewer->setSceneData(m_pMapNode);
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
}
