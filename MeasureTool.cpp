#include "MeasureTool.h"
#include "ui_MeasureTool.h"

#include <QSettings>
#include "Global/GlobalDir.h"

class MeasureToolEventHandler :
        public osgEarth::Util::MeasureToolHandler::MeasureToolEventHandler
{
public:
    MeasureToolEventHandler(CMeasureTool* pThis)
    {
        m_pThis = pThis;
    }
    virtual void onDistanceChanged(osgEarth::Util::MeasureToolHandler* sender,
                                   double distance)
    {
        m_pThis->onDistanceChanged(sender, distance);
    }

private:
    CMeasureTool* m_pThis;
};

CMeasureTool::CMeasureTool(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::CMeasureTool)
{
    this->setAttribute(Qt::WA_DeleteOnClose);    
    ui->setupUi(this);
    m_pViewer = NULL;
}

CMeasureTool::CMeasureTool(osgViewer::Viewer *viewer, osg::Group *root,
                           osgEarth::MapNode *map, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::CMeasureTool)
{
    this->setAttribute(Qt::WA_DeleteOnClose);
    
    //setWindowFlags(Qt::WindowStaysOnTopHint);
    //setAttribute(Qt::WA_TranslucentBackground, true);
    //setFocusPolicy(Qt::NoFocus);
    
    QSettings conf(CGlobalDir::Instance()->GetApplicationConfigureFile(),
                   QSettings::IniFormat);
    
    ui->setupUi(this);
    
    m_Units << tr("M") << tr("KM");
    
    // Load configure
    ui->cbUnit->addItems(m_Units);
    ui->cbUnit->setCurrentIndex(conf.value("Tools/Measure/Unit", 0).toInt());
    
    ui->cbPath->setChecked(conf.value("Tools/Measure/Path", true).toBool());
    ui->cbGreatCircle->setChecked(
                conf.value("Tools/Measure/GreatCircle", false).toBool());
    
    m_pViewer = viewer;
    m_MeasureTool = new osgEarth::Util::MeasureToolHandler(root, map);
    m_MeasureTool->addEventHandler(new MeasureToolEventHandler(this));
    m_MeasureTool->setIsPath(ui->cbPath->isChecked());
    m_pViewer->addEventHandler(m_MeasureTool);
}

CMeasureTool::~CMeasureTool()
{
    // Save configure
    QSettings conf(CGlobalDir::Instance()->GetApplicationConfigureFile(),
                   QSettings::IniFormat);
    conf.setValue("Tools/Measure/Unit", ui->cbUnit->currentIndex());
    conf.setValue("Tools/Measure/Path", ui->cbPath->isChecked());
    conf.setValue("Tools/Measure/GreatCircle", ui->cbGreatCircle->isChecked());
    
    if(m_pViewer)
        m_pViewer->removeEventHandler(m_MeasureTool);

    delete ui;
}

void CMeasureTool::onDistanceChanged(osgEarth::Util::MeasureToolHandler *sender,
                                     double distance)
{
    if(ui->cbUnit->currentIndex() == 1)
        distance /= 1000;
    ui->leDistance->setText(QString::number(distance, 'f', 2));
}

void CMeasureTool::on_cbPath_clicked()
{
    m_MeasureTool->setIsPath(ui->cbPath->isChecked());
}

void CMeasureTool::on_cbGreatCircle_clicked()
{
    if (ui->cbGreatCircle->isChecked())
    {
        m_MeasureTool->setGeoInterpolation(osgEarth::GeoInterpolation::GEOINTERP_GREAT_CIRCLE);
    }
    else
    {
        m_MeasureTool->setGeoInterpolation(osgEarth::GeoInterpolation::GEOINTERP_RHUMB_LINE);
    }
}

void CMeasureTool::on_cbUnit_currentIndexChanged(int index)
{

}
