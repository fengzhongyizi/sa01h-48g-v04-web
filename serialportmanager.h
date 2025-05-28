// 防止头文件重复包含的宏定义保护
#ifndef SERIALPORTMANAGER_H
#define SERIALPORTMANAGER_H

// 引入必要的Qt头文件
#include <QObject>                      // 提供Qt对象系统基础类
#include <QtSerialPort/QSerialPort>     // 提供串口通信功能
#include <QtSerialPort/QSerialPortInfo> // 提供串口信息查询功能
#include <QImage>                       // 提供图像处理功能
#include <QVariantMap>                  // 提供QVariantMap类型支持

// 前向声明PCIe视频接收器
class PCIeVideoReceiver;

// 串口管理器类定义
// 负责管理与硬件设备的串口通信，支持三个独立的串口：
// - UART3 (serialPort): 连接FPGA
// - UART5 (serialPortUart5): 连接MCU
// - UART6 (serialPortUart6): 连接51单片机
// 同时集成PCIe视频接收功能
class SerialPortManager : public QObject
{
    Q_OBJECT    // Qt元对象宏，提供信号槽机制和其它Qt对象系统功能

    // 属性声明，使availablePorts可以在QML中访问
    // READ指定读取方法，NOTIFY指定当值变化时发出的信号
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY availablePortsChanged)
    
    // PCIe视频相关属性
    Q_PROPERTY(bool pcieVideoEnabled READ pcieVideoEnabled NOTIFY pcieVideoEnabledChanged)
    Q_PROPERTY(bool pcieVideoConnected READ pcieVideoConnected NOTIFY pcieVideoStatusChanged)
    Q_PROPERTY(bool pcieVideoStreaming READ pcieVideoStreaming NOTIFY pcieVideoStatusChanged)
    Q_PROPERTY(QString pcieVideoStatus READ pcieVideoStatus NOTIFY pcieVideoStatusChanged)
    
public:
    // 构造函数
    // parent: 父对象指针，用于Qt对象树管理
    explicit SerialPortManager(QObject *parent = nullptr);
    
    // 析构函数
    // 确保对象销毁时关闭所有串口连接
    ~SerialPortManager();

    // 获取当前系统可用的串口列表
    // 返回值: 包含所有可用串口名称的字符串列表
    QStringList availablePorts() const;
    
    // 打开UART3串口(FPGA通信)
    // Q_INVOKABLE使此方法可从QML直接调用
    Q_INVOKABLE void openPort();
    
    // 关闭UART3串口
    Q_INVOKABLE void closePort();
    
    // 向UART3发送数据
    // data: 要发送的数据字符串
    // typedata: 数据类型标志(0=需计算校验和的十六进制, 1=ASCII文本)
    Q_INVOKABLE void writeData(const QString &data, int typedata);
    
    // 读取UART3接收到的数据
    // 返回值: 包含接收数据的字节数组
    Q_INVOKABLE QByteArray readData();

    // 打开UART5串口(MCU通信)
    Q_INVOKABLE void openPortUart5();
    
    // 关闭UART5串口
    Q_INVOKABLE void closePortUart5();
    
    // 向UART5发送数据
    // data: 要发送的数据字符串
    // typedata: 数据类型标志(0=需计算校验和的十六进制, 1=ASCII文本)
    Q_INVOKABLE void writeDataUart5(const QString &data, int typedata);
    
    // 读取UART5接收到的数据
    // 返回值: 包含接收数据的字节数组
    Q_INVOKABLE QByteArray readDataUart5();

    // 打开UART6串口(51单片机通信)
    Q_INVOKABLE void openPortUart6();
    
    // 关闭UART6串口
    Q_INVOKABLE void closePortUart6();
    
    // 向UART6发送数据
    // data: 要发送的数据字符串
    // typedata: 数据类型标志(0=需计算校验和的十六进制, 1=ASCII文本)
    Q_INVOKABLE void writeDataUart6(const QString &data, int typedata);
    
    // 读取UART6接收到的数据
    // 返回值: 包含接收数据的字节数组
    Q_INVOKABLE QByteArray readDataUart6();

    // 串口可用性检查方法
    // 检查UART3是否已打开且可用
    // 返回值: 如果串口对象存在且已打开，返回true
    bool isUart3Available() const { return serialPort && serialPort->isOpen(); }
    
    // 检查UART5是否已打开且可用
    // 返回值: 如果串口对象存在且已打开，返回true
    bool isUart5Available() const { return serialPortUart5 && serialPortUart5->isOpen(); }
    
    // 检查UART6是否已打开且可用
    // 返回值: 如果串口对象存在且已打开，返回true
    bool isUart6Available() const { return serialPortUart6 && serialPortUart6->isOpen(); }

    // PCIe视频接收相关方法
    // 启用/禁用PCIe视频接收功能
    Q_INVOKABLE void enablePcieVideo(bool enable = true);
    
    // 连接PCIe视频设备
    Q_INVOKABLE bool connectPcieVideoDevice(const QString &devicePath = "");
    
    // 断开PCIe视频设备
    Q_INVOKABLE void disconnectPcieVideoDevice();
    
    // 设置PCIe视频格式
    Q_INVOKABLE bool setPcieVideoFormat(int width, int height, int fps, const QString &colorFormat = "RGB24");
    
    // 开始PCIe视频流
    Q_INVOKABLE void startPcieVideoStream();
    
    // 停止PCIe视频流
    Q_INVOKABLE void stopPcieVideoStream();
    
    // 捕获单帧
    Q_INVOKABLE void capturePcieFrame();
    
    // 获取PCIe设备信息
    Q_INVOKABLE QVariantMap getPcieDeviceInfo();
    
    // 获取可用PCIe设备列表
    Q_INVOKABLE QStringList getAvailablePcieDevices();

    // PCIe视频属性访问器
    bool pcieVideoEnabled() const;
    bool pcieVideoConnected() const;
    bool pcieVideoStreaming() const;
    QString pcieVideoStatus() const;
       
signals:
    // 当接收到二进制数据时发出的信号
    // data: 接收到的二进制数据(已转换为十六进制字符串)
    void dataReceived(const QByteArray &data);
    
    // 当接收到ASCII文本数据时发出的信号
    // data: 接收到的文本数据
    void dataReceivedASCALL(const QString &data);
    
    // 当操作过程中发生错误时发出的信号
    // error: 错误信息字符串
    void errorOccurred(const QString &error);
    
    // 当可用串口列表变化时发出的信号
    void availablePortsChanged();
    
    // 信号监控专用信号
    // 当接收到特定格式的信号监控数据时发出
    // data: 原始监控数据
    void signalMonitorDataReceived(const QByteArray &data);
    
    // FPGA图像数据接收信号
    // 当接收到FPGA发送的图像数据时发出
    // data: 原始图像数据
    void imageDataReceived(const QByteArray &data);
    
    // PCIe视频相关信号
    // 当PCIe视频功能启用状态变化时发出
    void pcieVideoEnabledChanged();
    
    // 当PCIe视频状态变化时发出（连接、流传输等）
    void pcieVideoStatusChanged();
    
    // 当接收到PCIe视频帧时发出
    // frame: 接收到的视频帧图像
    void pcieFrameReceived(const QImage &frame);
    
    // 当PCIe视频出现错误时发出
    // error: 错误信息
    void pcieVideoError(const QString &error);

private slots:
    // UART3数据就绪时的处理槽函数
    // 当串口接收到数据时自动调用此函数处理
    void onReadyRead();
    
    // UART5数据就绪时的处理槽函数
    void onReadyReadUart5();
    
    // UART6数据就绪时的处理槽函数
    void onReadyReadUart6();
    
    // PCIe视频帧接收处理槽函数
    void onPcieFrameReceived(const QImage &frame);
    
    // PCIe视频错误处理槽函数
    void onPcieVideoError(const QString &error);
    
    // PCIe视频状态变化处理槽函数
    void onPcieVideoStatusChanged();
    
private:
    // 串口对象指针
    QSerialPort *serialPort;      // UART3，连接FPGA
    QSerialPort *serialPortUart5; // UART5，连接MCU
    QSerialPort *serialPortUart6; // UART6，连接51单片机

    // PCIe视频接收器
    PCIeVideoReceiver *m_pcieVideoReceiver;
    bool m_pcieVideoEnabled;

    // 重新打开UART5的辅助方法
    // 当通信出错或连接断开时用于恢复通信
    void reopenPortUart5();
    
    // 初始化PCIe视频接收器
    void initializePcieVideo();
    
    // 清理PCIe视频接收器
    void cleanupPcieVideo();
};
#endif // SERIALPORTMANAGER_H