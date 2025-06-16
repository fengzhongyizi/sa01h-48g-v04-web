#include "serialportmanager.h"
#include <QByteArray>
#include <QDebug>

SerialPortManager::SerialPortManager(QObject *parent) :
    QObject(parent),
    serialPort(new QSerialPort(this)),       // uart3:fpga
    serialPortUart5(new QSerialPort(this)),  // uart5:mcu
    serialPortUart6(new QSerialPort(this))  // uart6:51
{
    connect(serialPort, &QSerialPort::readyRead, this, &SerialPortManager::onReadyRead);
    connect(serialPortUart5, &QSerialPort::readyRead, this, &SerialPortManager::onReadyReadUart5);
    connect(serialPortUart6, &QSerialPort::readyRead, this, &SerialPortManager::onReadyReadUart6);
    emit availablePortsChanged();
    openPort();
    openPortUart5();
    openPortUart6();
}

SerialPortManager::~SerialPortManager()
{
    if (serialPort->isOpen()) {
        serialPort->close();
    }
}

QStringList SerialPortManager::availablePorts() const {
    QStringList portNames;
    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : infos) {
        portNames.append(info.portName());
    }
    return portNames;
}

void SerialPortManager::openPort()
{
    serialPort->setPortName("/dev/ttyS3");
    serialPort->setBaudRate(QSerialPort::Baud115200);
    serialPort->setDataBits(QSerialPort::Data8);
    serialPort->setParity(QSerialPort::NoParity);
    serialPort->setStopBits(QSerialPort::OneStop);
    serialPort->setFlowControl(QSerialPort::NoFlowControl);

    if (!serialPort->open(QIODevice::ReadWrite)) {
        emit errorOccurred(serialPort->errorString());
        qDebug() << "Error opening port:" << serialPort->errorString();
    }else{
        qDebug()<<"open port!";
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

void SerialPortManager::openPortUart5()
{
    serialPortUart5->setPortName("/dev/ttyS5");
    serialPortUart5->setBaudRate(QSerialPort::Baud57600);
    serialPortUart5->setDataBits(QSerialPort::Data8);
    serialPortUart5->setParity(QSerialPort::NoParity);
    serialPortUart5->setStopBits(QSerialPort::OneStop);
    serialPortUart5->setFlowControl(QSerialPort::NoFlowControl);

    if (!serialPortUart5->open(QIODevice::ReadWrite)) {
        emit errorOccurred(serialPortUart5->errorString());
        qDebug() << "Error opening port:" << serialPortUart5->errorString();
    }else{
        qDebug()<<"open port uart5!";
//        writeDataUart5("GET NTC 1 VALUE\r\n",1);
//        writeDataUart5("GET NTC 1 VALUE\r\n",1);
//        writeDataUart5("GET IN1 EDID1 DATA\r\n",1);
//        writeDataUart5("GET EDID U0 NAME\r\n",1);
//        writeDataUart5("GET EDID U1 NAME\r\n",1);
//        qDebug()<<"----- uart5! -----";
//        writeDataUart5("GET IN1 EDID1 DATA\r\n",1);
//        writeDataUart5("GET IN1 EDID1 DATA\r\n",1);
    }
}

void SerialPortManager::openPortUart6()
{
    serialPortUart6->setPortName("/dev/ttyS6");
    serialPortUart6->setBaudRate(QSerialPort::Baud115200);
    serialPortUart6->setDataBits(QSerialPort::Data8);
    serialPortUart6->setParity(QSerialPort::NoParity);
    serialPortUart6->setStopBits(QSerialPort::OneStop);
    serialPortUart6->setFlowControl(QSerialPort::NoFlowControl);

    if (!serialPortUart6->open(QIODevice::ReadWrite)) {
        emit errorOccurred(serialPortUart6->errorString());
        qDebug() << "Error opening port:" << serialPortUart6->errorString();
    }else{
        qDebug()<<"open port uart6!";
        writeDataUart6("AA 01 00 05 00 01 00 98 80",0);
        writeDataUart6("AA 01 00 05 00 01 00 99 80",0);
    }
}

void SerialPortManager::closePort()
{
    if (serialPort->isOpen()) {
        serialPort->close();
        qDebug()<<"close port!";
    }
}

void SerialPortManager::closePortUart5()
{
    if (serialPortUart5->isOpen()) {
        serialPortUart5->close();
        qDebug() << "close port uart5!";
    }
}

void SerialPortManager::closePortUart6()
{
    if (serialPortUart6->isOpen()) {
        serialPortUart6->close();
        qDebug() << "close port uart6!";
    }
}


QString calculateChecksum(const QString &data) {
    int32_t number = 0;
    QList<QString> baList = data.split(' ');

    for (int i = 0; i < baList.length(); i++) {
        bool ok;
        int value = baList[i].toInt(&ok, 16);
        if (ok) {
            number += value;
        } else {
            qDebug() << i << "\t" << baList[i] << "\t" << "Not a valid integer";
        }
    }

    QString hexString = QString::number(number, 16).toUpper();
    QString lastTwoDigits = hexString.right(2);

    bool ok;
    int value = lastTwoDigits.toInt(&ok, 16);
    if (ok) {
        value = ~value & 0xFF;
        value += 1;

        QString checksum = QString::number(value, 16).toUpper().rightJustified(2, '0');
        return checksum;
    } else {
        qDebug() << "Error: Last two digits are not a valid integer";
        return QString();
    }

}


void SerialPortManager::writeData(const QString &data, int typedata)
{
    QByteArray Data;
    if(typedata==1){
        Data = data.toLatin1();
        qDebug() << "write uart3:" << Data;
    }else {
        QString checksum = calculateChecksum(data);
        if (checksum.isEmpty()) {
            qDebug() << "Error: Failed to calculate checksum.";
            return;
        }
        QString finalData = data.trimmed() + " " + checksum.trimmed();
        Data = QByteArray::fromHex(finalData.toLatin1());
        qDebug() << "write uart3:" << finalData;
    }

    if (serialPort->isOpen()) {
        serialPort->write(Data);
    }
}

void SerialPortManager::writeDataUart5(const QString &data, int typedata)
{
    QByteArray Data;
    if(typedata==1){
        Data = data.toLatin1();
        qDebug() << "write uart5:" << Data;
    }else {
        QString checksum = calculateChecksum(data);
        if (checksum.isEmpty()) {
            qDebug() << "Error: Failed to calculate checksum.";
            return;
        }
        QString finalData = data.trimmed() + " " + checksum.trimmed();
        Data = QByteArray::fromHex(finalData.toLatin1());
        qDebug() << "write uart5:" << finalData;
    }

    if (serialPortUart5->isOpen()) {
        serialPortUart5->write(Data);
    }
}

void SerialPortManager::writeDataUart6(const QString &data, int typedata)
{
     QByteArray Data;
    if(typedata==1){
        Data = data.toLatin1();
        qDebug() << "write uart6:" << Data;
    }else {
        QString checksum = calculateChecksum(data);
        if (checksum.isEmpty()) {
            qDebug() << "Error: Failed to calculate checksum.";
            return;
        }
        QString finalData = data.trimmed() + " " + checksum.trimmed();
        Data = QByteArray::fromHex(finalData.toLatin1());
        qDebug() << "write uart6:" << finalData;
    }
    if (serialPortUart6->isOpen()) {
        serialPortUart6->write(Data);
    }
}

QByteArray SerialPortManager::readData()
{
    QByteArray data;
    if (serialPort->isOpen()) {
        data = serialPort->readAll();
    }
    return data;
}

QByteArray SerialPortManager::readDataUart5()
{
    QByteArray data;
    if (serialPortUart5->isOpen()) {
        data = serialPortUart5->readAll();
        qDebug() << "Data received from uart5:" << data.toHex(' ').toUpper();
    }
    return data;
}

QByteArray SerialPortManager::readDataUart6()
{
    QByteArray data;
    if (serialPortUart6->isOpen()) {
        data = serialPortUart6->readAll();
        qDebug() << "Data received from uart6:" << data.toHex(' ').toUpper();
    }
    return data;
}

void SerialPortManager::onReadyRead()
{
    static QByteArray buffer;
    QByteArray data = serialPort->readAll();
    qDebug() << "Data received from uart3:" << data;
    buffer.append(data);

    while (buffer.size() >= 4) {
        emit isBlackChanged(false);
        if (buffer.startsWith("\xAB\x00\x00")) {
            quint8 length = static_cast<quint8>(buffer.at(3));

            if (buffer.size() >= 4 + length) {
                QByteArray packet = buffer.left(5 + length);
                qDebug() << "Data received from uart3:" << packet.toHex(' ').toUpper();
                emit dataReceived(packet.toHex(' ').toUpper());
                buffer = buffer.mid(4 + length);
            } else {
                break;
            }
        } else {
            buffer.remove(0, 1);
        }
    }

}

void SerialPortManager::onReadyReadUart5()
{
    QByteArray data = serialPortUart5->readAll();
    qDebug() << "Data received from uart5:" << data;
    static QByteArray buffer;
    buffer.append(data);

    while (true) {
        int endPos = buffer.indexOf("\r\n");
        if (endPos == -1) {
            break;
        }

        QByteArray packet = buffer.left(endPos + 2);
        QString packetStr = QString::fromUtf8(packet);
        qDebug() << "Data received from uart5:" << packet;
        emit dataReceivedASCALL(packetStr);
        buffer.remove(0, endPos + 2);
    }

    if (buffer.size() > 1024) {
        qWarning() << "Buffer overflow, clearing invalid data";
        buffer.clear();
    }
}

void SerialPortManager::onReadyReadUart6()
{
    QByteArray data = serialPortUart6->readAll();
    qDebug() << "Data received from uart6:" << data;
    if(data.indexOf("\r\n")!=-1){
        emit dataReceivedASCALL(QString::fromUtf8(data));
    }

    static QByteArray buffer;
    buffer.append(data);

    while (buffer.size() >= 4) {
        if (buffer.startsWith("\xAB\x01\x00")) {
            quint8 length = static_cast<quint8>(buffer.at(3));

            if (buffer.size() >= 4 + length) {
                QByteArray packet = buffer.left(5 + length);
                qDebug() << "Data received from uart6:" << packet.toHex(' ').toUpper();
                emit dataReceived(packet.toHex(' ').toUpper());
                buffer = buffer.mid(4 + length);
            } else {
                break;
            }
        } else {
            buffer.remove(0, 1);
        }
    }
}
