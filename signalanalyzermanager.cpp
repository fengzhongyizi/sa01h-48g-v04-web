#include "signalanalyzermanager.h"
#include <QDebug>
#include <QStandardPaths>
#include <QDir>
#include <QTimer>
#include <QDateTime>
#include <QFile>
#include <QPainter>
#include <QProcess>
#include <QFileInfo>
#include <cstring>

SignalAnalyzerManager::SignalAnalyzerManager(SerialPortManager* spMgr, QObject* parent)
    : QObject(parent)
    , m_serialPortManager(spMgr)
    , m_frameUrl("")
    , m_signalStatus("No Signal")
    , m_mode("Unknown")
    , m_resolution("Unknown")
    , m_inputType("Unknown")
    , m_hdcpVersion("Unknown")
    , m_colorSpace("Unknown")
    , m_colorDepth("Unknown")
    , m_bt2020Status("Unknown")
    , m_videoFormat("Unknown")
    , m_hdrFormat("Unknown")
    , m_hdmiDvi("Unknown")
    , m_frlRate("Unknown")
    , m_dscMode("Unknown")
    , m_hdcpType("Unknown")
    , m_samplingFreq("Unknown")
    , m_samplingSize("Unknown")
    , m_channelCount("Unknown")
    , m_channelNumber("Unknown")
    , m_levelShift("Unknown")
    , m_cBitSamplingFreq("Unknown")
    , m_cBitDataType("Unknown")
    , m_monitorStartTime("")
    , m_timeSlotInterval(1)
    , m_timeSlotInSeconds(true)
    , m_triggerMode(0)
    , m_monitorRunning(false)
    , m_videoSignalInfo("")
    , m_pcieRefreshTimer(nullptr)
    , m_pcieProcess(nullptr)
    , m_pcieCapturing(false)
{
    qDebug() << "SignalAnalyzerManager created";
    
    // 初始化PCIe刷新定时器
    m_pcieRefreshTimer = new QTimer(this);
    connect(m_pcieRefreshTimer, &QTimer::timeout, this, &SignalAnalyzerManager::onPcieRefreshTimer);
    
    // 初始化PCIe进程
    m_pcieProcess = new QProcess(this);
    
    // 初始化EDID列表
    QStringList edidNames = {"1080p60", "1080p50", "720p60", "720p50", "4K30", "4K60"};
    for (const QString &name : edidNames) {
        EdidItem item;
        item.name = name;
        item.selected = false;
        m_edidItems.append(item);
    }
}

QVariantList SignalAnalyzerManager::edidList() const
{
    QVariantList list;
    for (const EdidItem &item : m_edidItems) {
        QVariantMap map;
        map["name"] = item.name;
        map["selected"] = item.selected;
        list.append(map);
    }
    return list;
}

void SignalAnalyzerManager::setEdidSelected(int index, bool selected)
{
    if (index >= 0 && index < m_edidItems.size()) {
        m_edidItems[index].selected = selected;
        emit edidListChanged();
    }
}

void SignalAnalyzerManager::applyEdid()
{
    qDebug() << "Applying EDID...";
    // TODO: 实现EDID应用逻辑
}

void SignalAnalyzerManager::selectSingleEdid(int index)
{
    // 取消所有选择
    for (EdidItem &item : m_edidItems) {
        item.selected = false;
    }
    
    // 选择指定的EDID
    if (index >= 0 && index < m_edidItems.size()) {
        m_edidItems[index].selected = true;
    }
    
    emit edidListChanged();
}

void SignalAnalyzerManager::startFpgaVideo()
{
    qDebug() << "=== startFpgaVideo called ===";
    qDebug() << "Starting FPGA video capture from PCIe...";
    
    // 启动PCIe图像获取
    startPcieImageCapture();
    
    qDebug() << "=== startFpgaVideo completed ===";
}

void SignalAnalyzerManager::startFpgaVideoViaUart()
{
    qDebug() << "Starting FPGA video capture via UART...";
    // TODO: 实现通过UART的FPGA视频捕获
}

void SignalAnalyzerManager::refreshSignalInfo()
{
    qDebug() << "Refreshing signal info...";
    // TODO: 实现信号信息刷新
    // 暂时设置一些模拟数据
    m_signalStatus = "Signal Detected";
    m_resolution = "1920x1080p60";
    m_colorSpace = "YUV444";
    m_colorDepth = "8bit";
    
    emit signalStatusChanged();
    emit resolutionChanged();
    emit colorSpaceChanged();
    emit colorDepthChanged();
}

void SignalAnalyzerManager::startMonitor()
{
    qDebug() << "Starting monitor...";
    m_monitorRunning = true;
    m_monitorStartTime = QDateTime::currentDateTime().toString("hh:mm:ss");
    emit monitorStartTimeChanged();
    
    // TODO: 实现监控逻辑
}

void SignalAnalyzerManager::stopMonitor()
{
    qDebug() << "Stopping monitor...";
    m_monitorRunning = false;
}

void SignalAnalyzerManager::clearMonitorData()
{
    qDebug() << "Clearing monitor data...";
    m_monitorSlotLabels.clear();
    m_monitorData.clear();
    m_timeSlots.clear();
    emit monitorDataChanged();
}

void SignalAnalyzerManager::setTimeSlotInterval(int secs)
{
    m_timeSlotInterval = secs;
    emit timeSlotIntervalChanged();
}

void SignalAnalyzerManager::setTimeSlotUnit(bool inSeconds)
{
    m_timeSlotInSeconds = inSeconds;
    emit timeSlotInSecondsChanged();
}

void SignalAnalyzerManager::setTriggerMode(int mode)
{
    m_triggerMode = mode;
    emit triggerModeChanged();
}

bool SignalAnalyzerManager::exportMonitorData(const QString &filePath)
{
    qDebug() << "Exporting monitor data to:" << filePath;
    // TODO: 实现数据导出
    return true;
}

void SignalAnalyzerManager::updateFrame(const QImage &img)
{
    QString url = saveTempImageAndGetUrl(img);
    if (url != m_frameUrl) {
        m_frameUrl = url;
        emit frameUrlChanged();
    }
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
    bool changed = false;
    
    if (m_signalStatus != status) {
        m_signalStatus = status;
        emit signalStatusChanged();
        changed = true;
    }
    
    if (m_mode != mode) {
        m_mode = mode;
        emit modeChanged();
        changed = true;
    }
    
    if (m_resolution != res) {
        m_resolution = res;
        emit resolutionChanged();
        changed = true;
    }
    
    if (m_inputType != type) {
        m_inputType = type;
        emit inputTypeChanged();
        changed = true;
    }
    
    if (m_hdcpVersion != hdcp) {
        m_hdcpVersion = hdcp;
        emit hdcpVersionChanged();
        changed = true;
    }
    
    if (m_colorSpace != cs) {
        m_colorSpace = cs;
        emit colorSpaceChanged();
        changed = true;
    }
    
    if (m_colorDepth != cd) {
        m_colorDepth = cd;
        emit colorDepthChanged();
        changed = true;
    }
    
    if (m_bt2020Status != bt2020) {
        m_bt2020Status = bt2020;
        emit bt2020StatusChanged();
        changed = true;
    }
}

void SignalAnalyzerManager::updateSignalInfo(const QVariantMap &info)
{
    // TODO: 实现信号信息更新
    qDebug() << "Updating signal info:" << info;
}

void SignalAnalyzerManager::updateEdidList(const QStringList &edidData)
{
    // TODO: 实现EDID列表更新
    qDebug() << "Updating EDID list:" << edidData;
}

void SignalAnalyzerManager::updateMonitorData(const QStringList &slotLabels, const QList<QPointF> &data)
{
    // TODO: 实现监控数据更新
    qDebug() << "Updating monitor data";
}

QString SignalAnalyzerManager::saveTempImageAndGetUrl(const QImage &img)
{
    static int counter = 0;
    QString tempDir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    QString fileName = QString("signal_frame_%1.png").arg(counter++);
    QString filePath = QDir(tempDir).absoluteFilePath(fileName);
    
    if (img.save(filePath)) {
        return QString("file://") + filePath;
    }
    
    return QString();
}

void SignalAnalyzerManager::processMonitorCommand(const QByteArray &data)
{
    // TODO: 实现监控命令处理
}

void SignalAnalyzerManager::updateSlotData(const QString &slotId, const QString &stateStr)
{
    // TODO: 实现时间槽数据更新
}

void SignalAnalyzerManager::updateSlotError(const QString &slotId, int slotIndex, int statusValue)
{
    // TODO: 实现时间槽错误更新
}

void SignalAnalyzerManager::updateMonitorDataFromTimeSlots()
{
    // TODO: 实现从时间槽更新监控数据
}

bool SignalAnalyzerManager::detectTriggerEvent(const QByteArray &currentFrame, const QByteArray &previousFrame)
{
    // TODO: 实现触发事件检测
    return false;
}

bool SignalAnalyzerManager::isSignalLost(const QByteArray &frame)
{
    // TODO: 实现信号丢失检测
    return false;
}

void SignalAnalyzerManager::loadAndDisplayBinFile(const QString &filePath)
{
    //qDebug() << "=== loadAndDisplayBinFile START ===";
    //qDebug() << "Attempting to load bin file:" << filePath;
    
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "FAILED to open bin file:" << filePath;
        qDebug() << "Error:" << file.errorString();
        // 如果无法打开文件，显示黑屏
        displayBlackScreen();
        return;
    }
    
    QByteArray imageData = file.readAll();
    file.close();
    
    //qDebug() << "Successfully read bin file, size:" << imageData.size() << "bytes";
    
    // 1080p60_8bit.bin是1920x1080的RGB格式
    int width = 1920;
    int height = 1080;
    int bytesPerPixel = 3; // RGB 8bit
    int expectedSize = width * height * bytesPerPixel;
    
    //qDebug() << "Expected size for 1920x1080 RGB:" << expectedSize << "bytes";
    
    if (imageData.size() < expectedSize) {
        qDebug() << "WARNING: Bin file size is smaller than expected";
        qDebug() << "Actual size:" << imageData.size() << "Expected:" << expectedSize;
        // 即使文件小于预期，也尝试处理
    }
    
    // 创建QImage
    QImage image(width, height, QImage::Format_RGB888);
    //qDebug() << "Created QImage with size:" << image.size();
    
    // 优化的数据复制方式
    int actualPixels = qMin(imageData.size() / bytesPerPixel, width * height);
    //qDebug() << "Will process" << actualPixels << "pixels";
    
    // 直接使用内存复制，更高效
    if (imageData.size() >= expectedSize) {
        // 文件大小足够，直接复制
        memcpy(image.bits(), imageData.constData(), expectedSize);
        qDebug() << "Used direct memory copy for full image";
    } else {
        // 文件大小不足，逐像素处理
        //qDebug() << "Using pixel-by-pixel copy due to insufficient data";
        image.fill(Qt::black); // 先填充黑色
        
        int dataIndex = 0;
        for (int y = 0; y < height && dataIndex + 2 < imageData.size(); y++) {
            for (int x = 0; x < width && dataIndex + 2 < imageData.size(); x++) {
                uchar r = static_cast<uchar>(imageData[dataIndex++]);
                uchar g = static_cast<uchar>(imageData[dataIndex++]);
                uchar b = static_cast<uchar>(imageData[dataIndex++]);
                image.setPixel(x, y, qRgb(r, g, b));
            }
        }
        qDebug() << "Processed" << dataIndex/3 << "pixels manually";
    }
    
    // 创建包含底部120像素黑边的最终图像（1920x1200）
    QImage finalImage(1920, 1200, QImage::Format_RGB888);
    finalImage.fill(Qt::black);  // 填充黑色
    
    // 将1080p图像绘制到最终图像的上部
    QPainter painter(&finalImage);
    painter.drawImage(0, 0, image);
    painter.end();
    
    //qDebug() << "Created final image with bottom black bar, size:" << finalImage.size();
    
    // 更新帧URL以显示图像
    //qDebug() << "Calling updateFrame to display image with bottom black bar";
    updateFrame(finalImage);
    
    // 更新信号状态
    m_signalStatus = "PCIe Monitor Display";
    m_resolution = "1920x1080@60Hz";
    m_colorSpace = "RGB";
    m_colorDepth = "8bit";
    
    // 更新视频信号信息字符串
    m_videoSignalInfo = "A<MODE:TMDS  DSC OFF  RES:1920*1080@60Hz TYPE:HDMI HDCP:V2.3 CS:RGB(0~255) CD:8Bit BT2020:Disable>";
    
    //qDebug() << "Updated signal status to:" << m_signalStatus;
    
    emit signalStatusChanged();
    emit resolutionChanged();
    emit colorSpaceChanged();
    emit colorDepthChanged();
    emit videoSignalInfoChanged();
    
    //qDebug() << "=== loadAndDisplayBinFile END ===";
}

void SignalAnalyzerManager::displayDefaultTestPattern()
{
    // 创建默认的测试图案（彩条）
    QImage testImage(1920, 1080, QImage::Format_RGB888);
    
    // 创建7色彩条
    QColor colors[7] = {
        QColor(192, 192, 0),   // 黄色
        QColor(0, 192, 192),   // 青色
        QColor(0, 192, 0),     // 绿色
        QColor(192, 0, 192),   // 洋红
        QColor(192, 0, 0),     // 红色
        QColor(0, 0, 192),     // 蓝色
        QColor(0, 0, 0)        // 黑色
    };
    
    int barWidth = 1920 / 7;
    for (int x = 0; x < 1920; x++) {
        int colorIndex = x / barWidth;
        if (colorIndex >= 7) colorIndex = 6;
        
        for (int y = 0; y < 1080; y++) {
            testImage.setPixel(x, y, colors[colorIndex].rgb());
        }
    }
    
    // 添加底部120像素黑边
    QImage finalImage(1920, 1200, QImage::Format_RGB888);
    finalImage.fill(Qt::black);
    
    QPainter painter(&finalImage);
    painter.drawImage(0, 0, testImage);
    painter.end();
    
    updateFrame(finalImage);
    
    m_signalStatus = "Test Pattern";
    m_resolution = "1920x1080@60Hz";
    emit signalStatusChanged();
    emit resolutionChanged();
}

void SignalAnalyzerManager::displayBlackScreen()
{
    qDebug() << "=== displayBlackScreen START ===";
    
    // 创建1920x1200的全黑图像（包含120像素底部黑边）
    QImage blackImage(1920, 1200, QImage::Format_RGB888);
    blackImage.fill(Qt::black);
    
    qDebug() << "Created black screen image with size:" << blackImage.size();
    
    updateFrame(blackImage);
    
    // 清除信号状态信息
    m_signalStatus = "No Signal";
    m_resolution = "";
    m_colorSpace = "";
    m_colorDepth = "";
    
    qDebug() << "Updated signal status to: No Signal";
    
    emit signalStatusChanged();
    emit resolutionChanged();
    emit colorSpaceChanged();
    emit colorDepthChanged();
    
    qDebug() << "=== displayBlackScreen END ===";
}

void SignalAnalyzerManager::displayNoSignal()
{
    qDebug() << "=== displayNoSignal START ===";
    
    // 清除帧URL，不需要创建图像
    m_frameUrl = "";
    
    qDebug() << "Cleared frame URL for no signal state";
    
    // 清除信号状态信息
    m_signalStatus = "No Signal";
    m_resolution = "";
    m_colorSpace = "";
    m_colorDepth = "";
    
    // 设置无信号时的视频信号信息
    m_videoSignalInfo = "A<No Signal>";
    
    qDebug() << "Updated signal status to: No Signal";
    
    emit frameUrlChanged();
    emit signalStatusChanged();
    emit resolutionChanged();
    emit colorSpaceChanged();
    emit colorDepthChanged();
    emit videoSignalInfoChanged();
    
    qDebug() << "=== displayNoSignal END ===";
}

// PCIe图像获取相关函数实现

void SignalAnalyzerManager::startPcieImageCapture()
{
    qDebug() << "=== startPcieImageCapture START ===";
    
    if (m_pcieCapturing) {
        qDebug() << "PCIe capture already running, stopping first";
        stopPcieImageCapture();
    }
    
    m_pcieCapturing = true;
    
    // 立即执行一次PCIe读取
    executePcieCommand();
    
    // 启动定时器，每500ms刷新一次图像
    m_pcieRefreshTimer->start(500);
    
    qDebug() << "PCIe image capture started with 500ms interval";
    qDebug() << "=== startPcieImageCapture END ===";
}

void SignalAnalyzerManager::stopPcieImageCapture()
{
    qDebug() << "=== stopPcieImageCapture START ===";
    
    if (!m_pcieCapturing) {
        qDebug() << "PCIe capture not running";
        return;
    }
    
    m_pcieCapturing = false;
    
    // 停止定时器
    if (m_pcieRefreshTimer->isActive()) {
        m_pcieRefreshTimer->stop();
        qDebug() << "PCIe refresh timer stopped";
    }
    
    // 如果进程还在运行，强制停止
    if (m_pcieProcess->state() != QProcess::NotRunning) {
        m_pcieProcess->kill();
        m_pcieProcess->waitForFinished(1000);
        qDebug() << "PCIe process terminated";
    }
    
    qDebug() << "=== stopPcieImageCapture END ===";
}

void SignalAnalyzerManager::refreshPcieImage()
{
    qDebug() << "=== refreshPcieImage START ===";
    
    if (!m_pcieCapturing) {
        qDebug() << "PCIe capture not active, starting...";
        startPcieImageCapture();
        return;
    }
    
    // 手动触发一次PCIe读取
    executePcieCommand();
    
    qDebug() << "=== refreshPcieImage END ===";
}

void SignalAnalyzerManager::executePcieCommand()
{
    qDebug() << "=== executePcieCommand START ===";
    
    // 检查进程是否还在运行
    if (m_pcieProcess->state() != QProcess::NotRunning) {
        qDebug() << "Previous PCIe command still running, skipping";
        return;
    }
    
    // 构建PCIe DMA读取命令
    QString command = "/usr/local/xdma/tools/dma_from_device";
    QStringList arguments;
    arguments << "/dev/xdma0_c2h_0"
              << "-f" << "/tmp/1080.bin"
              << "-s" << "6220800"  // 1920*1080*3字节的数据大小
              << "-a" << "0"
              << "-c" << "1";
    
    //qDebug() << "Executing PCIe command:" << command << arguments.join(" ");
    
    // 连接进程完成信号
    connect(m_pcieProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this](int exitCode, QProcess::ExitStatus exitStatus) {
        Q_UNUSED(exitStatus)
        
        if (exitCode == 0) {
            //qDebug() << "PCIe command completed successfully";
            
            // 检查生成的文件是否存在
            QFile tempFile("/tmp/1080.bin");
            if (tempFile.exists()) {
                //qDebug() << "PCIe image file created, size:" << tempFile.size() << "bytes";
                
                // 加载并显示图像
                loadAndDisplayBinFile("/tmp/1080.bin");
            } else {
                qDebug() << "ERROR: PCIe image file not created";
                displayNoSignal();
            }
        } else {
            qDebug() << "ERROR: PCIe command failed with exit code:" << exitCode;
            qDebug() << "Error output:" << m_pcieProcess->readAllStandardError();
            displayNoSignal();
        }
        
        // 断开信号连接
        disconnect(m_pcieProcess, nullptr, this, nullptr);
    });
    
    // 启动进程
    m_pcieProcess->start(command, arguments);
    
    if (!m_pcieProcess->waitForStarted(3000)) {
        qDebug() << "ERROR: Failed to start PCIe command";
        qDebug() << "Process error:" << m_pcieProcess->errorString();
        displayNoSignal();
    }
    
    qDebug() << "=== executePcieCommand END ===";
}

void SignalAnalyzerManager::onPcieRefreshTimer()
{
    //qDebug() << "PCIe refresh timer triggered";
    
    if (m_pcieCapturing) {
        executePcieCommand();
    }
}