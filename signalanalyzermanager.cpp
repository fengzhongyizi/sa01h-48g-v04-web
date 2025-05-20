#include "signalanalyzermanager.h"
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QDateTime>
#include <QVariantMap>
#include "serialportmanager.h"
#include <QDebug>
#include <QPainter>

// 事件处理功能
// 实现两种不同触发模式的检测逻辑：
bool SignalAnalyzerManager::detectTriggerEvent(const QByteArray &currentFrame,
                                               const QByteArray &previousFrame)
{
    if (m_triggerMode == 0)
    { // 图像差异+丢失信号
        // 检测图像差异
        int diffCount = 0;
        for (int i = 0; i < qMin(currentFrame.size(), previousFrame.size()); i++)
        {
            if (currentFrame[i] != previousFrame[i])
            {
                diffCount++;
            }
        }

        // 如果差异超过阈值或检测到信号丢失
        return (diffCount > DIFF_THRESHOLD) || isSignalLost(currentFrame);
    }
    else
    { // 仅丢失信号
        return isSignalLost(currentFrame);
    }
}

// 数据导出功能
bool SignalAnalyzerManager::exportMonitorData(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return false;

    QTextStream out(&file);

    // 写入表头
    out << "SlotID";
    for (int i = 0; i < 100; i++)
        out << "," << i * m_timeSlotInterval;
    out << "\n";

    // 写入数据
    for (const auto &slot : m_signalTimeSlots)
    {
        out << slot.slotId;
        for (bool state : slot.signalStates)
        {
            out << "," << (state ? "1" : "0");
        }
        out << "\n";
    }

    file.close();
    return true;
}

bool SignalAnalyzerManager::isSignalLost(const QByteArray &frame)
{
    // 检测信号丢失的实际逻辑
    // 几种可能的判断方法:

    // 方法1: 检查特定标志位
    // 通常硬件会在帧数据中包含信号状态指示位
    if (frame.size() > 4)
    { // 确保有足够数据
        // 假设第5个字节的第0位表示信号状态（0=无信号, 1=有信号）
        quint8 statusByte = static_cast<quint8>(frame[4]);
        if ((statusByte & 0x01) == 0)
        {
            return true; // 信号丢失
        }
    }

    // 方法2: 检查帧数据是否全黑或有特定模式
    // 全黑帧或特定模式通常表示无信号状态
    bool allZero = true;
    int checkBytes = qMin(frame.size(), 1024); // 限制检查前1KB
    for (int i = 0; i < checkBytes; i++)
    {
        if (frame[i] != 0)
        {
            allZero = false;
            break;
        }
    }
    if (allZero && frame.size() > 100)
    {                // 避免误判小帧
        return true; // 很可能信号丢失
    }

    return false; // 默认认为有信号
}

// 1.接收与解析数据
void SignalAnalyzerManager::processMonitorCommand(const QByteArray &data)
{
    // 解析来自硬件的信号监控数据
    // 格式可能类似: "SIGNAL_SLOT 0001 101010..."
    QString dataStr = QString::fromUtf8(data);
    QStringList parts = dataStr.split(" ");

    if (parts.size() >= 3 && parts[0] == "SIGNAL_SLOT")
    {
        QString slotId = parts[1];
        QString states = parts[2];

        // 更新指定时间槽的数据
        updateSlotData(slotId, states);
    }
}

/**
 * 2.更新时间槽数据
 */
void SignalAnalyzerManager::updateSlotData(const QString &slotId, const QString &stateStr)
{
    // 在m_signalTimeSlots中查找或创建对应slotId的记录
    int idx = -1;
    if (m_slotIndexMap.contains(slotId))
    {
        idx = m_slotIndexMap[slotId];
    }
    else
    {
        idx = m_signalTimeSlots.size();
        SignalTimeSlot newSlot;
        newSlot.slotId = slotId;
        // newSlot.signalStates.resize(100, false); // 默认100个时间点
        newSlot.signalStates = QVector<bool>(100, false);
        m_signalTimeSlots.append(newSlot);
        m_slotIndexMap[slotId] = idx;
    }

    // 更新该时间槽的状态数据
    for (int i = 0; i < qMin(stateStr.length(), 100); i++)
    {
        m_signalTimeSlots[idx].signalStates[i] = (stateStr[i] == '1');
    }

    // 转换为QML可用格式并发送通知
    updateMonitorDataFromTimeSlots();
}

/**
 * 3.将数据转换为QML可用格式
 */
void SignalAnalyzerManager::updateMonitorDataFromTimeSlots()
{
    // 提取所有槽标签
    QStringList labels;
    QList<QPointF> dataPoints;

    for (int slotIdx = 0; slotIdx < m_signalTimeSlots.size(); slotIdx++)
    {
        const auto &slot = m_signalTimeSlots[slotIdx];
        labels.append(slot.slotId);

        // 将每个槽的信号状态转换为点
        for (int timeIdx = 0; timeIdx < slot.signalStates.size(); timeIdx++)
        {
            if (slot.signalStates[timeIdx])
            {
                dataPoints.append(QPointF(timeIdx, slotIdx));
            }
        }
    }

    // 调用已有方法更新QML界面
    updateMonitorData(labels, dataPoints);
}

// 开始新的监测
void SignalAnalyzerManager::startMonitor()
{
    // 记录起始时间
    m_monitorStartTime = QTime::currentTime().toString("hh:mm:ss");
    emit monitorStartTimeChanged();

    if (m_serialPortManager && m_serialPortManager->isUart5Available())
    {
        m_serialPortManager->writeDataUart5("START MONITOR\r\n", 3);
    }
    else
    {
        qWarning() << "Cannot start monitor: serial port unavailable";
    }

    // 清掉已有曲线
    m_monitorSlotLabels.clear();
    m_monitorData.clear();
    emit monitorDataChanged();
}

// 修改时间槽间隔
void SignalAnalyzerManager::setTimeSlotInterval(int secs)
{
    if (m_timeSlotInterval != secs)
    {
        m_timeSlotInterval = secs;
        emit timeSlotIntervalChanged();
        // 发送给硬件：SET MONITOR SLOT <secs>
        if (m_serialPortManager)
        {
            m_serialPortManager->writeDataUart5(
                QString("SET MONITOR SLOT %1\r\n").arg(secs), 3);
        }
    }
}

// 修改单位（秒/分）
void SignalAnalyzerManager::setTimeSlotUnit(bool inSeconds)
{
    if (m_timeSlotInSeconds != inSeconds)
    {
        m_timeSlotInSeconds = inSeconds;
        emit timeSlotIntervalChanged();
        QString cmd = inSeconds
                          ? "SET MONITOR UNIT S\r\n"
                          : "SET MONITOR UNIT M\r\n";
        if (m_serialPortManager)
        {
            m_serialPortManager->writeDataUart5(cmd, 3);
        }
    }
}

// 修改触发模式
void SignalAnalyzerManager::setTriggerMode(int mode)
{
    if (m_triggerMode != mode)
    {
        m_triggerMode = mode;
        emit triggerModeChanged();
        // 0: 图像差分+掉帧, 1: 仅掉帧
        QString cmd = (mode == 0)
                          ? "SET MONITOR MODE DIFF\r\n"
                          : "SET MONITOR MODE LOSS\r\n";
        if (m_serialPortManager)
        {
            m_serialPortManager->writeDataUart5(cmd, 3);
        }
    }
}

// 新增方法实现，保证单选
void SignalAnalyzerManager::selectSingleEdid(int index)
{
    if (index < 0 || index >= m_edidItems.size())
        return;

    // 先取消选中所有项
    for (int i = 0; i < m_edidItems.size(); ++i)
    {
        m_edidItems[i].selected = false;
    }

    // 再选中当前项
    m_edidItems[index].selected = true;

    emit edidListChanged();
}

// 修改 applyEdid 方法，只应用一个选中项
void SignalAnalyzerManager::applyEdid()
{
    if (!m_serialPortManager)
        return;

    // 查找唯一选中的项
    int selectedIndex = -1;
    for (int i = 0; i < m_edidItems.size(); ++i)
    {
        if (m_edidItems[i].selected)
        {
            selectedIndex = i;
            break; // 找到第一个选中项就退出
        }
    }

    // 如果有选中项，发送命令
    if (selectedIndex >= 0)
    {
        QString cmd = QString("SET IN1 EDID%1\r\n").arg(selectedIndex + 1);
        m_serialPortManager->writeDataUart5(cmd, 1);
        qDebug() << "Applying EDID:" << m_edidItems[selectedIndex].name
                 << "with command:" << cmd;
    }
    else
    {
        qWarning() << "No EDID selected to apply";
    }
}
void SignalAnalyzerManager::updateMonitorData(const QStringList &slotLabels,
                                              const QList<QPointF> &data)
{
    // 把 QStringList 转为 QVariantList
    QVariantList labels;
    // 只取和 data 等长的前 N 条
    int N = qMin(slotLabels.size(), data.size());
    for (int i = 0; i < N; ++i)
    {
        labels.append(slotLabels.at(i)); // QVariant 自动从 QString 构造
    }
    m_monitorSlotLabels = labels;

    // data 转为 QVariantList of { x:…, y:… }
    QVariantList pts;
    for (const QPointF &p : data)
    {
        QVariantMap mp;
        mp["x"] = p.x();
        mp["y"] = p.y();
        pts.append(mp);
    }
    m_monitorData = pts;
    emit monitorDataChanged();
}

void SignalAnalyzerManager::startFpgaVideo()
{
    // 向设备发送命令以获取新的帧数据
    if (m_serialPortManager && m_serialPortManager->isUart5Available()) {
        // 发送刷新帧命令
        m_serialPortManager->writeDataUart5("REFRESH_FRAME\r\n", 3);
        qDebug() << "Sent REFRESH_FRAME command";

        // 更新状态信息
        m_signalStatus = "Active";
        emit signalStatusChanged();
        
        // 由于刚发送了命令，设备可能需要时间响应
        // 可以暂时设置一个测试帧或状态信息
        QImage testImage(1920, 1080, QImage::Format_RGB32);
        testImage.fill(Qt::black);
        
        // 在图像上绘制彩条
        QPainter painter(&testImage);
        int barWidth = testImage.width() / 7;
        QColor colors[] = {
            QColor(192, 192, 0),   // 黄色
            QColor(0, 192, 192),   // 青色
            QColor(0, 192, 0),     // 绿色
            QColor(192, 0, 192),   // 紫色
            QColor(192, 0, 0),     // 红色
            QColor(0, 0, 192),     // 蓝色
            QColor(0, 0, 0)        // 黑色
        };
        
        for (int i = 0; i < 7; i++) {
            painter.fillRect(i * barWidth, 0, barWidth, testImage.height(), colors[i]);
        }
        
        // 更新显示的图像
        updateFrame(testImage);
    } else {
        qDebug() << "Cannot refresh frame: serial port unavailable";
    }
}

QVariantList SignalAnalyzerManager::edidList() const
{
    QVariantList list;
    for (const auto &item : m_edidItems)
    {
        QVariantMap obj;
        obj["name"] = item.name;
        obj["selected"] = item.selected;
        list.append(obj);
    }
    return list;
}

void SignalAnalyzerManager::setEdidSelected(int index, bool selected)
{
    if (index < 0 || index >= m_edidItems.size())
        return;
    m_edidItems[index].selected = selected;
    emit edidListChanged();
}

void SignalAnalyzerManager::updateEdidList(const QStringList &edidData)
{
    m_edidItems.clear();
    
    // 添加所有选项，默认第一项选中
    bool isFirst = true;
    for (const QString &name : edidData) {
        m_edidItems.append({name, isFirst});
        isFirst = false;  // 只有第一项为 true
    }
    
    emit edidListChanged();
}

SignalAnalyzerManager::SignalAnalyzerManager(SerialPortManager *spMgr,
                                             QObject *parent)
    : QObject(parent), m_serialPortManager(spMgr) // ← 初始化串口管理器指针
{
    // 在构造函数中添加
    connect(m_serialPortManager, &SerialPortManager::signalMonitorDataReceived,
            this, &SignalAnalyzerManager::processMonitorCommand);
    // … 原有信号/槽连接和初始化无需改动 …
    // 测试用静态数据，页面打开就能看到复选框
    qDebug() << "SerialPortManager pointer:" << (m_serialPortManager ? "valid" : "nullptr");
    QStringList test = {
        "FRL48G_8K_2CH_HDR_DSC",
        "FRL48G_8K_2CH_HDR",
        "FRL40G_8K_2CH_HDR",
        "4K60HZ_2CH",
        "4K60HZ(Y420)_2CH",
        "4K30HZ_2CH",
        "1080P-2CH",
        "USER1", "USER2", "USER3", "USER4", "USER5", "USER6", "USER7", "USER8", "USER9", "USER10"};
    updateEdidList(test);
}

// 将 QImage 写入临时文件，并返回 file:// URL
QString SignalAnalyzerManager::saveTempImageAndGetUrl(const QImage &img)
{
    QString dir = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/sg_signal_analyzer";
    QDir().mkpath(dir);

    QString filePath = dir + "/" +
                       QDateTime::currentDateTime().toString("yyyyMMddhhmmsszzz") + ".png";
    img.save(filePath);
    return "file://" + filePath;
}

void SignalAnalyzerManager::updateFrame(const QImage &img)
{
    m_frameUrl = saveTempImageAndGetUrl(img);
    emit frameUrlChanged();
}

void SignalAnalyzerManager::updateInfo(const QString &status,
                                       const QString &mode,
                                       const QString &res,
                                       const QString &type,
                                       const QString &hdcp,
                                       const QString &cs,
                                       const QString &cd,
                                       const QString &bt2020)
{
    m_signalStatus = status;
    emit signalStatusChanged();
    m_mode = mode;
    emit modeChanged();
    m_resolution = res;
    emit resolutionChanged();
    m_inputType = type;
    emit inputTypeChanged();
    m_hdcpVersion = hdcp;
    emit hdcpVersionChanged();
    m_colorSpace = cs;
    emit colorSpaceChanged();
    m_colorDepth = cd;
    emit colorDepthChanged();
    m_bt2020Status = bt2020;
    emit bt2020StatusChanged();
}

// 统一从后台拿到 QVariantMap，Map 中 key 要和 Q_PROPERTY 名一致
void SignalAnalyzerManager::updateSignalInfo(const QVariantMap &info)
{
    // 只在值真的变动时才赋新值并 emit
    if (m_videoFormat != info.value("videoFormat").toString())
    {
        m_videoFormat = info.value("videoFormat").toString();
        emit videoFormatChanged();
    }
    if (m_colorSpace != info.value("colorSpace").toString())
    {
        m_colorSpace = info.value("colorSpace").toString();
        emit colorSpaceChanged();
    }
    // … 同理处理其它字段 …
    if (m_colorDepth != info.value("colorDepth").toString())
    {
        m_colorDepth = info.value("colorDepth").toString();
        emit colorDepthChanged();
    }
    if (m_hdrFormat != info.value("hdrFormat").toString())
    {
        m_hdrFormat = info.value("hdrFormat").toString();
        emit hdrFormatChanged();
    }
    if (m_hdmiDvi != info.value("hdmiDvi").toString())
    {
        m_hdmiDvi = info.value("hdmiDvi").toString();
        emit hdmiDviChanged();
    }
    if (m_frlRate != info.value("frlRate").toString())
    {
        m_frlRate = info.value("frlRate").toString();
        emit frlRateChanged();
    }
    if (m_dscMode != info.value("dscMode").toString())
    {
        m_dscMode = info.value("dscMode").toString();
        emit dscModeChanged();
    }
    if (m_hdcpType != info.value("hdcpType").toString())
    {
        m_hdcpType = info.value("hdcpType").toString();
        emit hdcpTypeChanged();
    }

    if (m_samplingFreq != info.value("samplingFreq").toString())
    {
        m_samplingFreq = info.value("samplingFreq").toString();
        emit samplingFreqChanged();
    }
    // … 继续处理 samplingSize、channelCount 等 …
    if (m_samplingSize != info.value("samplingSize").toString())
    {
        m_samplingSize = info.value("samplingSize").toString();
        emit samplingSizeChanged();
    }
    if (m_channelCount != info.value("channelCount").toString())
    {
        m_channelCount = info.value("channelCount").toString();
        emit channelCountChanged();
    }
    if (m_channelNumber != info.value("channelNumber").toString())
    {
        m_channelNumber = info.value("channelNumber").toString();
        emit channelNumberChanged();
    }
    if (m_levelShift != info.value("levelShift").toString())
    {
        m_levelShift = info.value("levelShift").toString();
        emit levelShiftChanged();
    }
    if (m_cBitSamplingFreq != info.value("cBitSamplingFreq").toString())
    {
        m_cBitSamplingFreq = info.value("cBitSamplingFreq").toString();
        emit cBitSamplingFreqChanged();
    }
    if (m_cBitDataType != info.value("cBitDataType").toString())
    {
        m_cBitDataType = info.value("cBitDataType").toString();
        emit cBitDataTypeChanged();
    }
}
