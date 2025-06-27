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
#include <QThread>
#include <QMutex>
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
    , m_lastImageData()
    , m_highFrameRateTimer(nullptr)
    , m_captureThread(nullptr)
    , m_isHighFrameRateMode(false)
    , m_frameBufferA()
    , m_frameBufferB()
    , m_useBufferA(true)
    , m_smoothCaptureProcess(nullptr)
{
    qDebug() << "SignalAnalyzerManager created";
    
    // 初始化PCIe刷新定时器
    m_pcieRefreshTimer = new QTimer(this);
    connect(m_pcieRefreshTimer, &QTimer::timeout, this, &SignalAnalyzerManager::onPcieRefreshTimer);
    
    // 初始化PCIe进程
    m_pcieProcess = new QProcess(this);
    
    // 初始化高帧率采集定时器
    m_highFrameRateTimer = new QTimer(this);
    connect(m_highFrameRateTimer, &QTimer::timeout, this, &SignalAnalyzerManager::onHighFrameRateTimer);
    
    // 初始化丝滑模式专用进程
    m_smoothCaptureProcess = new QProcess(this);
    
    // 初始化EDID列表
    // QStringList edidNames = {"1080p60", "1080p50", "720p60", "720p50", "4K30", "4K60"};
    QStringList edidNames = {"FRL48G_8K_2CH_HDR_DSC","FRL48G_8K_2CH_HDR","FRL40G_8K_2CH_HDR","4K60HZ_2CH",
    "4K60HZ(Y420)_2CH","4K30HZ_2CH","1080P_2CH","USER1","USER2","USER3","USER4","USER5","USER6","USER7","USER8","USER9","USER10"};
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
    // 使用时间戳生成唯一文件名，确保URL变化触发QML重新加载
    static int counter = 0;
    QString tempDir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    QString fileName = QString("pcie_monitor_frame_%1.png").arg(++counter);
    QString tempFilePath = QDir(tempDir).absoluteFilePath(fileName);
    
    // 使用PNG格式并设置压缩质量，平衡文件大小和保存速度
    if (img.save(tempFilePath, "PNG", 50)) {  // 50%压缩质量，更快的保存速度
        
        // 清理旧的临时文件，保留最近的几个
        static QStringList recentFiles;
        recentFiles.append(tempFilePath);
        if (recentFiles.size() > 3) {  // 只保留最近3个文件
            QString oldFile = recentFiles.takeFirst();
            QFile::remove(oldFile);
        }
        
        return QString("file://") + tempFilePath;
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
    
    // 检查图像是否有变化，无变化则不更新显示
    if (!hasImageChanged(imageData)) {
        //qDebug() << "Image data unchanged, skipping update";
        return;
    }
    
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
    
    // 直接使用1080p图像，QML层会处理底部120px信息区域
    //qDebug() << "Using 1080p image directly, QML handles bottom info area";
    
    // 更新帧URL以显示图像
    updateFrame(image);
    
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
    // 注意：调整刷新频率请修改这里的数值（单位：毫秒）
    // 建议值：500ms（默认）、1000ms（较慢）、250ms（较快，可能闪烁）
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
    
    // 清除上次的图像数据，确保下次启动时能正常检测变化
    m_lastImageData.clear();
    
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
    //qDebug() << "=== executePcieCommand START ===";
    
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
    
    //qDebug() << "=== executePcieCommand END ===";
}

void SignalAnalyzerManager::onPcieRefreshTimer()
{
    //qDebug() << "PCIe refresh timer triggered";
    
    if (m_pcieCapturing) {
        executePcieCommand();
    }
}

bool SignalAnalyzerManager::hasImageChanged(const QByteArray &newImageData)
{
    // 如果是第一次加载图像
    if (m_lastImageData.isEmpty()) {
        m_lastImageData = newImageData;
        return true;
    }
    
    // 比较图像数据大小
    if (m_lastImageData.size() != newImageData.size()) {
        m_lastImageData = newImageData;
        return true;
    }
    
    // 使用Qt的直接比较，这是最可靠的字节级比较
    bool hasChanged = (m_lastImageData != newImageData);
    
    if (hasChanged) {
        m_lastImageData = newImageData;
        qDebug() << "Image data changed, size:" << newImageData.size();
    }
    
    return hasChanged;
}

// =========================== 高帧率丝滑动图显示实现 ===========================

// 启动丝滑动图模式 - 对外接口
void SignalAnalyzerManager::startSmoothVideoMode()
{
    qDebug() << "=== startSmoothVideoMode START ===";
    
    if (m_isHighFrameRateMode) {
        qDebug() << "Smooth video mode already running";
        return;
    }
    
    // 停止原有的低帧率采集
    if (m_pcieCapturing) {
        stopPcieImageCapture();
    }
    
    m_isHighFrameRateMode = true;
    startHighFrameRateCapture();
    
    // 发送状态变化信号
    emit smoothVideoModeChanged();
    
    qDebug() << "=== startSmoothVideoMode END ===";
}

// 停止丝滑动图模式 - 对外接口
void SignalAnalyzerManager::stopSmoothVideoMode()
{
    qDebug() << "=== stopSmoothVideoMode START ===";
    
    if (!m_isHighFrameRateMode) {
        qDebug() << "Smooth video mode not running";
        return;
    }
    
    stopHighFrameRateCapture();
    m_isHighFrameRateMode = false;
    
    // 发送状态变化信号
    emit smoothVideoModeChanged();
    
    // 恢复原有的低帧率采集
    startPcieImageCapture();
    
    qDebug() << "=== stopSmoothVideoMode END ===";
}

// 查询是否在丝滑动图模式
bool SignalAnalyzerManager::isSmoothVideoMode() const
{
    return m_isHighFrameRateMode;
}

// 启动高帧率采集 - 内部实现
void SignalAnalyzerManager::startHighFrameRateCapture()
{
    qDebug() << "=== startHighFrameRateCapture START ===";
    
    // 预分配双缓冲区
    m_frameBufferA.reserve(6220800);  // 1920*1080*3
    m_frameBufferB.reserve(6220800);
    m_useBufferA = true;
    
    // 启动采集定时器 - 10fps是一个更保守的平衡点
    // 比0.5秒一次的2fps提升5倍，性能开销适中
    int frameInterval = 100; // 100ms ≈ 10fps (1000/10=100)
    m_highFrameRateTimer->start(frameInterval);
    
    qDebug() << "High frame rate capture started at 10fps (" << frameInterval << "ms interval)";
    qDebug() << "=== startHighFrameRateCapture END ===";
}

// 停止高帧率采集 - 内部实现  
void SignalAnalyzerManager::stopHighFrameRateCapture()
{
    qDebug() << "=== stopHighFrameRateCapture START ===";
    
    if (m_highFrameRateTimer && m_highFrameRateTimer->isActive()) {
        m_highFrameRateTimer->stop();
        qDebug() << "High frame rate timer stopped";
    }
    
    // 强制停止正在运行的采集进程
    if (m_smoothCaptureProcess && m_smoothCaptureProcess->state() != QProcess::NotRunning) {
        qDebug() << "Terminating running capture process";
        m_smoothCaptureProcess->kill();
        m_smoothCaptureProcess->waitForFinished(1000);
    }
    
    // 清理缓冲区
    m_frameBufferA.clear();
    m_frameBufferB.clear();
    
    qDebug() << "=== stopHighFrameRateCapture END ===";
}

// 高帧率定时器回调 - 先确保有初始数据，然后交替采集显示
void SignalAnalyzerManager::onHighFrameRateTimer()
{
    static bool hasInitialData = false;
    static bool shouldCapture = true;
    
    // 如果还没有初始数据，强制采集一次
    if (!hasInitialData) {
        captureFrameToBuffer();
        hasInitialData = true;
        qDebug() << "Initial frame captured for smooth mode";
        return;
    }
    
    // 有了初始数据后，采用交替策略
    if (shouldCapture) {
        captureFrameToBuffer();
    } else {
        displayFrameFromBuffer();
    }
    
    shouldCapture = !shouldCapture; // 下次执行相反操作
}

// 采集帧到缓冲区 - 后台操作，不阻塞显示
void SignalAnalyzerManager::captureFrameToBuffer()
{
    // 如果上次进程还在运行，直接跳过本次采集，避免进程堆积
    if (m_smoothCaptureProcess->state() != QProcess::NotRunning) {
        qDebug() << "Previous capture still running, skipping this capture";
        return;
    }
    
    qDebug() << "Starting new frame capture...";
    
    // 选择当前要写入的缓冲区（非显示缓冲区）
    QByteArray* writeBuffer = m_useBufferA ? &m_frameBufferB : &m_frameBufferA;
    
    // 使用复用的进程执行DMA读取
    QString command = "/usr/local/xdma/tools/dma_from_device";
    QStringList arguments;
    arguments << "/dev/xdma0_c2h_0"
              << "-f" << "/tmp/smooth_frame.bin"  // 使用固定文件名减少创建开销
              << "-s" << "6220800"
              << "-a" << "0" 
              << "-c" << "1";
    
    // 启动进程（非阻塞）
    m_smoothCaptureProcess->start(command, arguments);
    
    // 非阻塞等待，避免卡死
    if (m_smoothCaptureProcess->waitForFinished(50)) { // 增加到50ms超时
        if (m_smoothCaptureProcess->exitCode() == 0) {
            // 读取到缓冲区
            QFile tempFile("/tmp/smooth_frame.bin");
            if (tempFile.open(QIODevice::ReadOnly)) {
                *writeBuffer = tempFile.readAll();
                tempFile.close();
                
                qDebug() << "Frame captured successfully, size:" << writeBuffer->size();
                
                // 交换缓冲区指针（原子操作）
                QMutexLocker locker(&m_bufferMutex);
                m_useBufferA = !m_useBufferA;
            } else {
                qDebug() << "Failed to open captured frame file";
            }
        } else {
            qDebug() << "Capture process failed with exit code:" << m_smoothCaptureProcess->exitCode();
        }
    } else {
        qDebug() << "Capture process timeout or error";
        // 超时或出错，强制终止进程避免泄漏
        if (m_smoothCaptureProcess->state() != QProcess::NotRunning) {
            m_smoothCaptureProcess->kill();
            m_smoothCaptureProcess->waitForFinished(100);
        }
    }
}

// 从缓冲区显示帧 - 前台操作，快速显示
void SignalAnalyzerManager::displayFrameFromBuffer()
{
    QMutexLocker locker(&m_bufferMutex);
    
    // 选择当前要显示的缓冲区
    const QByteArray* readBuffer = m_useBufferA ? &m_frameBufferA : &m_frameBufferB;
    
    if (readBuffer->isEmpty() || readBuffer->size() < 6220800) {
        qDebug() << "No valid buffer data for display, buffer size:" << readBuffer->size();
        return; // 无有效数据
    }
    
    // 直接调用普通模式的处理逻辑，确保一致性
    // 创建临时文件让loadAndDisplayBinFile处理
    QString tempPath = "/tmp/smooth_display_temp.bin";
    QFile tempFile(tempPath);
    if (tempFile.open(QIODevice::WriteOnly)) {
        tempFile.write(*readBuffer);
        tempFile.close();
        
        qDebug() << "Created temp file for smooth display, calling loadAndDisplayBinFile";
        
        // 复用已验证工作的普通模式逻辑
        loadAndDisplayBinFile(tempPath);
        
        // 删除临时文件
        QFile::remove(tempPath);
    } else {
        qDebug() << "Failed to create temp file for smooth display";
    }
    
    // 更新信号状态
    if (m_signalStatus != "Smooth Video Mode") {
        m_signalStatus = "Smooth Video Mode";
        m_resolution = "1920x1080@10fps";
        m_colorSpace = "RGB"; 
        m_colorDepth = "8bit";
        m_videoSignalInfo = "A<Smooth Video Mode - 10fps High Frame Rate Display>";
        
        emit signalStatusChanged();
        emit resolutionChanged();
        emit colorSpaceChanged();
        emit colorDepthChanged();
        emit videoSignalInfoChanged();
    }
}