#ifndef SIGNALANALYZERMANAGER_H
#define SIGNALANALYZERMANAGER_H

#include <QObject>
#include <QImage>
#include <QVariantList>
#include <QStringList>
#include "serialportmanager.h"

struct EdidItem {
    QString name;
    bool selected;
};

struct SignalTimeSlot { 
    QString slotId;  // 如"0001","0101等时间槽编号"
    QVector<bool> signalStates; //每个时间点是否都有信号
};

class SignalAnalyzerManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString frameUrl       READ frameUrl       NOTIFY frameUrlChanged)
    Q_PROPERTY(QString signalStatus   READ signalStatus   NOTIFY signalStatusChanged)
    Q_PROPERTY(QString mode           READ mode           NOTIFY modeChanged)
    Q_PROPERTY(QString resolution     READ resolution     NOTIFY resolutionChanged)
    Q_PROPERTY(QString inputType      READ inputType      NOTIFY inputTypeChanged)
    Q_PROPERTY(QString hdcpVersion    READ hdcpVersion    NOTIFY hdcpVersionChanged)
    Q_PROPERTY(QString colorSpace     READ colorSpace     NOTIFY colorSpaceChanged)
    Q_PROPERTY(QString colorDepth     READ colorDepth     NOTIFY colorDepthChanged)
    Q_PROPERTY(QString bt2020Status   READ bt2020Status   NOTIFY bt2020StatusChanged)

    // Video Info
    Q_PROPERTY(QString videoFormat  READ videoFormat  NOTIFY videoFormatChanged)
    Q_PROPERTY(QString colorSpace    READ colorSpace    NOTIFY colorSpaceChanged)
    Q_PROPERTY(QString colorDepth    READ colorDepth    NOTIFY colorDepthChanged)
    Q_PROPERTY(QString hdrFormat     READ hdrFormat     NOTIFY hdrFormatChanged)
    Q_PROPERTY(QString hdmiDvi       READ hdmiDvi       NOTIFY hdmiDviChanged)
    Q_PROPERTY(QString frlRate       READ frlRate       NOTIFY frlRateChanged)
    Q_PROPERTY(QString dscMode       READ dscMode       NOTIFY dscModeChanged)
    Q_PROPERTY(QString hdcpType      READ hdcpType      NOTIFY hdcpTypeChanged)

    // Audio Info
    Q_PROPERTY(QString samplingFreq  READ samplingFreq  NOTIFY samplingFreqChanged)
    Q_PROPERTY(QString samplingSize  READ samplingSize  NOTIFY samplingSizeChanged)
    Q_PROPERTY(QString channelCount  READ channelCount  NOTIFY channelCountChanged)
    Q_PROPERTY(QString channelNumber READ channelNumber NOTIFY channelNumberChanged)
    Q_PROPERTY(QString levelShift    READ levelShift    NOTIFY levelShiftChanged)
    Q_PROPERTY(QString cBitSamplingFreq READ cBitSamplingFreq NOTIFY cBitSamplingFreqChanged)
    Q_PROPERTY(QString cBitDataType  READ cBitDataType  NOTIFY cBitDataTypeChanged)

    // EDID list:change to QVariantList,each element such as { name: string, seleted: bool }
    Q_PROPERTY(QVariantList edidList READ edidList NOTIFY edidListChanged)

    //Monitor
    Q_PROPERTY(QString     monitorStartTime   READ monitorStartTime   NOTIFY monitorStartTimeChanged)
    Q_PROPERTY(int         timeSlotInterval   READ timeSlotInterval   NOTIFY timeSlotIntervalChanged)
    Q_PROPERTY(bool        timeSlotInSeconds  READ timeSlotInSeconds  NOTIFY timeSlotIntervalChanged)
    Q_PROPERTY(int         triggerMode        READ triggerMode        NOTIFY triggerModeChanged)
    Q_PROPERTY(QVariantList monitorSlotLabels  READ monitorSlotLabels  NOTIFY monitorDataChanged)
    Q_PROPERTY(QVariantList monitorData        READ monitorData        NOTIFY monitorDataChanged)


public:
    //explicit SignalAnalyzerManager(QObject* parent = nullptr);
    explicit SignalAnalyzerManager(SerialPortManager* spMgr,QObject* parent = nullptr);
    QString frameUrl()    const { return m_frameUrl; }
    QString signalStatus()const { return m_signalStatus; }
    QString mode()        const { return m_mode; }
    QString resolution()  const { return m_resolution; }
    QString inputType()   const { return m_inputType; }
    QString hdcpVersion() const { return m_hdcpVersion; }
    QString colorSpace()  const { return m_colorSpace; }
    QString colorDepth()  const { return m_colorDepth; }
    QString bt2020Status()const { return m_bt2020Status; }
    //QStringList edidList() const { return m_edidList; }
    QVariantList edidList() const;
    // checkbox callback in qml
    Q_INVOKABLE void setEdidSelected(int index,bool selected);
    // new buttom 'Apply' in qml
    Q_INVOKABLE void applyEdid();
    Q_INVOKABLE void selectSingleEdid(int index);

    // getters
    QString videoFormat() const    { return m_videoFormat; }
    //QString colorSpace() const      { return m_colorSpace; }
    //QString colorDepth() const      { return m_colorDepth; }
    QString hdrFormat() const       { return m_hdrFormat; }
    QString hdmiDvi() const         { return m_hdmiDvi; }
    QString frlRate() const         { return m_frlRate; }
    QString dscMode() const         { return m_dscMode; }
    QString hdcpType() const        { return m_hdcpType; }

    QString samplingFreq() const    { return m_samplingFreq; }
    QString samplingSize() const    { return m_samplingSize; }
    QString channelCount() const    { return m_channelCount; }
    QString channelNumber() const   { return m_channelNumber; }
    QString levelShift() const      { return m_levelShift; }
    QString cBitSamplingFreq() const{ return m_cBitSamplingFreq; }
    QString cBitDataType() const    { return m_cBitDataType; }



    //Subsequent implementation of PCIe/FPGA frame capture
    Q_INVOKABLE void startFpgaVideo();

    // Monitor control interface
    Q_INVOKABLE void startMonitor();
    Q_INVOKABLE void setTimeSlotInterval(int secs);
    Q_INVOKABLE void setTimeSlotUnit(bool inSeconds);
    Q_INVOKABLE void setTriggerMode(int mode);
    // Monitor 数据刷新（在串口或后台回调中调用）
    void updateMonitorData(const QStringList &slotLabels,
                           const QList<QPointF> &data);

    // 新增的访问器
    QString     monitorStartTime()  const { return m_monitorStartTime; }
    int         timeSlotInterval()  const { return m_timeSlotInterval; }
    bool        timeSlotInSeconds() const { return m_timeSlotInSeconds; }
    int         triggerMode()       const { return m_triggerMode; }
    QVariantList monitorSlotLabels() const { return m_monitorSlotLabels; }
    QVariantList monitorData()       const { return m_monitorData; }

    // 新增的导出/触发检测方法
    Q_INVOKABLE bool exportMonitorData(const QString &filePath);
    

public slots:
    void updateFrame(const QImage &img);
    void updateInfo(const QString &status,
                    const QString &mode,
                    const QString &res,
                    const QString &type,
                    const QString &hdcp,
                    const QString &cs,
                    const QString &cd,
                    const QString &bt2020);

    // 一个统一的更新接口，接收到新数据后调用
    void updateSignalInfo(const QVariantMap &info);

    //When the lower layer receives EDID data,it calls
    void updateEdidList(const QStringList &edidData);

signals:
    void frameUrlChanged();
    void signalStatusChanged();
    void modeChanged();
    void resolutionChanged();
    void inputTypeChanged();
    void hdcpVersionChanged();
    void colorSpaceChanged();
    void colorDepthChanged();
    void bt2020StatusChanged();
    void edidListChanged();

    // Video Info signals
    void videoFormatChanged();
    //void colorSpaceChanged();
    //void colorDepthChanged();
    void hdrFormatChanged();
    void hdmiDviChanged();
    void frlRateChanged();
    void dscModeChanged();
    void hdcpTypeChanged();

    // Audio Info signals
    void samplingFreqChanged();
    void samplingSizeChanged();
    void channelCountChanged();
    void channelNumberChanged();
    void levelShiftChanged();
    void cBitSamplingFreqChanged();
    void cBitDataTypeChanged();

    // Monitor
    // 对应的变化信号
    void monitorStartTimeChanged();
    void timeSlotIntervalChanged();
    void timeSlotInSecondsChanged();
    void triggerModeChanged();
    void monitorSlotLabelsChanged();
    void monitorDataChanged();

private:
    QString m_frameUrl;
    QString m_signalStatus;
    QString m_mode;
    QString m_resolution;
    QString m_inputType;
    QString m_hdcpVersion;
    QString m_colorSpace;
    QString m_colorDepth;
    QString m_bt2020Status;
    //QStringList m_edidList;
    QList<EdidItem> m_edidItems;
    SerialPortManager*       m_serialPortManager;  // ← 保存串口管理器指针

    QString saveTempImageAndGetUrl(const QImage &img);

    // 存储成员
    QString m_videoFormat;
    //QString m_colorSpace;
    //QString m_colorDepth;
    QString m_hdrFormat;
    QString m_hdmiDvi;
    QString m_frlRate;
    QString m_dscMode;
    QString m_hdcpType;

    QString m_samplingFreq;
    QString m_samplingSize;
    QString m_channelCount;
    QString m_channelNumber;
    QString m_levelShift;
    QString m_cBitSamplingFreq;
    QString m_cBitDataType;

    // Monitor
    QString     m_monitorStartTime;
    int         m_timeSlotInterval = 1;
    bool        m_timeSlotInSeconds = true;
    int         m_triggerMode      = 0;
    QVariantList m_monitorSlotLabels;
    QVariantList m_monitorData;  // 每个元素是 { x: qreal, y: qreal }


    // 内部信号处理方法
    void processMonitorCommand(const QByteArray &data);
    void updateSlotData(const QString &slotId, const QString &stateStr);
    void updateMonitorDataFromTimeSlots();
    bool detectTriggerEvent(const QByteArray &currentFrame, const QByteArray &previousFrame);
    bool isSignalLost(const QByteArray &frame);
    
    // 其他私有成员变量
    QVector<SignalTimeSlot> m_signalTimeSlots; // 存储完整网格数据
    QMap<QString, int> m_slotIndexMap;         // 映射槽ID到索引
    static const int DIFF_THRESHOLD = 10000;          // 图像差异阈值
};

#endif // SIGNALANALYZERMANAGER_H
