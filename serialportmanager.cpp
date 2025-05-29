// 包含必要的头文件
#include "serialportmanager.h"    // 类定义头文件
#include "pcievideoreciver.h"     // PCIe视频接收器头文件
#include <QByteArray>             // 提供字节数组处理功能
#include <QDebug>                 // 提供调试输出功能
#include <QThread>                // 提供线程相关功能，用于延时等操作
#include <QBuffer>

// 构造函数：初始化串口管理器并打开串口连接
// parent: 父对象指针，用于Qt对象树管理
SerialPortManager::SerialPortManager(QObject *parent) :
    QObject(parent),
    serialPort(new QSerialPort(this)),       // 初始化uart3，连接FPGA
    serialPortUart5(new QSerialPort(this)),  // 初始化uart5，连接MCU
    serialPortUart6(new QSerialPort(this)),  // 初始化uart6，连接51单片机
    m_pcieVideoReceiver(nullptr),            // 初始化PCIe视频接收器为空
    m_pcieVideoEnabled(false)                // 默认禁用PCIe视频功能
{
    // 连接各串口的readyRead信号到相应的处理槽函数
    connect(serialPort, &QSerialPort::readyRead, this, &SerialPortManager::onReadyRead);
    connect(serialPortUart5, &QSerialPort::readyRead, this, &SerialPortManager::onReadyReadUart5);
    connect(serialPortUart6, &QSerialPort::readyRead, this, &SerialPortManager::onReadyReadUart6);
    
    emit availablePortsChanged();  // 发出可用端口变化信号
    
    // 打开所有串口
    openPort();      // 打开UART3
    openPortUart5(); // 打开UART5
    openPortUart6(); // 打开UART6
    
    // 初始化PCIe视频接收功能
    initializePcieVideo();
    
    qDebug() << "SerialPortManager initialized with PCIe video support";
}

// 析构函数：确保在对象销毁时关闭串口
SerialPortManager::~SerialPortManager()
{
    if (serialPort->isOpen()) {
        serialPort->close();  // 关闭UART3
    }
    // 注意：没有显式关闭UART5和UART6，它们将在QSerialPort对象销毁时自动关闭
    
    // 清理PCIe视频接收器
    cleanupPcieVideo();
}

// 获取系统上所有可用的串口列表
// 返回值：包含所有可用串口名称的字符串列表
QStringList SerialPortManager::availablePorts() const {
    QStringList portNames;
    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : infos) {
        portNames.append(info.portName());  // 添加每个串口的名称到列表
    }
    return portNames;
}

// ==================== PCIe视频接收功能实现 ====================

void SerialPortManager::initializePcieVideo()
{
    if (m_pcieVideoReceiver) return;  // 如果已初始化则返回
    
    m_pcieVideoReceiver = new PCIeVideoReceiver(this);
    
    // 连接PCIe视频接收器的信号
    connect(m_pcieVideoReceiver, &PCIeVideoReceiver::frameReceived,
            this, &SerialPortManager::onPcieFrameReceived);
    connect(m_pcieVideoReceiver, &PCIeVideoReceiver::errorChanged,
            this, [this]() {
                // errorChanged信号没有参数，我们需要从对象获取错误信息
                QString error = m_pcieVideoReceiver->lastError();
                onPcieVideoError(error);
            });
    connect(m_pcieVideoReceiver, &PCIeVideoReceiver::connectionStatusChanged,
            this, &SerialPortManager::onPcieVideoStatusChanged);
    connect(m_pcieVideoReceiver, &PCIeVideoReceiver::streamingStatusChanged,
            this, &SerialPortManager::onPcieVideoStatusChanged);
    
    qDebug() << "PCIe video receiver initialized";
}

void SerialPortManager::cleanupPcieVideo()
{
    if (m_pcieVideoReceiver) {
        m_pcieVideoReceiver->disconnectDevice();
        m_pcieVideoReceiver->deleteLater();
        m_pcieVideoReceiver = nullptr;
    }
    m_pcieVideoEnabled = false;
    emit pcieVideoEnabledChanged();
}

void SerialPortManager::enablePcieVideo(bool enable)
{
    if (m_pcieVideoEnabled == enable) return;
    
    m_pcieVideoEnabled = enable;
    
    if (enable) {
        if (!m_pcieVideoReceiver) {
            initializePcieVideo();
        }
        qDebug() << "PCIe video enabled";
    } else {
        if (m_pcieVideoReceiver) {
            m_pcieVideoReceiver->stopVideoStream();
            m_pcieVideoReceiver->disconnectDevice();
        }
        qDebug() << "PCIe video disabled";
    }
    
    emit pcieVideoEnabledChanged();
}

bool SerialPortManager::connectPcieVideoDevice(const QString &devicePath)
{
    if (!m_pcieVideoEnabled || !m_pcieVideoReceiver) {
        qWarning() << "PCIe video not enabled";
        return false;
    }
    
    QString actualDevicePath = devicePath;
    if (actualDevicePath.isEmpty()) {
        // 如果没有指定设备路径，尝试使用第一个可用设备
        QStringList devices = m_pcieVideoReceiver->getAvailableDevices();
        if (!devices.isEmpty()) {
            actualDevicePath = devices.first();
        } else {
            actualDevicePath = "/dev/pcie_video0";  // 默认设备
        }
    }
    
    bool success = m_pcieVideoReceiver->connectDevice(actualDevicePath);
    if (success) {
        qDebug() << "PCIe video device connected:" << actualDevicePath;
    } else {
        qWarning() << "Failed to connect PCIe video device:" << actualDevicePath;
    }
    
    return success;
}

void SerialPortManager::disconnectPcieVideoDevice()
{
    if (m_pcieVideoReceiver) {
        m_pcieVideoReceiver->disconnectDevice();
        qDebug() << "PCIe video device disconnected";
    }
}

bool SerialPortManager::setPcieVideoFormat(int width, int height, int fps, const QString &colorFormat)
{
    if (!m_pcieVideoReceiver) return false;
    
    return m_pcieVideoReceiver->setVideoFormat(width, height, fps, colorFormat);
}

void SerialPortManager::startPcieVideoStream()
{
    if (m_pcieVideoReceiver && m_pcieVideoEnabled) {
        m_pcieVideoReceiver->startVideoStream();
        qDebug() << "PCIe video stream started";
    } else {
        qWarning() << "Cannot start PCIe video stream: receiver not available or disabled";
    }
}

void SerialPortManager::stopPcieVideoStream()
{
    if (m_pcieVideoReceiver) {
        m_pcieVideoReceiver->stopVideoStream();
        qDebug() << "PCIe video stream stopped";
    }
}

void SerialPortManager::capturePcieFrame()
{
    if (m_pcieVideoReceiver && m_pcieVideoEnabled) {
        m_pcieVideoReceiver->captureFrame();
    }
}

QVariantMap SerialPortManager::getPcieDeviceInfo()
{
    if (m_pcieVideoReceiver) {
        return m_pcieVideoReceiver->getDeviceInfo();
    }
    return QVariantMap();
}

QStringList SerialPortManager::getAvailablePcieDevices()
{
    if (m_pcieVideoReceiver) {
        return m_pcieVideoReceiver->getAvailableDevices();
    }
    return QStringList();
}

// PCIe视频属性访问器
bool SerialPortManager::pcieVideoEnabled() const
{
    return m_pcieVideoEnabled;
}

bool SerialPortManager::pcieVideoConnected() const
{
    return m_pcieVideoReceiver ? m_pcieVideoReceiver->isConnected() : false;
}

bool SerialPortManager::pcieVideoStreaming() const
{
    return m_pcieVideoReceiver ? m_pcieVideoReceiver->isStreaming() : false;
}

QString SerialPortManager::pcieVideoStatus() const
{
    return m_pcieVideoReceiver ? m_pcieVideoReceiver->deviceStatus() : "Disabled";
}

// PCIe视频槽函数
void SerialPortManager::onPcieFrameReceived(const QImage &frame)
{
    // 将PCIe接收的帧转发给UI层
    emit pcieFrameReceived(frame);
    
    // 同时也通过imageDataReceived信号发送（保持兼容性）
    QByteArray frameData;
    QBuffer buffer(&frameData);
    buffer.open(QIODevice::WriteOnly);
    frame.save(&buffer, "PNG");  // 转换为PNG格式的字节数组
    emit imageDataReceived(frameData);
}

void SerialPortManager::onPcieVideoError(const QString &error)
{
    emit pcieVideoError(error);
    qWarning() << "PCIe video error:" << error;
}

void SerialPortManager::onPcieVideoStatusChanged()
{
    emit pcieVideoStatusChanged();
    qDebug() << "PCIe video status changed - Connected:" << pcieVideoConnected() 
             << "Streaming:" << pcieVideoStreaming() << "Status:" << pcieVideoStatus();
}

// ==================== 原有串口功能保持不变 ====================

// 打开并配置UART3串口(连接到FPGA)
void SerialPortManager::openPort()
{
    // 配置串口参数
    serialPort->setPortName("/dev/ttyS3");                   // 设置设备名称
    serialPort->setBaudRate(QSerialPort::Baud115200);        // 设置波特率为115200
    serialPort->setDataBits(QSerialPort::Data8);             // 设置数据位为8位
    serialPort->setParity(QSerialPort::NoParity);            // 设置无奇偶校验
    serialPort->setStopBits(QSerialPort::OneStop);           // 设置1个停止位
    serialPort->setFlowControl(QSerialPort::NoFlowControl);  // 设置无流控制

    // 尝试以读写模式打开串口
    if (!serialPort->open(QIODevice::ReadWrite)) {
        emit errorOccurred(serialPort->errorString());  // 发送错误信号
        qDebug() << "Error opening port:" << serialPort->errorString();
    } else {
        qDebug() << "open port!";
        // 以下是打开端口后可以发送的初始化命令，但目前被注释掉了
//        writeData("AA 00 00 06 00 00 00 61 80",0); //get timing
//        writeData("AA 00 00 06 00 00 00 63 80",0); //get color
//        writeData("AA 00 00 06 00 00 00 64 80",0); //get colorDepth
//        writeData("AA 00 00 06 00 00 00 65 80",0); //get hdcp
//        writeData("AA 00 00 06 00 00 00 66 80",0); //get HDMI/DVI
//        writeData("AA 00 00 06 00 00 00 67 80",0); //get pcm_sampling_rate
//        writeData("AA 00 00 06 00 00 00 68 80",0); //get pcm_bit
//        writeData("AA 00 00 06 00 00 00 6A 80",0); //get pcm_channels
//        writeData("AA 00 00 06 00 00 00 6D 80",0); //get volume
//        writeData("AA 00 00 06 00 00 00 73 80",0); //get sineware
    }
}

// 打开并配置UART5串口(连接到MCU)
void SerialPortManager::openPortUart5()
{
    // 配置串口参数
    serialPortUart5->setPortName("/dev/ttyS5");              // 设置设备名称
    serialPortUart5->setBaudRate(QSerialPort::Baud57600);    // 设置波特率为57600
    serialPortUart5->setDataBits(QSerialPort::Data8);        // 设置数据位为8位
    serialPortUart5->setParity(QSerialPort::NoParity);       // 设置无奇偶校验
    serialPortUart5->setStopBits(QSerialPort::OneStop);      // 设置1个停止位
    serialPortUart5->setFlowControl(QSerialPort::NoFlowControl); // 设置无流控制

    qDebug() << "Attempting to open UART5 on" << serialPortUart5->portName();
    
    // 尝试以读写模式打开串口
    if (!serialPortUart5->open(QIODevice::ReadWrite)) {
        emit errorOccurred(serialPortUart5->errorString());  // 发送错误信号
        qDebug() << "Error opening port UART5:" << serialPortUart5->errorString();
    } else {
        qDebug() << "Successfully opened UART5, port status: " << 
            (serialPortUart5->isOpen() ? "Open" : "Closed");
            
        // 打开端口后发送EDID数据请求命令，连续发送三次以确保可靠性
        qDebug() << "Sending initial EDID request commands";
        writeDataUart5("GET IN1 EDID1 DATA\r\n", 1);
        writeDataUart5("GET IN1 EDID1 DATA\r\n", 1);
        writeDataUart5("GET IN1 EDID1 DATA\r\n", 1);
    }
}

// 打开并配置UART6串口(连接到51单片机)
void SerialPortManager::openPortUart6()
{
    // 配置串口参数
    serialPortUart6->setPortName("/dev/ttyS6");              // 设置设备名称
    serialPortUart6->setBaudRate(QSerialPort::Baud115200);   // 设置波特率为115200
    serialPortUart6->setDataBits(QSerialPort::Data8);        // 设置数据位为8位
    serialPortUart6->setParity(QSerialPort::NoParity);       // 设置无奇偶校验
    serialPortUart6->setStopBits(QSerialPort::OneStop);      // 设置1个停止位
    serialPortUart6->setFlowControl(QSerialPort::NoFlowControl); // 设置无流控制

    // 尝试以读写模式打开串口
    if (!serialPortUart6->open(QIODevice::ReadWrite)) {
        emit errorOccurred(serialPortUart6->errorString());  // 发送错误信号
        qDebug() << "Error opening port:" << serialPortUart6->errorString();
    } else {
        qDebug() << "open port uart6!";
    }
}

// 关闭UART3串口
void SerialPortManager::closePort()
{
    if (serialPort->isOpen()) {
        serialPort->close();
        qDebug() << "close port!";
    }
}

// 关闭UART5串口
void SerialPortManager::closePortUart5()
{
    if (serialPortUart5->isOpen()) {
        serialPortUart5->close();
        qDebug() << "close port uart5!";
    }
}

// 关闭UART6串口
void SerialPortManager::closePortUart6()
{
    if (serialPortUart6->isOpen()) {
        serialPortUart6->close();
        qDebug() << "close port uart6!";
    }
}

// 计算校验和函数
// data: 需要计算校验和的数据字符串(十六进制格式，以空格分隔)
// 返回值: 计算得到的校验和字符串(两位十六进制)
QString calculateChecksum(const QString &data) {
    int32_t number = 0;
    QList<QString> baList = data.split(' ');  // 按空格分割数据

    // 将所有十六进制值转换为整数并求和
    for (int i = 0; i < baList.length(); i++) {
        bool ok;
        int value = baList[i].toInt(&ok, 16);
        if (ok) {
            number += value;
        } else {
            qDebug() << i << "\t" << baList[i] << "\t" << "Not a valid integer";
        }
    }

    // 取和的最后两位十六进制数
    QString hexString = QString::number(number, 16).toUpper();
    QString lastTwoDigits = hexString.right(2);

    bool ok;
    int value = lastTwoDigits.toInt(&ok, 16);
    if (ok) {
        // 计算校验和：取反+1
        value = ~value & 0xFF;
        value += 1;

        // 转回十六进制字符串，确保两位
        QString checksum = QString::number(value, 16).toUpper().rightJustified(2, '0');
        return checksum;
    } else {
        qDebug() << "Error: Last two digits are not a valid integer";
        return QString();
    }
}

// 向UART3写入数据
// data: 要发送的数据字符串
// typedata: 数据类型标志(0=需要计算校验和的十六进制数据, 1=直接发送的ASCII数据)
void SerialPortManager::writeData(const QString &data, int typedata)
{
    // 检查串口是否可用
    /*if (!serialPort || !serialPort->isOpen()) {
        qWarning() << "Cannot write to UART3: port not open";
        return;
    }*/
    
    QByteArray Data;
    if (typedata == 1) {
        // ASCII模式：直接转换字符串为Latin1编码
        Data = data.toLatin1();
        qDebug() << "write uart3:" << Data;
    } else {
        // 十六进制模式：计算校验和，添加到命令末尾，然后转换为二进制
        QString checksum = calculateChecksum(data);
        if (checksum.isEmpty()) {
            qDebug() << "Error: Failed to calculate checksum.";
            return;
        }
        QString finalData = data.trimmed() + " " + checksum.trimmed();
        Data = QByteArray::fromHex(finalData.toLatin1());
        qDebug() << "write uart3:" << finalData;
    }

    // 发送数据
    if (serialPort->isOpen()) {
        serialPort->write(Data);
    }
}

// 向UART5写入数据
// data: 要发送的数据字符串
// typedata: 数据类型标志(0=需要计算校验和的十六进制数据, 1=直接发送的ASCII数据)
void SerialPortManager::writeDataUart5(const QString &data, int typedata)
{
    // 添加串口状态检查日志
    qDebug() << "UART5 status: " << (serialPortUart5->isOpen() ? "Open" : "Closed")
             << ", Port name: " << serialPortUart5->portName()
             << ", Baud rate: " << serialPortUart5->baudRate();
    
    QByteArray Data;
    if (typedata == 1) {
        // ASCII模式：直接转换字符串为Latin1编码
        Data = data.toLatin1();
        qDebug() << "Write UART5 (ASCII):" << Data << ", Bytes:" << Data.toHex(' ').toUpper();
    } else {
        // 十六进制模式计算
        QString checksum = calculateChecksum(data);
        if (checksum.isEmpty()) {
            qDebug() << "Error: Failed to calculate checksum.";
            return;
        }
        QString finalData = data.trimmed() + " " + checksum.trimmed();
        Data = QByteArray::fromHex(finalData.toLatin1());
        qDebug() << "Write UART5 (HEX):" << finalData << ", Raw bytes:" << Data.toHex(' ').toUpper();
    }

    // 写入时捕获并处理错误
    if (serialPortUart5->isOpen()) {
        qint64 bytesWritten = serialPortUart5->write(Data);
        qDebug() << "UART5 write result: " << bytesWritten << " bytes written";
        
        if (bytesWritten == -1) {
            qWarning() << "Error writing to UART5:" << serialPortUart5->errorString();
        } else if (!serialPortUart5->waitForBytesWritten(1000)) {
            // 等待数据写入，最多1秒超时
            qWarning() << "Timeout writing to UART5:" << serialPortUart5->errorString();
        }
    } else {
        qWarning() << "Cannot write to UART5: port not open";
    }
}

// 重新打开UART5串口
// 在通信出错或串口连接丢失时使用
void SerialPortManager::reopenPortUart5()
{
    // 先关闭再打开
    closePortUart5();
    
    // 等待一小段时间以确保设备重置
    QThread::msleep(100);
    
    qDebug() << "Attempting to reopen UART5...";
    openPortUart5();
}

// 向UART6写入数据
// data: 要发送的数据字符串
// typedata: 数据类型标志(0=需要计算校验和的十六进制数据, 1=直接发送的ASCII数据)
void SerialPortManager::writeDataUart6(const QString &data, int typedata)
{
    // 检查串口是否可用
    /*if (!serialPortUart6 || !serialPortUart6->isOpen()) {
        qWarning() << "Cannot write to UART6: port not open";
        return;
    }*/
    
    QByteArray Data;
    if (typedata == 1) {
        // ASCII模式：直接转换字符串为Latin1编码
        Data = data.toLatin1();
//        qDebug() << "write uart6:" << Data;  // 已注释调试输出
    } else {
        // 十六进制模式：计算校验和，添加到命令末尾，然后转换为二进制
        QString checksum = calculateChecksum(data);
        if (checksum.isEmpty()) {
            qDebug() << "Error: Failed to calculate checksum.";
            return;
        }
        QString finalData = data.trimmed() + " " + checksum.trimmed();
        Data = QByteArray::fromHex(finalData.toLatin1());
//        qDebug() << "write uart6:" << finalData;  // 已注释调试输出
    }
    
    // 发送数据
    if (serialPortUart6->isOpen()) {
        serialPortUart6->write(Data);
    }
}

// 读取UART3的所有可用数据
// 返回值: 包含读取数据的字节数组
QByteArray SerialPortManager::readData()
{
    QByteArray data;
    if (serialPort->isOpen()) {
        data = serialPort->readAll();
    }
    return data;
}

// 读取UART5的所有可用数据
// 返回值: 包含读取数据的字节数组
QByteArray SerialPortManager::readDataUart5()
{
    QByteArray data;
    if (serialPortUart5->isOpen()) {
        data = serialPortUart5->readAll();
        qDebug() << "Data received from uart5:" << data.toHex(' ').toUpper();
    }
    return data;
}

// 读取UART6的所有可用数据
// 返回值: 包含读取数据的字节数组
QByteArray SerialPortManager::readDataUart6()
{
    QByteArray data;
    if (serialPortUart6->isOpen()) {
        data = serialPortUart6->readAll();
        qDebug() << "Data received from uart6:" << data.toHex(' ').toUpper();
    }
    return data;
}

// UART3数据就绪处理函数
// 当UART3接收到数据时自动调用
void SerialPortManager::onReadyRead()
{
    static QByteArray buffer;  // 静态缓冲区，保存跨多次调用的数据
    static int dataPacketCount = 0;  // 数据包计数器
    
    QByteArray data = serialPort->readAll();  // 读取所有可用数据
    
    // ========== FPGA图像数据格式分析日志 START ==========
    dataPacketCount++;
    qDebug() << "=== FPGA Data Analysis === Packet #" << dataPacketCount;
    qDebug() << "Raw data size:" << data.size() << "bytes";
    qDebug() << "Raw data (HEX):" << data.toHex(' ').toUpper();
    
    // 显示前64个字节的详细信息以分析数据格式
    if (data.size() > 0) {
        QString hexStr = data.left(64).toHex(' ').toUpper();
        qDebug() << "First 64 bytes:" << hexStr;
        
        // 检查可能的图像数据头部格式
        if (data.size() >= 4) {
            quint8 byte0 = static_cast<quint8>(data[0]);
            quint8 byte1 = static_cast<quint8>(data[1]);
            quint8 byte2 = static_cast<quint8>(data[2]);
            quint8 byte3 = static_cast<quint8>(data[3]);
            
            qDebug() << "Header analysis:" 
                     << "B0=" << QString("0x%1").arg(byte0, 2, 16, QChar('0')).toUpper()
                     << "B1=" << QString("0x%1").arg(byte1, 2, 16, QChar('0')).toUpper()
                     << "B2=" << QString("0x%1").arg(byte2, 2, 16, QChar('0')).toUpper()
                     << "B3=" << QString("0x%1").arg(byte3, 2, 16, QChar('0')).toUpper();
            
            // 检查常见图像格式标识
            if (data.startsWith("\xFF\xD8\xFF")) {
                qDebug() << "*** JPEG image format detected ***";
            } else if (data.startsWith("\x89PNG")) {
                qDebug() << "*** PNG image format detected ***";
            } else if (data.startsWith("\xAB\x00\x01")) {
                qDebug() << "*** Custom image header AB 00 01 detected ***";
            } else if (data.startsWith("\xAB\x00\x00")) {
                qDebug() << "*** Command packet AB 00 00 detected ***";
            } else {
                qDebug() << "*** Unknown format, possibly raw image data ***";
            }
        }
        
        // 如果是大数据包，可能是图像数据
        if (data.size() > 10000) {
            qDebug() << "*** LARGE DATA PACKET - Possible image data ***";
            qDebug() << "Size analysis:";
            qDebug() << "  1920x1080 RGB24 =" << (1920*1080*3) << "bytes";
            qDebug() << "  1280x720 RGB24  =" << (1280*720*3) << "bytes";
            qDebug() << "  Current size    =" << data.size() << "bytes";
            
            // 显示数据开头和结尾
            qDebug() << "Data head (32 bytes):" << data.left(32).toHex(' ').toUpper();
            qDebug() << "Data tail (32 bytes):" << data.right(32).toHex(' ').toUpper();
        }
    }
    qDebug() << "=== FPGA Data Analysis END ===";
    // ========== FPGA图像数据格式分析日志 END ==========
    
    buffer.append(data);  // 添加新数据到缓冲区

    // 处理缓冲区中的完整数据包
    while (buffer.size() >= 4) {
        qDebug() << "Processing buffer, current size:" << buffer.size();
        qDebug() << "Buffer first 16 bytes:" << buffer.left(16).toHex(' ').toUpper();
        
        // 检查数据包头标识(AB 00 00) - 命令包
        if (buffer.startsWith("\xAB\x00\x00")) {
            quint8 length = static_cast<quint8>(buffer.at(3));  // 获取数据包长度字段
            qDebug() << "Command packet detected, length field:" << length;

            // 如果缓冲区包含完整数据包
            if (buffer.size() >= 4 + length) {
                QByteArray packet = buffer.left(4 + length + 1);  // 提取完整数据包
                qDebug() << "Complete command packet:" << packet.toHex(' ').toUpper();
                emit dataReceived(packet.toHex(' ').toUpper());  // 发送数据接收信号
                buffer = buffer.mid(4 + length + 1);  // 从缓冲区移除已处理的数据包
            } else {
                qDebug() << "Incomplete command packet, waiting for more data";
                break;  // 数据包不完整，等待更多数据
            }
        }
        // 检查图像数据包头标识(AB 00 01) - 图像包
        else if (buffer.startsWith("\xAB\x00\x01")) {
            qDebug() << "*** IMAGE PACKET DETECTED ***";
            
            if (buffer.size() >= 8) {
                // 假设图像包的长度字段在第4-7字节(32位长度)
                quint32 imageLength = (static_cast<quint32>(buffer.at(7)) << 24) |
                                     (static_cast<quint32>(buffer.at(6)) << 16) |
                                     (static_cast<quint32>(buffer.at(5)) << 8) |
                                     static_cast<quint32>(buffer.at(4));
                
                qDebug() << "Image packet length:" << imageLength << "bytes";
                
                // 如果是完整的图像包
                if (static_cast<quint32>(buffer.size()) >= 8 + imageLength) {
                    QByteArray imagePacket = buffer.left(static_cast<int>(8 + imageLength));
                    qDebug() << "Complete image packet received, total size:" << imagePacket.size();
                    
                    // 提取图像数据部分
                    QByteArray imageData = imagePacket.mid(8);
                    qDebug() << "Image data size:" << imageData.size();
                    qDebug() << "Image data header:" << imageData.left(32).toHex(' ').toUpper();
                    
                    // 发送图像数据信号
                    emit imageDataReceived(imageData);
                    
                    buffer = buffer.mid(8 + imageLength);  // 移除已处理的图像包
                } else {
                    qDebug() << "Incomplete image packet, need" << (8 + imageLength) << "bytes, have" << buffer.size();
                    break;  // 等待更多数据
                }
            } else {
                qDebug() << "Image packet header incomplete, waiting for more data";
                break;
            }
        }
        // 检查Signal Info数据包头标识(AB 00 02) - 信号信息包
        else if (buffer.startsWith("\xAB\x00\x02")) {
            qDebug() << "*** SIGNAL INFO PACKET DETECTED ***";
            
            if (buffer.size() >= 5) {
                quint8 length = static_cast<quint8>(buffer.at(3));  // 获取数据包长度字段
                
                // 如果缓冲区包含完整数据包
                if (buffer.size() >= 4 + length + 1) {
                    QByteArray packet = buffer.left(4 + length + 1);
                    qDebug() << "Complete signal info packet:" << packet.toHex(' ').toUpper();
                    
                    // 解析信号信息数据并构造ASCII格式响应
                    if (packet.size() >= 9 && static_cast<quint8>(packet[7]) == 0x80) {
                        quint8 infoType = static_cast<quint8>(packet[6]);
                        QString infoName;
                        QString infoValue;
                        
                        switch(infoType) {
                            case 0x61:  // timing/视频格式
                                infoName = "VIDEO_FORMAT";
                                // 从packet[8]开始解析视频格式数据
                                // 示例：将二进制数据转换为格式字符串
                                if (packet.size() >= 12) {
                                    int width = (static_cast<quint8>(packet[8]) << 8) | static_cast<quint8>(packet[9]);
                                    int height = (static_cast<quint8>(packet[10]) << 8) | static_cast<quint8>(packet[11]);
                                    infoValue = QString("%1x%2").arg(width).arg(height);
                                }
                                break;
                            case 0x63:  // 色彩空间
                                infoName = "COLOR_SPACE";
                                if (packet.size() >= 9) {
                                    quint8 cs = static_cast<quint8>(packet[8]);
                                    infoValue = (cs == 0) ? "RGB" : (cs == 1) ? "YUV444" : "YUV422";
                                }
                                break;
                            case 0x64:  // 色彩深度
                                infoName = "COLOR_DEPTH";
                                if (packet.size() >= 9) {
                                    quint8 cd = static_cast<quint8>(packet[8]);
                                    infoValue = QString("%1-bit").arg(cd);
                                }
                                break;
                            case 0x65:  // HDCP类型
                                infoName = "HDCP_TYPE";
                                if (packet.size() >= 9) {
                                    quint8 hdcp = static_cast<quint8>(packet[8]);
                                    infoValue = (hdcp == 0) ? "None" : (hdcp == 1) ? "HDCP 1.4" : "HDCP 2.3";
                                }
                                break;
                            case 0x66:  // HDMI/DVI模式
                                infoName = "HDMI_DVI";
                                if (packet.size() >= 9) {
                                    quint8 mode = static_cast<quint8>(packet[8]);
                                    infoValue = (mode == 0) ? "DVI" : "HDMI";
                                }
                                break;
                            case 0x67:  // PCM采样率
                                infoName = "SAMPLING_FREQ";
                                if (packet.size() >= 9) {
                                    quint8 freq = static_cast<quint8>(packet[8]);
                                    infoValue = QString("%1 kHz").arg(freq);
                                }
                                break;
                            case 0x68:  // PCM位深
                                infoName = "SAMPLING_SIZE";
                                if (packet.size() >= 9) {
                                    quint8 bits = static_cast<quint8>(packet[8]);
                                    infoValue = QString("%1-bit").arg(bits);
                                }
                                break;
                            case 0x69:  // HDR格式
                                infoName = "HDR_FORMAT";
                                if (packet.size() >= 9) {
                                    quint8 hdr = static_cast<quint8>(packet[8]);
                                    switch(hdr) {
                                        case 0: infoValue = "SDR"; break;
                                        case 1: infoValue = "HDR10"; break;
                                        case 2: infoValue = "HDR10+"; break;
                                        case 3: infoValue = "Dolby Vision"; break;
                                        case 4: infoValue = "HLG"; break;
                                        default: infoValue = QString("HDR Type %1").arg(hdr); break;
                                    }
                                }
                                break;
                            case 0x6A:  // PCM通道数
                                infoName = "CHANNEL_COUNT";
                                if (packet.size() >= 9) {
                                    quint8 channels = static_cast<quint8>(packet[8]);
                                    switch(channels) {
                                        case 2: infoValue = "2.0 (Stereo)"; break;
                                        case 6: infoValue = "5.1 Surround"; break;
                                        case 8: infoValue = "7.1 Surround"; break;
                                        default: infoValue = QString("%1.0").arg(channels); break;
                                    }
                                }
                                break;
                            case 0x6B:  // 通道编号映射
                                infoName = "CHANNEL_NUMBER";
                                if (packet.size() >= 9) {
                                    quint8 mapping = static_cast<quint8>(packet[8]);
                                    switch(mapping) {
                                        case 0: infoValue = "FL/FR"; break;
                                        case 1: infoValue = "FL/FR/FC/LFE/BL/BR"; break;
                                        case 2: infoValue = "FL/FR/FC/LFE/BL/BR/SL/SR"; break;
                                        default: infoValue = QString("Channel Map %1").arg(mapping); break;
                                    }
                                }
                                break;
                            case 0x6C:  // 音频电平偏移
                                infoName = "LEVEL_SHIFT";
                                if (packet.size() >= 9) {
                                    qint8 shift = static_cast<qint8>(packet[8]);  // 使用有符号数
                                    infoValue = QString("%1 dB").arg(shift);
                                }
                                break;
                            case 0x6E:  // C-bit采样频率
                                infoName = "CBIT_SAMPLING_FREQ";
                                if (packet.size() >= 9) {
                                    quint8 level = static_cast<quint8>(packet[8]);
                                    infoValue = QString("Level %1").arg(level);
                                }
                                break;
                            case 0x6F:  // C-bit数据类型
                                infoName = "CBIT_DATA_TYPE";
                                if (packet.size() >= 9) {
                                    quint8 type = static_cast<quint8>(packet[8]);
                                    switch(type) {
                                        case 0: infoValue = "PCM"; break;
                                        case 1: infoValue = "AC-3"; break;
                                        case 2: infoValue = "MPEG-1"; break;
                                        case 3: infoValue = "MP3"; break;
                                        case 4: infoValue = "MPEG-2"; break;
                                        case 5: infoValue = "AAC"; break;
                                        case 6: infoValue = "DTS"; break;
                                        case 7: infoValue = "ATRAC"; break;
                                        default: infoValue = QString("Type %1").arg(type); break;
                                    }
                                }
                                break;
                            case 0x70:  // FRL速率
                                infoName = "FRL_RATE";
                                if (packet.size() >= 9) {
                                    quint8 rate = static_cast<quint8>(packet[8]);
                                    switch(rate) {
                                        case 0: infoValue = "TMDS"; break;
                                        case 1: infoValue = "FRL3 (9 Gbps)"; break;
                                        case 2: infoValue = "FRL6 (18 Gbps)"; break;
                                        case 3: infoValue = "FRL8 (24 Gbps)"; break;
                                        case 4: infoValue = "FRL10 (40 Gbps)"; break;
                                        case 5: infoValue = "FRL12 (48 Gbps)"; break;
                                        default: infoValue = QString("FRL %1").arg(rate); break;
                                    }
                                }
                                break;
                            case 0x71:  // DSC模式
                                infoName = "DSC_MODE";
                                if (packet.size() >= 9) {
                                    quint8 dsc = static_cast<quint8>(packet[8]);
                                    infoValue = (dsc == 0) ? "Disabled" : "Enabled";
                                }
                                break;
                            default:
                                qDebug() << "Unknown signal info type:" << QString("0x%1").arg(infoType, 2, 16, QChar('0')).toUpper();
                                break;
                        }
                        
                        // 构造ASCII格式响应并发送
                        if (!infoName.isEmpty() && !infoValue.isEmpty()) {
                            QString asciiResponse = QString("SIGNAL_INFO %1 %2\r\n").arg(infoName).arg(infoValue);
                            emit dataReceivedASCALL(asciiResponse);
                        }
                    }
                    
                    buffer = buffer.mid(4 + length + 1);  // 移除已处理的数据包
                } else {
                    qDebug() << "Incomplete signal info packet, waiting for more data";
                    break;
                }
            } else {
                qDebug() << "Signal info packet header incomplete";
                break;
            }
        }
        // 检查Error Rate监控数据包头标识(AB 00 03) - 监控数据包
        else if (buffer.startsWith("\xAB\x00\x03")) {
            qDebug() << "*** ERROR RATE MONITOR PACKET DETECTED ***";
            
            if (buffer.size() >= 5) {
                quint8 length = static_cast<quint8>(buffer.at(3));
                
                // 检查数据包格式：AB 00 03 <长度> <时间槽ID 2字节> <槽位ID 1字节> <状态数据 1字节>
                // 期望长度 = 2(时间槽ID) + 1(槽位ID) + 1(状态数据) = 4字节
                if (length == 4 && buffer.size() >= 4 + length + 1) {
                    QByteArray packet = buffer.left(4 + length + 1);
                    qDebug() << "Complete monitor packet:" << packet.toHex(' ').toUpper();
                    
                    // 解析监控数据
                    if (packet.size() >= 9) { // 4(头部) + 4(数据) + 1(校验) = 9
                        // 提取时间槽ID（2字节，大端序）
                        quint16 slotId = (static_cast<quint8>(packet[4]) << 8) | static_cast<quint8>(packet[5]);
                        QString slotIdStr = QString("%1").arg(slotId, 4, 10, QChar('0'));
                        
                        // 提取槽位ID（1字节，0-99）
                        quint8 slotIndex = static_cast<quint8>(packet[6]);
                        
                        // 提取状态数据（1字节，0=正常，非0=异常）
                        quint8 statusValue = static_cast<quint8>(packet[7]);
                        
                        qDebug() << "Time slot ID:" << slotIdStr 
                                 << "Slot index:" << slotIndex 
                                 << "Status:" << statusValue;
                        
                        // 只有异常时才处理（按照设计，FPGA只在检测到异常时发送数据包）
                        if (statusValue != 0) {
                            // 构造状态字符串：用于标识具体的槽位异常
                            // 格式：时间槽ID + 槽位索引 + 状态值
                            QString monitorData = QString("SIGNAL_SLOT %1 %2 %3")
                                .arg(slotIdStr)
                                .arg(slotIndex, 2, 10, QChar('0'))  // 槽位ID，补齐为2位
                                .arg(statusValue);                   // 状态值
                            
                            emit signalMonitorDataReceived(monitorData.toUtf8());
                            
                            qDebug() << "ERROR detected - Slot" << slotIdStr 
                                     << "Position" << slotIndex 
                                     << "Error type" << statusValue;
                        } else {
                            // 如果FPGA发送了状态=0的包，记录但不处理
                            qDebug() << "Normal status packet received (unusual) - Slot" << slotIdStr 
                                     << "Position" << slotIndex;
                        }
                    }
                    
                    buffer = buffer.mid(4 + length + 1);  // 移除已处理的数据包
                } else {
                    if (length != 4) {
                        qWarning() << "Unexpected monitor packet length:" << length << ", expected 4";
                        buffer.remove(0, 1); // 移除错误的包头，继续寻找
                    } else {
                        qDebug() << "Incomplete monitor packet, need" << (4 + length + 1) << "bytes, have" << buffer.size();
                        break; // 等待更多数据
                    }
                }
            } else {
                qDebug() << "Monitor packet header incomplete";
                break;
            }
        }
        else {
            // 检查是否可能是原始图像流数据
            if (buffer.size() > 50000) {  // 大于50KB可能是原始图像
                qDebug() << "*** LARGE BUFFER - Possible raw image stream ***";
                qDebug() << "Buffer size:" << buffer.size();
                qDebug() << "Raw data pattern analysis:";
                qDebug() << "  First 32 bytes:" << buffer.left(32).toHex(' ').toUpper();
                qDebug() << "  Bytes at 1000:" << buffer.mid(1000, 32).toHex(' ').toUpper();
                qDebug() << "  Last 32 bytes:" << buffer.right(32).toHex(' ').toUpper();
                
                // 假设整个缓冲区是图像数据，直接处理
                emit imageDataReceived(buffer);
                buffer.clear();
                break;
            } else {
                // 记录无法识别的数据
                qDebug() << "Unrecognized data, removing byte:" 
                         << QString("0x%1").arg(static_cast<unsigned char>(buffer.at(0)), 2, 16, QChar('0')).toUpper();
                buffer.remove(0, 1);  // 移除一个字节，继续寻找包头
            }
        }
    }
}

// UART5数据就绪处理函数
// 当UART5接收到数据时自动调用
void SerialPortManager::onReadyReadUart5()
{
    QByteArray data = serialPortUart5->readAll();  // 读取所有可用数据
    qDebug() << "Raw data received from UART5:" << data;
    qDebug() << "Hex data received from UART5:" << data.toHex(' ').toUpper();
    
    static QByteArray buffer;  // 静态缓冲区，保存跨多次调用的数据
    buffer.append(data);  // 添加新数据到缓冲区

    // 处理缓冲区中的完整行(以\r\n结尾)
    while (true) {
        int endPos = buffer.indexOf("\r\n");  // 寻找行结束符
        if (endPos == -1) {
            break;  // 没有完整行，等待更多数据
        }

        QByteArray packet = buffer.left(endPos + 2);  // 提取完整行，包括\r\n
        QString packetStr = QString::fromUtf8(packet);  // 转换为Unicode字符串
        qDebug() << "Complete packet from UART5:" << packet;
        
        // 处理不同类型的数据
        if (packetStr.startsWith("SIGNAL_SLOT")) {
            // 发送信号监控专用信号
            qDebug() << "Emitting signalMonitorDataReceived with data:" << packet;
            emit signalMonitorDataReceived(packet);
        } else if (packetStr.startsWith("EDID")) {
            qDebug() << "EDID data received:" << packetStr;
            emit dataReceivedASCALL(packetStr);
        } else if (packetStr.startsWith("SIGNAL")) {
            // 处理其他信号相关数据（如GET SIGNAL命令的响应）
            qDebug() << "Signal info data received:" << packetStr;
            emit dataReceivedASCALL(packetStr);
        } else {
            // 其他常规数据处理
            qDebug() << "Emitting dataReceivedASCALL with data:" << packetStr;
            emit dataReceivedASCALL(packetStr);
        }
        
        buffer.remove(0, endPos + 2);  // 从缓冲区移除已处理的行
    }

    // 防止缓冲区溢出
    if (buffer.size() > 1024) {
        qWarning() << "Buffer overflow, clearing invalid data";
        buffer.clear();  // 清空过大的缓冲区
    }
}

// UART6数据就绪处理函数
// 当UART6接收到数据时自动调用
void SerialPortManager::onReadyReadUart6()
{
    QByteArray data = serialPortUart6->readAll();  // 读取所有可用数据
    static QByteArray buffer;  // 静态缓冲区，保存跨多次调用的数据
    buffer.append(data);  // 添加新数据到缓冲区

    // 处理缓冲区中的完整数据包
    while (buffer.size() >= 4) {
        // 检查数据包头标识(AB 01 00)
        if (buffer.startsWith("\xAB\x01\x00")) {
            quint8 length = static_cast<quint8>(buffer.at(3));  // 获取数据包长度字段

            // 如果缓冲区包含完整数据包
            if (buffer.size() >= 4 + length) {
                QByteArray packet = buffer.left(5 + length);  // 提取完整数据包
//                qDebug() << "Data received from uart6:" << packet.toHex(' ').toUpper();  // 已注释调试输出
                emit dataReceived(packet.toHex(' ').toUpper());  // 发送数据接收信号
                buffer = buffer.mid(4 + length);  // 从缓冲区移除已处理的数据包
            } else {
                break;  // 数据包不完整，等待更多数据
            }
        } else {
            buffer.remove(0, 1);  // 移除一个字节，继续寻找包头
        }
    }
}
