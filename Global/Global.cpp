#include "Global.h"
#include <QSettings>

CGlobal::CGlobal(QObject *parent) :
    QObject(parent)
{
    QSettings conf(CGlobalDir::Instance()->GetApplicationConfigureFile(),
                   QSettings::IniFormat);
    m_szStyleFile = conf.value(
                "UI/StyleSheet", ":/qdarkstyle/style.qss").toString();
    m_szStyleMenu = conf.value("UI/MenuStyleSheet", "Dark").toString();
}

CGlobal::~CGlobal()
{
}

CGlobal* CGlobal::Instance()
{
    static CGlobal* p = NULL;
    if(!p)
        p = new CGlobal;
    return p;
}

QString CGlobal::GetStyle()
{
    return m_szStyleFile;
}

QString CGlobal::GetStyleMenu()
{
    return m_szStyleMenu;
}

int CGlobal::SetStyleMenu(QString szMenu, QString szFile)
{
    m_szStyleMenu = szMenu;
    m_szStyleFile = szFile;
    QSettings conf(CGlobalDir::Instance()->GetApplicationConfigureFile(),
                   QSettings::IniFormat);
    conf.setValue("UI/MenuStyleSheet", szMenu);
    conf.setValue("UI/StyleSheet", szFile);
    return 0;
}
