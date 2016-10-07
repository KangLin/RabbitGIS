#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTranslator>
#include <QActionGroup>

#include <osgEarthQt/ViewerWidget>
#include <osgEarthUtil/Controls>
#include <osgEarthUtil/MouseCoordsTool>

#include "MeasureTool.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    
private slots:
    void on_actionOpen_O_triggered();
    void on_actionOpen_track_T_triggered();

    void changeEvent(QEvent *e);

private:
    // Language
    int LoadTranslate(QString szLocale = QString());
    int ClearTranslate();
    int InitMenuTranslate();
    int ClearMenuTranslate();
    QMap<QString, QAction*> m_ActionTranslator;
    QActionGroup m_ActionGroupTranslator;
    QSharedPointer<QTranslator> m_TranslatorQt;
    QSharedPointer<QTranslator> m_TranslatorApp;
private slots:
    void slotActionGroupTranslateTriggered(QAction* pAct);
    
    void on_actionExit_E_triggered();
    
    void on_actionMeasure_the_distance_M_triggered();
    
private:
    int LoadMap(QString szFile);
    
private:
    Ui::MainWindow *ui;
    
    osgEarth::QtGui::ViewerWidget m_MapViewer;
    osg::ref_ptr<osg::Group> m_Root;
    osg::ref_ptr<osgEarth::MapNode> m_MapNode;
    
    // Display mouse coodinate canvas
    osg::ref_ptr<osgEarth::Util::Controls::HBox> m_MouseCanvasHBox;
    osg::ref_ptr<osgEarth::Util::MouseCoordsTool> m_MouseCoordsTool;
  
    CMeasureTool* m_pMeasureTool;
};

#endif // MAINWINDOW_H
