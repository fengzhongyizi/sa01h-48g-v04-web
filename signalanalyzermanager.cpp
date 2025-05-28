#include "signalanalyzermanager.h"
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QDateTime>
#include <QVariantMap>
#include <QThread>
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
    // 先检查标志位，快速返回
    if (frame.size() > 4 && (static_cast<quint8>(frame[4]) & 0x01) == 0) {
        return true;
    }

    // 仅在必要时检查帧内容
    if (frame.size() <= 100) return false; // 避免误判小帧
    
    // 只采样检查，不必检查全部数据
    int sampleSize = qMin(frame.size(), 1024);
    int sampleStep = qMax(1, sampleSize / 100);
    int zeroCount = 0;
    
    for (int i = 0; i < sampleSize; i += sampleStep) {
        if (frame[i] == 0) zeroCount++;
        }
    
    return (zeroCount * sampleStep > sampleSize * 0.95); // 95%以上为0判定为信号丢失
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
        // 使用新的指令格式：START SIGNAL MONITOR <INTERVAL> <UNIT> <MODE>
        QString unit = m_timeSlotInSeconds ? "SECONDS" : "MINUTES";
        QString cmd = QString("START SIGNAL MONITOR %1 %2 %3\r\n")
                          .arg(m_timeSlotInterval)
                          .arg(unit)
                          .arg(m_triggerMode);
        
        m_serialPortManager->writeDataUart5(cmd, 1);
        qDebug() << "Starting monitor with command:" << cmd;
    }
    else
    {
        qWarning() << "Cannot start monitor: serial port unavailable";
    }

    // 清空已有数据
    m_monitorSlotLabels.clear();
    m_monitorData.clear();
    emit monitorDataChanged();
}

// 停止当前监测
void SignalAnalyzerManager::stopMonitor()
{
    if (m_serialPortManager && m_serialPortManager->isUart5Available())
    {
        m_serialPortManager->writeDataUart5("STOP SIGNAL MONITOR\r\n", 1);
        qDebug() << "Monitor stopped at" << QTime::currentTime().toString("hh:mm:ss");
    }
    else
    {
        qWarning() << "Cannot stop monitor: serial port unavailable";
    }
}

// 清除监测数据
void SignalAnalyzerManager::clearMonitorData()
{
    if (m_serialPortManager && m_serialPortManager->isUart5Available())
    {
        m_serialPortManager->writeDataUart5("CLEAR MONITOR DATA\r\n", 1);
        qDebug() << "Clear monitor data command sent";
    }
    
    // 清空本地数据结构
    m_signalTimeSlots.clear();
    m_slotIndexMap.clear();
    
    // 清空QML绑定的数据
    m_monitorSlotLabels.clear();
    m_monitorData.clear();
    
    // 通知UI更新
    emit monitorDataChanged();
    
    qDebug() << "Monitor data cleared";
}

// 修改时间槽间隔
void SignalAnalyzerManager::setTimeSlotInterval(int secs)
{
    if (m_timeSlotInterval != secs)
    {
        m_timeSlotInterval = secs;
        emit timeSlotIntervalChanged();
        qDebug() << "Time slot interval changed to:" << secs;
    }
}

// 修改单位（秒/分）
void SignalAnalyzerManager::setTimeSlotUnit(bool inSeconds)
{
    if (m_timeSlotInSeconds != inSeconds)
    {
        m_timeSlotInSeconds = inSeconds;
        emit timeSlotIntervalChanged();
        qDebug() << "Time slot unit changed to:" << (inSeconds ? "seconds" : "minutes");
    }
}

// 修改触发模式
void SignalAnalyzerManager::setTriggerMode(int mode)
{
    if (m_triggerMode != mode)
    {
        m_triggerMode = mode;
        emit triggerModeChanged();
        qDebug() << "Trigger mode changed to:" << mode;
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

// 修改 applyEdid 方法使用正确的SET指令格式
void SignalAnalyzerManager::applyEdid()
{
    if (!m_serialPortManager)
        return;

    // 查找选中的项
    int selectedIndex = -1;
    for (int i = 0; i < m_edidItems.size(); ++i)
    {
        if (m_edidItems[i].selected)
        {
            selectedIndex = i;
            break;
        }
    }

    if (selectedIndex >= 0)
    {
        // 使用SET IN1 EDID[0-16]格式
        QString cmd = QString("SET IN1 EDID%1\r\n").arg(selectedIndex);
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
    // 保存批次标签
    QVariantList labels;
    for (const QString &label : slotLabels) {
        labels.append(label); 
    }
    m_monitorSlotLabels = labels;

    // 将所有数据点转换为线性序列，不再使用坐标系
    // 只需要知道哪些位置有数据点，由前端决定如何分行显示
    QVariantList dataPoints;
    
    // 收集所有需要显示的索引点
    QSet<int> indices;
    for (const QPointF &p : data) {
        int slotIndex = static_cast<int>(p.y());
        int timeIndex = static_cast<int>(p.x());
        
        // 计算线性索引 (每个批次最多100个点)
        int linearIndex = slotIndex * 100 + timeIndex;
        indices.insert(linearIndex);
    }
    
    // 将所有索引点按顺序添加到列表中
    QList<int> sortedIndices = indices.toList();
    std::sort(sortedIndices.begin(), sortedIndices.end());
    
    for (int index : sortedIndices) {
        dataPoints.append(index);
    }
    
    // 如果没有数据，添加一些示例数据点
    if (dataPoints.isEmpty()) {
        for (int i = 0; i < 200; ++i) {
            dataPoints.append(i);
        }
    }
    
    m_monitorData = dataPoints;
    emit monitorDataChanged();
}

void SignalAnalyzerManager::startFpgaVideo()
{
    // 首先尝试使用PCIe视频接收（优先选择）
    if (m_serialPortManager && m_serialPortManager->pcieVideoEnabled()) {
        qDebug() << "Using PCIe video capture mode";
        
        // 确保PCIe设备已连接
        if (!m_serialPortManager->pcieVideoConnected()) {
            bool connected = m_serialPortManager->connectPcieVideoDevice();
            if (!connected) {
                qWarning() << "Failed to connect PCIe video device, falling back to UART3";
                // 如果PCIe连接失败，降级使用串口方式
                startFpgaVideoViaUart();
                return;
            }
        }
        
        // 设置适当的视频格式
        m_serialPortManager->setPcieVideoFormat(1920, 1080, 60, "RGB24");
        
        // 开始PCIe视频流
        m_serialPortManager->startPcieVideoStream();
        
        // 更新状态信息
        m_signalStatus = "PCIe Active";
        emit signalStatusChanged();
        
        qDebug() << "PCIe video stream started successfully";
    }
    else {
        // 如果PCIe未启用，使用原有的串口方式
        qDebug() << "PCIe video not enabled, using UART3 mode";
        startFpgaVideoViaUart();
    }
}

// 新增方法：通过串口方式获取FPGA视频数据
void SignalAnalyzerManager::startFpgaVideoViaUart()
{
    // 向FPGA发送命令以获取新的帧数据 - 使用UART3连接FPGA
    if (m_serialPortManager && m_serialPortManager->isUart3Available()) {
        // 发送刷新帧命令到FPGA (通过UART3)
        m_serialPortManager->writeData("AA 00 00 06 00 00 00 B1 00 01", 0);
        qDebug() << "Sent FPGA video refresh command via UART3";

        // 更新状态信息
        m_signalStatus = "UART3 Active";
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
        qDebug() << "Cannot refresh frame: UART3 serial port unavailable";
        m_signalStatus = "Disconnected";
        emit signalStatusChanged();
    }
}

// Signal Info - 从MCU获取信号信息
void SignalAnalyzerManager::refreshSignalInfo()
{
    if (m_serialPortManager && m_serialPortManager->isUart5Available()) {
        // 从MCU (通过UART5) 获取各种信号信息
        qDebug() << "Requesting signal info from MCU via UART5";
        
        // 请求视频信息
        m_serialPortManager->writeDataUart5("GET SIGNAL VIDEO_FORMAT\r\n", 1);
        QThread::msleep(50);  // 小延迟避免命令冲突
        
        m_serialPortManager->writeDataUart5("GET SIGNAL COLOR_SPACE\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL COLOR_DEPTH\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL HDR_FORMAT\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL HDMI_DVI\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL FRL_RATE\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL DSC_MODE\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL HDCP_TYPE\r\n", 1);
        QThread::msleep(50);
        
        // 请求音频信息
        m_serialPortManager->writeDataUart5("GET SIGNAL SAMPLING_FREQ\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL SAMPLING_SIZE\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL CHANNEL_COUNT\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL CHANNEL_NUMBER\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL LEVEL_SHIFT\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL CBIT_SAMPLING_FREQ\r\n", 1);
        QThread::msleep(50);
        
        m_serialPortManager->writeDataUart5("GET SIGNAL CBIT_DATA_TYPE\r\n", 1);
        
        qDebug() << "All signal info requests sent to MCU";
    } else {
        qWarning() << "Cannot refresh signal info: MCU serial port unavailable";
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
    // 连接串口管理器的信号监控数据接收信号
    connect(m_serialPortManager, &SerialPortManager::signalMonitorDataReceived,
            this, &SignalAnalyzerManager::processMonitorCommand);
            
    // 连接PCIe视频相关信号
    connect(m_serialPortManager, &SerialPortManager::pcieFrameReceived,
            this, &SignalAnalyzerManager::updateFrame);
    connect(m_serialPortManager, &SerialPortManager::pcieVideoError,
            [this](const QString &error) {
                qWarning() << "PCIe Video Error in SignalAnalyzerManager:" << error;
                // 如果PCIe出错，可以尝试切换到串口模式
                if (m_serialPortManager->pcieVideoStreaming()) {
                    qDebug() << "PCIe error detected, attempting fallback to UART3";
                    startFpgaVideoViaUart();
                }
            });
    
    // … 原有信号/槽连接和初始化无需改动 …
    // 测试用静态数据，页面打开就能看到复选框
    qDebug() << "SerialPortManager pointer:" << (m_serialPortManager ? "valid" : "nullptr");
    QStringList presetEdidList = {
        "FRL10G_8K_2CH_HDR",
        "4K60HZ_3D_2CH_HDR", 
        "4K60HZY420_3D_2CH",
        "4K30HZ_3D_2CH",
        "1080P_3D_2CH",
        "1080_2CH",
        "USER1", "USER2", "USER3", "USER4", "USER5", 
        "USER6", "USER7", "USER8", "USER9", "USER10"
    };
    updateEdidList(presetEdidList);
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
