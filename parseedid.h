#ifndef PARSEEDID_H
#define PARSEEDID_H

#include <QObject>
//#include "tools.h"

class ParseEDID : public QObject
{
    Q_OBJECT
public:
    explicit ParseEDID(QObject *parent = nullptr);
    void EdidReadStatusShow(char *cEDIDBuf);//int Edidindex);
//    void OnButtonEdidSave(QString filePath);
    void OnButtonEdidOpen(QString filePathName);
    void getSimpleParseEDID(char *cEDIDBuf);//AutoTiming

signals:
    void signalEDID(QList<QString> result);
    void signalEDIDAutoTiming(QList<QString> result);

public slots:

private:
    char *m_cEDIDBuf_SHOW = nullptr;
    char m_cEDIDBuf[512];//the last one is for checksum
    QString m_StatusChkSum;
    void EdidAnalysseInfo(unsigned char *pEdid, char inde);
    void EdidAnalysseInfoAutoTiming(char *pEdid, char inde);
    QString m_EdidAll;
    QString m_EdidGeneralInfo;
    QString m_VideoInfoString;
    QString m_AudioInfoString;
//    Tools *tools = nullptr;
    QString m_InfoStringAutoTiming;
};

#endif // PARSEEDID_H
