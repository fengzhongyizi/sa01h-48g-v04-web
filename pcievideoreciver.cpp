#include "pcievideoreciver.h"
#include <QDebug>
#include <QDateTime>
#include <QDir>
#include <QFileInfo>
#include <QElapsedTimer>
#include <QApplication>
#include <QVariantMap>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <errno.h>
#include <cstring>
#include <functional>

// PCIe视频接收工作线程类定义（不使用Q_OBJECT）
class PCIeVideoWorker
{
public:
    // 回调函数类型定义
    using FrameReadyCallback = std::function<void(const QImage&)>;
    using StatusChangedCallback = std::function<void(PCIeDeviceStatus)>;
    using ErrorCallback = std::function<void(const QString&)>;
    using StatisticsCallback = std::function<void(quint64, double, qint64)>;

    explicit PCIeVideoWorker();
    ~PCIeVideoWorker();

    void setVideoFormat(const VideoFormat &format);
    bool openDevice(const QString &devicePath);
    void closeDevice();
    bool isDeviceOpen() const;

    // 设置回调函数
    void setFrameReadyCallback(const FrameReadyCallback &callback) { m_frameReadyCallback = callback; }
    void setStatusChangedCallback(const StatusChangedCallback &callback) { m_statusChangedCallback = callback; }
    void setErrorCallback(const ErrorCallback &callback) { m_errorCallback = callback; }
    void setStatisticsCallback(const StatisticsCallback &callback) { m_statisticsCallback = callback; }

    void startCapture();
    void stopCapture();
    void processFrameCapture();

private:
    bool initializePCIeDevice();
    bool readFrameFromDevice(QByteArray &frameData);
    QImage convertToQImage(const QByteArray &rawData);
    void updateStatistics();

    // 回调函数
    FrameReadyCallback m_frameReadyCallback;
    StatusChangedCallback m_statusChangedCallback;
    ErrorCallback m_errorCallback;
    StatisticsCallback m_statisticsCallback;

    // PCIe设备相关
    int m_deviceHandle;
    QString m_devicePath;
    VideoFormat m_videoFormat;
    PCIeDeviceStatus m_deviceStatus;
    
    // 线程控制
    QMutex m_deviceMutex;
    bool m_isCapturing;
    bool m_deviceOpen;
    
    // 统计信息
    quint64 m_frameCount;
    qint64 m_lastFrameTime;
    qint64 m_totalDataReceived;
    double m_currentFps;
    
    // 缓冲区
    QByteArray m_frameBuffer;
    static const int MAX_FRAME_SIZE = 1920 * 1080 * 4; // 最大帧大小
};

// PCIe设备IO控制命令定义
#define PCIE_VIDEO_IOC_MAGIC 'V'
#define PCIE_VIDEO_START_STREAM    _IO(PCIE_VIDEO_IOC_MAGIC, 1)
#define PCIE_VIDEO_STOP_STREAM     _IO(PCIE_VIDEO_IOC_MAGIC, 2)
#define PCIE_VIDEO_SET_FORMAT      _IOW(PCIE_VIDEO_IOC_MAGIC, 3, VideoFormat)
#define PCIE_VIDEO_GET_STATUS      _IOR(PCIE_VIDEO_IOC_MAGIC, 4, int)
#define PCIE_VIDEO_GET_FRAME       _IOR(PCIE_VIDEO_IOC_MAGIC, 5, void*)

// ==================== PCIeVideoWorker Implementation ====================

PCIeVideoWorker::PCIeVideoWorker()
    : m_deviceHandle(-1)
    , m_deviceStatus(PCIeDeviceStatus::Disconnected)
    , m_isCapturing(false)
    , m_deviceOpen(false)
    , m_frameCount(0)
    , m_lastFrameTime(0)
    , m_totalDataReceived(0)
    , m_currentFps(0.0)
{
    // 初始化默认视频格式
    m_videoFormat.width = 1920;
    m_videoFormat.height = 1080;
    m_videoFormat.fps = 60;
    m_videoFormat.colorFormat = "RGB24";
    m_videoFormat.bitDepth = 8;
    
    // 预分配帧缓冲区
    m_frameBuffer.reserve(MAX_FRAME_SIZE);
    
    qDebug() << "PCIeVideoWorker initialized";
}

PCIeVideoWorker::~PCIeVideoWorker()
{
    stopCapture();
    closeDevice();
}

void PCIeVideoWorker::setVideoFormat(const VideoFormat &format)
{
    QMutexLocker locker(&m_deviceMutex);
    m_videoFormat = format;
    
    if (m_deviceOpen) {
        if (ioctl(m_deviceHandle, PCIE_VIDEO_SET_FORMAT, &m_videoFormat) < 0) {
            if (m_errorCallback) m_errorCallback(QString("Failed to set video format: %1").arg(strerror(errno)));
        } else {
            qDebug() << "Video format updated:" << format.width << "x" << format.height 
                     << "@" << format.fps << "fps";
        }
    }
}

bool PCIeVideoWorker::openDevice(const QString &devicePath)
{
    QMutexLocker locker(&m_deviceMutex);
    
    if (m_deviceOpen) {
        qWarning() << "Device already open";
        return true;
    }
    
    m_devicePath = devicePath;
    
    // 检查设备文件是否存在
    if (!QFileInfo::exists(devicePath)) {
        if (m_errorCallback) m_errorCallback(QString("PCIe device not found: %1").arg(devicePath));
        return false;
    }
    
    // 打开PCIe设备
    m_deviceHandle = open(devicePath.toLocal8Bit().constData(), O_RDWR | O_NONBLOCK);
    if (m_deviceHandle < 0) {
        if (m_errorCallback) m_errorCallback(QString("Failed to open PCIe device: %1").arg(strerror(errno)));
        return false;
    }
    
    // 初始化PCIe设备
    if (!initializePCIeDevice()) {
        close(m_deviceHandle);
        m_deviceHandle = -1;
        return false;
    }
    
    m_deviceOpen = true;
    m_deviceStatus = PCIeDeviceStatus::Connected;
    if (m_statusChangedCallback) m_statusChangedCallback(m_deviceStatus);
    
    qDebug() << "PCIe device opened successfully:" << devicePath;
    return true;
}

void PCIeVideoWorker::closeDevice()
{
    QMutexLocker locker(&m_deviceMutex);
    
    if (!m_deviceOpen) return;
    
    stopCapture();
    
    if (m_deviceHandle >= 0) {
        close(m_deviceHandle);
        m_deviceHandle = -1;
    }
    
    m_deviceOpen = false;
    m_deviceStatus = PCIeDeviceStatus::Disconnected;
    if (m_statusChangedCallback) m_statusChangedCallback(m_deviceStatus);
    
    qDebug() << "PCIe device closed";
}

bool PCIeVideoWorker::isDeviceOpen() const
{
    return m_deviceOpen;
}

void PCIeVideoWorker::startCapture()
{
    if (!m_deviceOpen) {
        if (m_errorCallback) m_errorCallback("Device not open");
        return;
    }
    
    if (m_isCapturing) {
        qDebug() << "Already capturing";
        return;
    }
    
    // 启动硬件流
    if (ioctl(m_deviceHandle, PCIE_VIDEO_START_STREAM) < 0) {
        if (m_errorCallback) m_errorCallback(QString("Failed to start stream: %1").arg(strerror(errno)));
        return;
    }
    
    m_isCapturing = true;
    m_frameCount = 0;
    m_lastFrameTime = QDateTime::currentMSecsSinceEpoch();
    m_deviceStatus = PCIeDeviceStatus::Streaming;
    if (m_statusChangedCallback) m_statusChangedCallback(m_deviceStatus);
    
    qDebug() << "Video capture started";
}

void PCIeVideoWorker::stopCapture()
{
    if (!m_isCapturing) return;
    
    if (m_deviceOpen && m_deviceHandle >= 0) {
        if (ioctl(m_deviceHandle, PCIE_VIDEO_STOP_STREAM) < 0) {
            qWarning() << "Failed to stop stream:" << strerror(errno);
        }
    }
    
    m_deviceStatus = m_deviceOpen ? PCIeDeviceStatus::Connected : PCIeDeviceStatus::Disconnected;
    if (m_statusChangedCallback) m_statusChangedCallback(m_deviceStatus);
    
    m_isCapturing = false;
    
    qDebug() << "Video capture stopped";
}

void PCIeVideoWorker::processFrameCapture()
{
    if (!m_isCapturing || !m_deviceOpen) return;
    
    QByteArray frameData;
    if (readFrameFromDevice(frameData)) {
        if (!frameData.isEmpty()) {
            QImage frame = convertToQImage(frameData);
            if (!frame.isNull()) {
                if (m_frameReadyCallback) m_frameReadyCallback(frame);
                m_frameCount++;
                m_totalDataReceived += frameData.size();
                updateStatistics();
            }
        }
    }
}

bool PCIeVideoWorker::initializePCIeDevice()
{
    // 设置初始视频格式
    if (ioctl(m_deviceHandle, PCIE_VIDEO_SET_FORMAT, &m_videoFormat) < 0) {
        if (m_errorCallback) m_errorCallback(QString("Failed to initialize device format: %1").arg(strerror(errno)));
        return false;
    }
    
    // 验证设备状态
    int status;
    if (ioctl(m_deviceHandle, PCIE_VIDEO_GET_STATUS, &status) < 0) {
        if (m_errorCallback) m_errorCallback(QString("Failed to get device status: %1").arg(strerror(errno)));
        return false;
    }
    
    qDebug() << "PCIe device initialized, status:" << status;
    return true;
}

bool PCIeVideoWorker::readFrameFromDevice(QByteArray &frameData)
{
    QMutexLocker locker(&m_deviceMutex);
    
    if (!m_deviceOpen || m_deviceHandle < 0) return false;
    
    // 计算预期帧大小
    int bytesPerPixel = (m_videoFormat.colorFormat == "RGB24") ? 3 : 4;
    int expectedFrameSize = m_videoFormat.width * m_videoFormat.height * bytesPerPixel;
    
    // 确保缓冲区足够大
    if (m_frameBuffer.size() < expectedFrameSize) {
        m_frameBuffer.resize(expectedFrameSize);
    }
    
    // 从PCIe设备读取帧数据
    ssize_t bytesRead = read(m_deviceHandle, m_frameBuffer.data(), expectedFrameSize);
    
    if (bytesRead < 0) {
        if (errno != EAGAIN && errno != EWOULDBLOCK) {
            if (m_errorCallback) m_errorCallback(QString("Frame read error: %1").arg(strerror(errno)));
        }
        return false;
    }
    
    if (bytesRead == 0) {
        // 没有数据可读
        return false;
    }
    
    // 检查是否读取了完整帧
    if (bytesRead != expectedFrameSize) {
        qWarning() << "Incomplete frame read:" << bytesRead << "expected:" << expectedFrameSize;
        return false;
    }
    
    frameData = m_frameBuffer.left(bytesRead);
    return true;
}

QImage PCIeVideoWorker::convertToQImage(const QByteArray &rawData)
{
    if (rawData.isEmpty()) return QImage();
    
    QImage::Format imageFormat;
    int bytesPerLine;
    
    if (m_videoFormat.colorFormat == "RGB24") {
        imageFormat = QImage::Format_RGB888;
        bytesPerLine = m_videoFormat.width * 3;
    } else if (m_videoFormat.colorFormat == "ARGB32") {
        imageFormat = QImage::Format_ARGB32;
        bytesPerLine = m_videoFormat.width * 4;
    } else {
        qWarning() << "Unsupported color format:" << m_videoFormat.colorFormat;
        return QImage();
    }
    
    // 验证数据大小
    int expectedSize = bytesPerLine * m_videoFormat.height;
    if (rawData.size() < expectedSize) {
        qWarning() << "Insufficient data for image conversion:" << rawData.size() << "expected:" << expectedSize;
        return QImage();
    }
    
    // 创建QImage
    QImage image(reinterpret_cast<const uchar*>(rawData.constData()),
                 m_videoFormat.width, m_videoFormat.height,
                 bytesPerLine, imageFormat);
    
    // 复制图像数据以确保数据有效性
    return image.copy();
}

void PCIeVideoWorker::updateStatistics()
{
    qint64 currentTime = QDateTime::currentMSecsSinceEpoch();
    
    // 每秒更新一次统计信息
    if (currentTime - m_lastFrameTime >= 1000) {
        m_currentFps = m_frameCount * 1000.0 / (currentTime - m_lastFrameTime);
        qint64 dataRate = m_totalDataReceived; // bytes per interval
        
        if (m_statisticsCallback) m_statisticsCallback(m_frameCount, m_currentFps, dataRate);
        
        // 重置统计计数器
        m_frameCount = 0;
        m_totalDataReceived = 0;
        m_lastFrameTime = currentTime;
    }
}

// ==================== PCIeVideoReceiver Implementation ====================

PCIeVideoReceiver::PCIeVideoReceiver(QObject *parent)
    : QObject(parent)
    , m_workerThread(nullptr)
    , m_worker(nullptr)
    , m_currentStatus(PCIeDeviceStatus::Disconnected)
    , m_currentFps(0.0)
    , m_totalFrames(0)
    , m_totalDataRate(0)
{
    // 初始化默认格式
    m_currentFormat.width = 1920;
    m_currentFormat.height = 1080;
    m_currentFormat.fps = 60;
    m_currentFormat.colorFormat = "RGB24";
    m_currentFormat.bitDepth = 8;
    
    // 扫描可用设备
    getAvailableDevices();
    
    qDebug() << "PCIeVideoReceiver initialized";
}

PCIeVideoReceiver::~PCIeVideoReceiver()
{
    disconnectDevice();
}

bool PCIeVideoReceiver::isConnected() const
{
    return m_currentStatus != PCIeDeviceStatus::Disconnected;
}

bool PCIeVideoReceiver::isStreaming() const
{
    return m_currentStatus == PCIeDeviceStatus::Streaming;
}

QString PCIeVideoReceiver::deviceStatus() const
{
    return statusToString(m_currentStatus);
}

int PCIeVideoReceiver::frameWidth() const
{
    return m_currentFormat.width;
}

int PCIeVideoReceiver::frameHeight() const
{
    return m_currentFormat.height;
}

double PCIeVideoReceiver::currentFps() const
{
    return m_currentFps;
}

QString PCIeVideoReceiver::lastError() const
{
    return m_lastError;
}

bool PCIeVideoReceiver::connectDevice(const QString &devicePath)
{
    if (isConnected()) {
        qDebug() << "Device already connected";
        return true;
    }
    
    m_devicePath = devicePath;
    initializeWorkerThread();
    
    // 在工作线程中打开设备
    if (m_worker) {
        return m_worker->openDevice(devicePath);
    }
    
    m_lastError = "Failed to initialize worker thread";
    emit errorChanged();
    return false;
}

void PCIeVideoReceiver::disconnectDevice()
{
    if (m_worker) {
        m_worker->closeDevice();
    }
    
    cleanupWorkerThread();
    
    m_currentStatus = PCIeDeviceStatus::Disconnected;
    emit connectionStatusChanged();
    emit deviceStatusChanged();
}

bool PCIeVideoReceiver::setVideoFormat(int width, int height, int fps, const QString &colorFormat)
{
    VideoFormat newFormat;
    newFormat.width = width;
    newFormat.height = height;
    newFormat.fps = fps;
    newFormat.colorFormat = colorFormat;
    newFormat.bitDepth = 8;
    
    m_currentFormat = newFormat;
    
    if (m_worker) {
        m_worker->setVideoFormat(newFormat);
    }
    
    emit videoFormatChanged();
    qDebug() << "Video format set to:" << width << "x" << height << "@" << fps << "fps," << colorFormat;
    return true;
}

void PCIeVideoReceiver::startVideoStream()
{
    if (!isConnected()) {
        m_lastError = "Device not connected";
        emit errorChanged();
        return;
    }
    
    if (m_worker) {
        m_worker->startCapture();
    }
}

void PCIeVideoReceiver::stopVideoStream()
{
    if (m_worker) {
        m_worker->stopCapture();
    }
}

void PCIeVideoReceiver::captureFrame()
{
    if (m_worker && isConnected()) {
        m_worker->processFrameCapture();
    }
}

QStringList PCIeVideoReceiver::getAvailableDevices()
{
    m_availableDevices.clear();
    
    QStringList candidates = {
        "/dev/pcie_video0",
        "/dev/pcie_video1", 
        "/dev/video_capture0",
        "/dev/video_capture1",
        "/dev/fpga_video0",
        "/dev/fpga_video1"
    };
    
    for (const QString &path : candidates) {
        if (QFileInfo::exists(path)) {
            m_availableDevices.append(path);
        }
    }
    
    qDebug() << "Available PCIe devices:" << m_availableDevices;
    emit deviceListChanged();
    return m_availableDevices;
}

QVariantMap PCIeVideoReceiver::getDeviceInfo()
{
    QVariantMap info;
    info["devicePath"] = m_devicePath;
    info["status"] = deviceStatus();
    info["width"] = m_currentFormat.width;
    info["height"] = m_currentFormat.height;
    info["fps"] = m_currentFormat.fps;
    info["colorFormat"] = m_currentFormat.colorFormat;
    info["connected"] = isConnected();
    info["streaming"] = isStreaming();
    return info;
}

QVariantMap PCIeVideoReceiver::getCurrentStatistics()
{
    QVariantMap stats;
    stats["currentFps"] = m_currentFps;
    stats["totalFrames"] = static_cast<qulonglong>(m_totalFrames);
    stats["dataRate"] = static_cast<qulonglong>(m_totalDataRate);
    stats["isStreaming"] = isStreaming();
    return stats;
}

void PCIeVideoReceiver::onFrameReady(const QImage &frame)
{
    m_totalFrames++;
    emit frameReceived(frame);
}

void PCIeVideoReceiver::onDeviceStatusChanged(PCIeDeviceStatus status)
{
    m_currentStatus = status;
    emit connectionStatusChanged();
    emit streamingStatusChanged();
    emit deviceStatusChanged();
}

void PCIeVideoReceiver::onWorkerError(const QString &error)
{
    m_lastError = error;
    emit errorChanged();
    qWarning() << "PCIe Worker Error:" << error;
}

void PCIeVideoReceiver::onStatisticsUpdated(quint64 frameCount, double fps, qint64 dataRate)
{
    Q_UNUSED(frameCount)  // 暂时不使用frameCount参数
    Q_UNUSED(dataRate)    // 暂时不使用dataRate参数
    
    m_currentFps = fps;
    emit statisticsChanged();
}

void PCIeVideoReceiver::initializeWorkerThread()
{
    if (m_worker) return;
    
    // 简化初始化，不使用独立线程
    m_worker = new PCIeVideoWorker();
    
    // 设置回调函数
    m_worker->setFrameReadyCallback([this](const QImage &frame) {
        onFrameReady(frame);
    });
    m_worker->setStatusChangedCallback([this](PCIeDeviceStatus status) {
        onDeviceStatusChanged(status);
    });
    m_worker->setErrorCallback([this](const QString &error) {
        onWorkerError(error);
    });
    m_worker->setStatisticsCallback([this](quint64 frameCount, double fps, qint64 dataRate) {
        onStatisticsUpdated(frameCount, fps, dataRate);
    });
    
    qDebug() << "PCIe video worker initialized";
}

void PCIeVideoReceiver::cleanupWorkerThread()
{
    if (m_worker) {
        delete m_worker;
        m_worker = nullptr;
    }
    
    qDebug() << "PCIe video worker cleaned up";
}

QString PCIeVideoReceiver::statusToString(PCIeDeviceStatus status) const
{
    switch (status) {
        case PCIeDeviceStatus::Disconnected: return "Disconnected";
        case PCIeDeviceStatus::Connected: return "Connected";
        case PCIeDeviceStatus::Streaming: return "Streaming";
        case PCIeDeviceStatus::Error: return "Error";
        default: return "Unknown";
    }
} 
