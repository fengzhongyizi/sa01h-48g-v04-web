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

    Q_INVOKABLE bool isUart5Open() const;
    Q_INVOKABLE QString getUart5Status() const;

signals:
    void dataReceived(const QByteArray &data);
    void dataReceivedASCALL(const QString  &data);
    void errorOccurred(const QString &error);
    void availablePortsChanged();
    void isBlackChanged(bool isBlack);

private slots:
    void onReadyRead();
    void onReadyReadUart5();
    void onReadyReadUart6();

private:
    QSerialPort *serialPort;
    QSerialPort *serialPortUart5;
    QSerialPort *serialPortUart6;
};
#endif // SERIALPORTMANAGER_H
