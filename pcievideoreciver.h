#ifndef PCIEVIDEORECIVER_H
#define PCIEVIDEORECIVER_H

#include <QObject>
#include <QThread>
#include <QMutex>
#include <QTimer>
#include <QImage>
#include <QByteArray>
#include <QStringList>
#include <QVariantMap>

// PCIe设备状态枚举
enum class PCIeDeviceStatus {
    Disconnected = 0,
    Connected = 1,
    Streaming = 2,
    Error = 3
};

// 视频格式结构体
struct VideoFormat {
    int width;
    int height;
    int fps;
    QString colorFormat;  // RGB24, YUV420, etc.
    int bitDepth;
};

// 前向声明PCIe视频接收工作线程
class PCIeVideoWorker;

// PCIe视频接收管理器
class PCIeVideoReceiver : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionStatusChanged)
    Q_PROPERTY(bool isStreaming READ isStreaming NOTIFY streamingStatusChanged)
    Q_PROPERTY(QString deviceStatus READ deviceStatus NOTIFY deviceStatusChanged)
    Q_PROPERTY(int frameWidth READ frameWidth NOTIFY videoFormatChanged)
    Q_PROPERTY(int frameHeight READ frameHeight NOTIFY videoFormatChanged)
    Q_PROPERTY(double currentFps READ currentFps NOTIFY statisticsChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY errorChanged)

public:
    explicit PCIeVideoReceiver(QObject *parent = nullptr);
    ~PCIeVideoReceiver();

    // 属性访问器
    bool isConnected() const;
    bool isStreaming() const;
    QString deviceStatus() const;
    int frameWidth() const;
    int frameHeight() const;
    double currentFps() const;
    QString lastError() const;

    // 设备管理
    Q_INVOKABLE bool connectDevice(const QString &devicePath = "/dev/pcie_video0");
    Q_INVOKABLE void disconnectDevice();
    Q_INVOKABLE bool setVideoFormat(int width, int height, int fps, const QString &colorFormat = "RGB24");
    
    // 视频流控制
    Q_INVOKABLE void startVideoStream();
    Q_INVOKABLE void stopVideoStream();
    Q_INVOKABLE void captureFrame();
    
    // 获取设备信息
    Q_INVOKABLE QStringList getAvailableDevices();
    Q_INVOKABLE QVariantMap getDeviceInfo();
    Q_INVOKABLE QVariantMap getCurrentStatistics();

signals:
    void frameReceived(const QImage &frame);
    void connectionStatusChanged();
    void streamingStatusChanged();
    void deviceStatusChanged();
    void videoFormatChanged();
    void statisticsChanged();
    void errorChanged();
    void deviceListChanged();

private slots:
    void onFrameReady(const QImage &frame);
    void onDeviceStatusChanged(PCIeDeviceStatus status);
    void onWorkerError(const QString &error);
    void onStatisticsUpdated(quint64 frameCount, double fps, qint64 dataRate);

private:
    void initializeWorkerThread();
    void cleanupWorkerThread();
    QString statusToString(PCIeDeviceStatus status) const;

    // 工作线程
    QThread *m_workerThread;
    PCIeVideoWorker *m_worker;
    
    // 状态变量
    PCIeDeviceStatus m_currentStatus;
    VideoFormat m_currentFormat;
    QString m_lastError;
    QString m_devicePath;
    
    // 统计信息
    double m_currentFps;
    quint64 m_totalFrames;
    qint64 m_totalDataRate;
    
    // 设备列表
    QStringList m_availableDevices;
};

#endif // PCIEVIDEORECIVER_H 