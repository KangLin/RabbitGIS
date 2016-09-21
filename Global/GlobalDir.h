#ifndef CGLOBALDIR_H
#define CGLOBALDIR_H

#include <QString>

class CGlobalDir
{
public:
    CGlobalDir();
    
    static CGlobalDir* Instance();
    
    /// 应用程序目录  
    QString GetDirApplication();
    /// 文档目录，默认是系统文档目录  
    QString GetDirDocument();
    int SetDirDocument(QString szPath);
    
    /// 翻译文件目录  
    QString GetDirTranslate();
    /// 应用程序配置文件  
    QString GetApplicationEarthFile();
   
private:
    QString m_szDocumentPath;
};

#endif // CGLOBALDIR_H
