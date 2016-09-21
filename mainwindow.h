#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

#include <osgEarthQt/ViewerWidget>

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
    
private:
    Ui::MainWindow *ui;
    
    osgEarth::QtGui::ViewerWidget m_MapViewer;
    osg::ref_ptr<osgEarth::MapNode> m_pMapNode;
};

#endif // MAINWINDOW_H
