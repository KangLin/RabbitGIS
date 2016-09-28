#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTranslator>
#include <QActionGroup>

#include <osgEarthQt/ViewerWidget>
#include <osgEarthUtil/Controls>

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
    
private:
    Ui::MainWindow *ui;
    
    osgEarth::QtGui::ViewerWidget m_MapViewer;
    osg::ref_ptr<osgEarth::MapNode> m_MapNode;
    osg::ref_ptr<osgEarth::Util::Controls::ControlCanvas> m_Canvas;
};

#endif // MAINWINDOW_H
