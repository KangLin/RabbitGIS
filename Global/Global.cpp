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
    m_StatusbarVisable = conf.value("UI/Visable/Statusbar", "true").toBool();
    m_ToolbarVisable = conf.value("UI/Visable/Toolbar", "true").toBool();
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

bool CGlobal::GetStatusbarVisable()
{
    return m_StatusbarVisable;
}

int CGlobal::SetStatusbarVisable(bool bVisable)
{
    m_StatusbarVisable = bVisable;
    QSettings conf(CGlobalDir::Instance()->GetApplicationConfigureFile(),
                   QSettings::IniFormat);
    conf.setValue("UI/Visable/Statusbar", m_StatusbarVisable);
    return 0;
}

bool CGlobal::GetToolbarVisable()
{
    return m_ToolbarVisable;
}

int CGlobal::SetToolbarVisable(bool bVisable)
{
    m_ToolbarVisable = bVisable;
    QSettings conf(CGlobalDir::Instance()->GetApplicationConfigureFile(),
                   QSettings::IniFormat);
    conf.setValue("UI/Visable/Toolbar", m_ToolbarVisable);
    return 0;
}
