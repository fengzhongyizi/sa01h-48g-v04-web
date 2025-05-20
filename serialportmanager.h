#ifndef SERIALPORTMANAGER_H
#define SERIALPORTMANAGER_H

#include <QObject>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>


class SerialPortManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY availablePortsChanged)
public:
    explicit SerialPortManager(QObject *parent = nullptr);
    ~SerialPortManager();

    QStringList availablePorts() const;
    Q_INVOKABLE void openPort();
    Q_INVOKABLE void closePort();
    Q_INVOKABLE void writeData(const QString &data, int typedata);
    Q_INVOKABLE QByteArray readData();


    Q_INVOKABLE void openPortUart5();
    Q_INVOKABLE void closePortUart5();
    Q_INVOKABLE void writeDataUart5(const QString &data, int typedata);
    Q_INVOKABLE QByteArray readDataUart5();

    Q_INVOKABLE void openPortUart6();
    Q_INVOKABLE void closePortUart6();
    Q_INVOKABLE void writeDataUart6(const QString &data, int typedata);
    Q_INVOKABLE QByteArray readDataUart6();

    // 添加这些检查方法
    bool isUart3Available() const { return serialPort && serialPort->isOpen(); }
    bool isUart5Available() const { return serialPortUart5 && serialPortUart5->isOpen(); }
    bool isUart6Available() const { return serialPortUart6 && serialPortUart6->isOpen(); }
       

signals:
    void dataReceived(const QByteArray &data);
    void dataReceivedASCALL(const QString  &data);
    void errorOccurred(const QString &error);
    void availablePortsChanged();
    // 新增信号监控专用信号
    void signalMonitorDataReceived(const QByteArray &data);

private slots:
    void onReadyRead();
    void onReadyReadUart5();
    void onReadyReadUart6();
    

private:
    QSerialPort *serialPort;
    QSerialPort *serialPortUart5;
    QSerialPort *serialPortUart6;

    void reopenPortUart5();  
};
#endif // SERIALPORTMANAGER_H
