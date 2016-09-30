#include "mainwindow.h"
#include <QApplication>
#include <QSettings>
#include <QScreen>
#include "Global/GlobalDir.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
#ifndef MOBILE
    //加载窗口位置  
    QSettings conf(CGlobalDir::Instance()->GetApplicationConfigureFile(),
                   QSettings::IniFormat);
    QScreen *pScreen = QGuiApplication::primaryScreen();

    int top = conf.value("UI/MainWindow/top",
          pScreen->availableGeometry().height() > w.height()
          ? (pScreen->availableGeometry().height() - w.height()) >> 1
          :  60
          ).toInt();
    int left = conf.value("UI/MainWindow/left",
          pScreen->availableGeometry().width() > w.width()
          ? (pScreen->availableGeometry().width() - w.width()) >> 1
          : 60
          ).toInt();
    int Width = conf.value("UI/MainWindow/width",
          pScreen->availableGeometry().width() > w.width()
          ? w.geometry().width()
          : pScreen->availableGeometry().width() - 120
          ).toInt();
    int Height = conf.value("UI/MainWindow/height",
          pScreen->availableGeometry().height() > w.height()
          ? w.geometry().height()
          :  pScreen->availableGeometry().height() - 120
          ).toInt();
    w.resize(Width, Height);
    w.move(left, top);
#endif
    w.show();
    
    return a.exec();
}
