#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTranslator>
#include <QActionGroup>
#include <QMenu>
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

private:
    int InitToolbar();

    // Language menu    
private:
    int LoadTranslate(QString szLocale = QString());
    int ClearTranslate();
    int InitMenuTranslate();
    int ClearMenuTranslate();
    QMenu m_MenuTranslate;
    QMap<QString, QAction*> m_ActionTranslator;
    QActionGroup m_ActionGroupTranslator;
    QSharedPointer<QTranslator> m_TranslatorQt;
    QSharedPointer<QTranslator> m_TranslatorApp;
private slots:
    void slotActionGroupTranslateTriggered(QAction* pAct);
    
    //Style menu
private:
    QMenu m_MenuStyle;
    QActionGroup m_ActionGroupStyle;
    QMap<QString, QAction*> m_ActionStyles;
    int InitMenuStyles();
    int ClearMenuStyles();
    int OpenCustomStyleMenu();
    int LoadStyle();
private slots:
    void slotActionGroupStyleTriggered(QAction* act);

    //Map menu
private:
    QActionGroup m_ActionGroupMap;
    std::list<QAction*> m_ActionMap;
    void ClearMenuMap();
private slots:
    void slotActionGroupMapTriggered(QAction* act);
    void slotMenuMapShow();
    
private slots:
    void changeEvent(QEvent *e);
    void on_actionOpen_Project_triggered();
    void on_actionSava_project_S_triggered();
    void on_actionOpen_track_T_triggered();
    void on_actionExit_E_triggered();
    void on_actionMeasure_the_distance_M_triggered();
    void on_actionStatusBar_S_triggered();
    void on_actionToolBar_triggered();
    void on_actionAbout_A_triggered();
    
private:
    int LoadProject(QString szFile);
    
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
