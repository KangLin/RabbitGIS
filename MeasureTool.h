#ifndef CMEASURETOOL_H
#define CMEASURETOOL_H

#include <osgEarthUtil/MeasureTool>
#include <osgEarthQt/ViewerWidget>

#include <QWidget>
#include <QStringList>

namespace Ui {
class CMeasureTool;
}

class CMeasureTool : public QWidget
{
    Q_OBJECT

public:
    explicit CMeasureTool(QWidget *parent = 0);
    explicit CMeasureTool(osgViewer::Viewer* viewer,
                          osg::Group* root,
                          osgEarth::MapNode* map,
                          QWidget *parent = 0);
    virtual ~CMeasureTool();

    virtual void onDistanceChanged(osgEarth::Util::MeasureToolHandler* sender,
                                   double distance);
    
private slots:
    void on_cbPath_clicked();
    void on_cbGreatCircle_clicked();
    
    void on_cbUnit_currentIndexChanged(int index);
    
private:
    Ui::CMeasureTool *ui;

    osgViewer::Viewer* m_pViewer;
    osg::ref_ptr<osgEarth::MapNode> m_MapNode;
    osg::ref_ptr<osgEarth::Util::MeasureToolHandler> m_MeasureTool;
    
    QStringList m_Units;
};

#endif // CMEASURETOOL_H
