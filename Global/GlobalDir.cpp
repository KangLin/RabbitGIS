#include "GlobalDir.h"
#include "Log.h"
#include <QStandardPaths>
#include <QDir>
#include <QApplication>

CGlobalDir::CGlobalDir()
{
    //注意这个必须的在最前  
    m_szDocumentPath =  QStandardPaths::writableLocation(
                QStandardPaths::DocumentsLocation);
    if(m_szDocumentPath.isEmpty())
    {
        LOG_MODEL_ERROR("CGlobalDir", "document path is empty");
    }
}

CGlobalDir* CGlobalDir::Instance()
{
    static CGlobalDir* p = NULL;
    if(!p)
        p = new CGlobalDir;
    return p;
}

QString CGlobalDir::GetDirApplication()
{
#ifdef ANDROID
    //LOG_MODEL_DEBUG("CGlobalDir", "GetDirApplication:%s", qApp->applicationDirPath().toStdString().c_str());
    return qApp->applicationDirPath() + QDir::separator() + "..";
#else
    //LOG_MODEL_DEBUG("CGlobalDir", "GetDirApplication:%s", qApp->applicationDirPath().toStdString().c_str());
    return qApp->applicationDirPath();
#endif
}

QString CGlobalDir::GetDirDocument()
{
    QString szPath;
    if(m_szDocumentPath.right(1) == "/"
            || m_szDocumentPath.right(1) == "\\")
        szPath = m_szDocumentPath.left(m_szDocumentPath.size() - 1);
    else
        szPath = m_szDocumentPath;
    szPath += QDir::separator();
    szPath = szPath + "Rabbit"
             + QDir::separator() + "GIS";
    return szPath;
}

int CGlobalDir::SetDirDocument(QString szPath)
{
    m_szDocumentPath = szPath + QDir::separator() + "Rabbit"
            + QDir::separator() + "GIS";
    return 0;
}

QString CGlobalDir::GetApplicationEarthFile()
{
    return GetDirApplication() + QDir::separator() + "Data" + QDir::separator() + "Map.earth";
}
