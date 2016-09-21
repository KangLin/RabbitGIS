#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>
#include "Global/GlobalDir.h"
#include "Global/Log.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    /*
    m_MapNode = osgDB::readNodeFile(
              CGlobalDir::Instance()->GetApplicationEarthFile().toStdString());
    if(!m_MapNode.valid())
        LOG_MODEL_ERROR("MainWindow", "Open node file fail: %s",
              CGlobalDir::Instance()->GetApplicationEarthFile().toStdString());
    osgViewer::Viewer* viewer = (osgViewer::Viewer*)m_MapViewer.getViewer();
    viewer->setSceneData(m_MapNode);
    this->setCentralWidget(&m_MapViewer);*/
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
    /*
    m_MapNode = osgDB::readNodeFile(szFile.toStdString());
    if(!m_MapNode.valid())
    {
        LOG_MODEL_ERROR("MainWindow", "Open node file fail: %s",
              szFile.toStdString());
        return;
    }
    
    osgViewer::Viewer* viewer = (osgViewer::Viewer*)m_MapViewer.getViewer();
    viewer->setSceneData(m_MapNode);*/
}
