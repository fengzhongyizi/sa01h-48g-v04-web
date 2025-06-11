#ifndef CHT8310_H
#define CHT8310_H

#include <QObject>
#include <QString>

class CHT8310 : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float temperature READ temperature NOTIFY dataUpdated)
    Q_PROPERTY(float humidity READ humidity NOTIFY dataUpdated)
    Q_PROPERTY(bool available READ isAvailable NOTIFY availabilityChanged)
    Q_PROPERTY(QString i2cDevice READ i2cDevice WRITE setI2cDevice NOTIFY i2cDeviceChanged)

public:
    explicit CHT8310(QObject *parent = nullptr);

    float temperature() const;
    float humidity() const;
    bool isAvailable() const;
    QString i2cDevice() const;

    Q_INVOKABLE bool initialize();
    Q_INVOKABLE bool readData();

public slots:
    void setI2cDevice(const QString &device);

signals:
    void dataUpdated();
    void availabilityChanged(bool available);
    void errorOccurred(const QString &error);
    void i2cDeviceChanged();

private:
    bool openDevice();
    void closeDevice();

    QString m_i2cDevice = "/dev/i2c-1";
    int m_file = -1;
    float m_temperature = 0.0f;
    float m_humidity = 0.0f;
    bool m_available = false;
};

#endif // CHT8310_H
