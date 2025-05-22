// 包含必要的头文件
#include "serialportmanager.h"    // 类定义头文件
#include <QByteArray>             // 提供字节数组处理功能
#include <QDebug>                 // 提供调试输出功能
#include <QThread>                // 提供线程相关功能，用于延时等操作

// 构造函数：初始化串口管理器并打开串口连接
// parent: 父对象指针，用于Qt对象树管理
SerialPortManager::SerialPortManager(QObject *parent) :
    QObject(parent),
    serialPort(new QSerialPort(this)),       // 初始化uart3，连接FPGA
    serialPortUart5(new QSerialPort(this)),  // 初始化uart5，连接MCU
    serialPortUart6(new QSerialPort(this))   // 初始化uart6，连接51单片机
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
}

// 析构函数：确保在对象销毁时关闭串口
SerialPortManager::~SerialPortManager()
{
    if (serialPort->isOpen()) {
        serialPort->close();  // 关闭UART3
    }
    // 注意：没有显式关闭UART5和UART6，它们将在QSerialPort对象销毁时自动关闭
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

    // 尝试以读写模式打开串口
    if (!serialPortUart5->open(QIODevice::ReadWrite)) {
        emit errorOccurred(serialPortUart5->errorString());  // 发送错误信号
        qDebug() << "Error opening port:" << serialPortUart5->errorString();
    } else {
        qDebug() << "open port uart5!";
        // 打开端口后发送EDID数据请求命令，连续发送三次以确保可靠性
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
    if (!serialPort || !serialPort->isOpen()) {
        qWarning() << "Cannot write to UART3: port not open";
        return;
    }
    
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
    // 检查串口状态
    if (!serialPortUart5 || !serialPortUart5->isOpen()) {
        qWarning() << "Cannot write to UART5: port not open";
        // 尝试重新打开
        if (serialPortUart5) {
            reopenPortUart5();
        }
        return;
    }
    
    QByteArray Data;
    if (typedata == 1) {
        // ASCII模式：直接转换字符串为Latin1编码
        Data = data.toLatin1();
        qDebug() << "write uart5:" << Data;
    } else {
        // 十六进制模式：计算校验和，添加到命令末尾，然后转换为二进制
        QString checksum = calculateChecksum(data);
        if (checksum.isEmpty()) {
            qDebug() << "Error: Failed to calculate checksum.";
            return;
        }
        QString finalData = data.trimmed() + " " + checksum.trimmed();
        Data = QByteArray::fromHex(finalData.toLatin1());
        qDebug() << "write uart5:" << finalData;
    }

    // 写入时捕获并处理错误
    if (serialPortUart5->isOpen()) {
        qint64 bytesWritten = serialPortUart5->write(Data);
        if (bytesWritten == -1) {
            qWarning() << "Error writing to UART5:" << serialPortUart5->errorString();
        } else if (!serialPortUart5->waitForBytesWritten(1000)) {
            // 等待数据写入，最多1秒超时
            qWarning() << "Timeout writing to UART5:" << serialPortUart5->errorString();
        }
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
    if (!serialPortUart6 || !serialPortUart6->isOpen()) {
        qWarning() << "Cannot write to UART6: port not open";
        return;
    }
    
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
    QByteArray data = serialPort->readAll();  // 读取所有可用数据
//    qDebug() << "Data received from uart3:" << data;  // 已注释调试输出
    buffer.append(data);  // 添加新数据到缓冲区

    // 处理缓冲区中的完整数据包
    while (buffer.size() >= 4) {
        // 检查数据包头标识(AB 00 00)
        if (buffer.startsWith("\xAB\x00\x00")) {
            quint8 length = static_cast<quint8>(buffer.at(3));  // 获取数据包长度字段

            // 如果缓冲区包含完整数据包
            if (buffer.size() >= 4 + length) {
                QByteArray packet = buffer.left(5 + length);  // 提取完整数据包
                qDebug() << "Data received from uart3:" << packet.toHex(' ').toUpper();
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

// UART5数据就绪处理函数
// 当UART5接收到数据时自动调用
void SerialPortManager::onReadyReadUart5()
{
    QByteArray data = serialPortUart5->readAll();  // 读取所有可用数据
//    qDebug() << "Data received from uart5:" << data;  // 已注释调试输出
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
        qDebug() << "Data received from uart5:" << packet;
        
        // 处理信号监控数据
        if (packetStr.startsWith("SIGNAL_SLOT")) {
            // 发送信号监控专用信号
            emit signalMonitorDataReceived(packet);
        } else {
            // 其他常规数据处理
            emit dataReceivedASCALL(packetStr);
        }
        //emit dataReceivedASCALL(packetStr);  // 已注释的重复调用
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