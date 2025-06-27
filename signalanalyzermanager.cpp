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
#include <QElapsedTimer>
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
    , m_frameCounter(0)
    , m_frameImage()
{
    qDebug() << "SignalAnalyzerManager created";
    
    // 预分配可复用的QImage对象，避免每次都重新创建
    m_reusableImage = QImage(1920, 1080, QImage::Format_RGB888);
    
    // 初始化PCIe刷新定时器
    m_pcieRefreshTimer = new QTimer(this);
    connect(m_pcieRefreshTimer, &QTimer::timeout, this, &SignalAnalyzerManager::onPcieRefreshTimer);
    
    // 初始化PCIe进程
    m_pcieProcess = new QProcess(this);
    
    // 启动性能计时器
    m_performanceTimer.start();
    
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
    QElapsedTimer timer;
    timer.start();
    
    // 完全去掉文件保存，使用静态图像文件路径
    // 这样QML能正常显示，但不会有文件保存的性能开销
    m_frameCounter++;
    
    // 使用预存的静态图像文件，通过URL参数变化触发QML刷新
    QString url = QString("file:///userdata/1080p60_8bit.bin?v=%1").arg(m_frameCounter);
    
    if (url != m_frameUrl) {
        m_frameUrl = url;
        emit frameUrlChanged();
    }
    
    qint64 updateTime = timer.elapsed();
    
    // 每50帧输出一次性能统计
    static int frameCount = 0;
    frameCount++;
    if (frameCount % 50 == 0) {
        qDebug() << QString("Frame %1 - UpdateFrame time: %2ms (No file save, static image)")
                      .arg(frameCount).arg(updateTime);
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
    // 使用高性能的临时文件管理策略
    static QString tempDir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    
    // 只使用2个交替的文件名，减少文件创建/删除开销
    QString fileName = QString("pcie_frame_%1.bmp").arg(m_frameCounter % 2);
    QString tempFilePath = QDir(tempDir).absoluteFilePath(fileName);
    
    // 增加帧计数器
    m_frameCounter++;
    
    // 测量保存时间
    QElapsedTimer saveTimer;
    saveTimer.start();
    
    // 使用BMP格式，无压缩，最快速度（虽然文件大但保存最快）
    bool saveSuccess = img.save(tempFilePath, "BMP");
    qint64 saveTime = saveTimer.elapsed();
    
    if (saveSuccess) {
        QString url = QString("file://") + tempFilePath;
        
        // 每10帧输出一次性能统计，更频繁监控保存性能
        if (m_frameCounter % 10 == 0) {
            qint64 elapsed = m_performanceTimer.elapsed();
            double avgFps = 10000.0 / elapsed;  // 10帧的平均FPS
            qDebug() << QString("Performance: Avg FPS for last 10 frames: %1, Last save time: %2ms")
                          .arg(QString::number(avgFps, 'f', 2))
                          .arg(saveTime);
            m_performanceTimer.restart();
        }
        
        return url;
    }
    
    qDebug() << "Failed to save image to:" << tempFilePath << "Save time:" << saveTime << "ms";
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
    // 性能计时
    QElapsedTimer timer;
    timer.start();
    
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "FAILED to open bin file:" << filePath;
        displayBlackScreen();
        return;
    }
    
    QByteArray imageData = file.readAll();
    file.close();
    
    qint64 fileReadTime = timer.elapsed();
    
    // 检查图像是否有变化，无变化则不更新显示
    if (!hasImageChanged(imageData)) {
        return;
    }
    
    // 1080p60_8bit.bin是1920x1080的RGB格式
    const int width = 1920;
    const int height = 1080;
    const int bytesPerPixel = 3; // RGB 8bit
    const int expectedSize = width * height * bytesPerPixel;
    
    if (imageData.size() < expectedSize) {
        qDebug() << "WARNING: Bin file size too small:" << imageData.size() << "expected:" << expectedSize;
        displayBlackScreen();
        return;
    }
    
    // 复用预分配的QImage对象，避免重复创建
    if (m_reusableImage.width() != width || m_reusableImage.height() != height) {
        m_reusableImage = QImage(width, height, QImage::Format_RGB888);
    }
    
    // 高效的内存复制
    memcpy(m_reusableImage.bits(), imageData.constData(), expectedSize);
    
    qint64 imageProcessTime = timer.elapsed() - fileReadTime;
    
    // 直接更新frameUrl，不调用updateFrame（避免文件保存）
    m_frameCounter++;
    
    // 使用交替的两个缓存文件来减少闪烁，每次都更新以显示实时图像
    static QString cachedImagePath1 = "/tmp/pcie_cached_1.bmp";
    static QString cachedImagePath2 = "/tmp/pcie_cached_2.bmp";
    
    // 交替使用两个文件
    QString currentCachePath = (m_frameCounter % 2 == 0) ? cachedImagePath1 : cachedImagePath2;
    
    // 每次都保存当前实时图像（这是必须的，否则看不到滚动效果）
    QElapsedTimer saveTimer;
    saveTimer.start();
    m_reusableImage.save(currentCachePath, "BMP");
    qint64 saveTime = saveTimer.elapsed();
    
    QString url = QString("file://%1?v=%2").arg(currentCachePath).arg(m_frameCounter);
    
    if (url != m_frameUrl) {
        m_frameUrl = url;
        emit frameUrlChanged();
    }
    
    // 批量更新信号状态，减少信号发射次数
    bool statusChanged = false;
    
    if (m_signalStatus != "PCIe Monitor Display") {
        m_signalStatus = "PCIe Monitor Display";
        statusChanged = true;
    }
    
    if (m_resolution != "1920x1080@60Hz") {
        m_resolution = "1920x1080@60Hz";
        statusChanged = true;
    }
    
    if (m_colorSpace != "RGB") {
        m_colorSpace = "RGB";
        statusChanged = true;
    }
    
    if (m_colorDepth != "8bit") {
        m_colorDepth = "8bit";
        statusChanged = true;
    }
    
    if (m_videoSignalInfo != "A<MODE:TMDS  DSC OFF  RES:1920*1080@60Hz TYPE:HDMI HDCP:V2.3 CS:RGB(0~255) CD:8Bit BT2020:Disable>") {
        m_videoSignalInfo = "A<MODE:TMDS  DSC OFF  RES:1920*1080@60Hz TYPE:HDMI HDCP:V2.3 CS:RGB(0~255) CD:8Bit BT2020:Disable>";
        statusChanged = true;
    }
    
    // 一次性发射所有变化的信号
    if (statusChanged) {
        emit signalStatusChanged();
        emit resolutionChanged();
        emit colorSpaceChanged();
        emit colorDepthChanged();
        emit videoSignalInfoChanged();
    }
    
    qint64 totalTime = timer.elapsed();
    
    // 每50帧输出一次详细的性能分析
    if (m_frameCounter % 50 == 0) {
        qDebug() << QString("Frame %1 - Total: %2ms, FileRead: %3ms, ImageProcess: %4ms, SaveTime: %5ms (Real-time cache)")
                    .arg(m_frameCounter)
                    .arg(totalTime)
                    .arg(fileReadTime)
                    .arg(imageProcessTime)
                    .arg(saveTime);
    }
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
    
    // 动态调整定时器间隔：
    // 100ms = 10FPS, 66.67ms = 15FPS, 50ms = 20FPS, 33.33ms = 30FPS, 16.67ms = 60FPS
    // PCIe命令冲突，增加间隔避免"Previous PCIe command still running"
    int refreshInterval = 100;  // 回到10FPS，确保PCIe命令有足够时间完成
    
    m_pcieRefreshTimer->start(refreshInterval);
    
    qDebug() << QString("PCIe image capture started with %1ms interval (%2 FPS)")
                .arg(refreshInterval)
                .arg(1000.0/refreshInterval, 0, 'f', 1);
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
        //qDebug() << "Previous PCIe command still running, skipping";
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
        //qDebug() << "Image data changed, size:" << newImageData.size();
    }
    
    return hasChanged;
}

// 性能优化相关方法实现
void SignalAnalyzerManager::setRefreshRate(int fps)
{
    if (fps < 1) fps = 1;
    if (fps > 60) fps = 60;
    
    int intervalMs = 1000 / fps;
    
    if (m_pcieRefreshTimer->isActive()) {
        m_pcieRefreshTimer->stop();
        m_pcieRefreshTimer->start(intervalMs);
    }
    
    qDebug() << QString("Refresh rate set to %1 FPS (%2ms interval)").arg(fps).arg(intervalMs);
}

int SignalAnalyzerManager::getCurrentFps()
{
    if (!m_pcieRefreshTimer->isActive()) {
        return 0;
    }
    
    int interval = m_pcieRefreshTimer->interval();
    return (interval > 0) ? (1000 / interval) : 0;
}

void SignalAnalyzerManager::enablePerformanceMode(bool enable)
{
    if (enable) {
        // 性能模式：使用更激进的设置
        qDebug() << "Enabling performance mode";
        setRefreshRate(30);  // 尝试30FPS
    } else {
        // 普通模式：使用保守的设置
        qDebug() << "Disabling performance mode";
        setRefreshRate(15);  // 回到15FPS
    }
}