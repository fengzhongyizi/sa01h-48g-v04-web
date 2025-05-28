// 防止头文件重复包含的宏定义保护
#ifndef SERIALPORTMANAGER_H
#define SERIALPORTMANAGER_H

// 引入必要的Qt头文件
#include <QObject>                      // 提供Qt对象系统基础类
#include <QtSerialPort/QSerialPort>     // 提供串口通信功能
#include <QtSerialPort/QSerialPortInfo> // 提供串口信息查询功能

// 串口管理器类定义
// 负责管理与硬件设备的串口通信，支持三个独立的串口：
// - UART3 (serialPort): 连接FPGA
// - UART5 (serialPortUart5): 连接MCU
// - UART6 (serialPortUart6): 连接51单片机
class SerialPortManager : public QObject
{
    Q_OBJECT    // Qt元对象宏，提供信号槽机制和其它Qt对象系统功能

    // 属性声明，使availablePorts可以在QML中访问
    // READ指定读取方法，NOTIFY指定当值变化时发出的信号
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY availablePortsChanged)
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

private slots:
    // UART3数据就绪时的处理槽函数
    // 当串口接收到数据时自动调用此函数处理
    void onReadyRead();
    
    // UART5数据就绪时的处理槽函数
    void onReadyReadUart5();
    
    // UART6数据就绪时的处理槽函数
    void onReadyReadUart6();
    
private:
    // 串口对象指针
    QSerialPort *serialPort;      // UART3，连接FPGA
    QSerialPort *serialPortUart5; // UART5，连接MCU
    QSerialPort *serialPortUart6; // UART6，连接51单片机

    // 重新打开UART5的辅助方法
    // 当通信出错或连接断开时用于恢复通信
    void reopenPortUart5();  
};
#endif // SERIALPORTMANAGER_H