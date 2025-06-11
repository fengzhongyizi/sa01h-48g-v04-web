#include "cht8310.h"
#include <QDebug>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>
#include <QThread>

#define CHT8310_ADDR 0x40

CHT8310::CHT8310(QObject *parent) : QObject(parent)
{
}

float CHT8310::temperature() const
{
    return m_temperature;
}

float CHT8310::humidity() const
{
    return m_humidity;
}

bool CHT8310::isAvailable() const
{
    return m_available;
}

QString CHT8310::i2cDevice() const
{
    return m_i2cDevice;
}

void CHT8310::setI2cDevice(const QString &device)
{
    if (m_i2cDevice == device)
        return;

    m_i2cDevice = device;
    emit i2cDeviceChanged();

    if (m_file >= 0) {
        closeDevice();
        initialize();
    }
}

bool CHT8310::initialize()
{
    if (m_file >= 0) {
        closeDevice();
    }

    return openDevice();
}

bool CHT8310::openDevice()
{
    m_file = open(m_i2cDevice.toUtf8().constData(), O_RDWR);
    if (m_file < 0) {
        qWarning() << "Failed to open I2C device" << m_i2cDevice;
        m_available = false;
        emit availabilityChanged(false);
        emit errorOccurred(tr("Failed to open I2C device"));
        return false;
    }

    if (ioctl(m_file, I2C_SLAVE, CHT8310_ADDR) < 0) {
        qWarning() << "Failed to set I2C slave address";
        closeDevice();
        emit errorOccurred(tr("Failed to set I2C address"));
        return false;
    }

    m_available = true;
    emit availabilityChanged(true);
    return true;
}

void CHT8310::closeDevice()
{
    if (m_file >= 0) {
        close(m_file);
        m_file = -1;
    }
    m_available = false;
    emit availabilityChanged(false);
}

bool CHT8310::readData()
{
    if (m_file < 0 && !openDevice()) {
        return false;
    }

//    uint8_t idCmd[2] = {0xFE, 0x00};
//    if (write(m_file, idCmd, 2) != 2) {
//        qWarning() << "Failed to send ID read command";
//        return false;
//    }

//    QThread::msleep(10);

//    uint8_t idData[2];
//    if (read(m_file, idData, 2) != 2) {
//        qWarning() << "Failed to read ID data";
//        return false;
//    }
//    qWarning() << "ID bytes:" << idData[0] << idData[1] ;

//    QThread::msleep(100);

    uint8_t tmpCmd[2] = {0x00,0x00 };
    if (write(m_file, tmpCmd, 2) != 2) {
        qWarning() << "Failed to send temperature read command";
        return false;
    }

    QThread::msleep(100);
    uint8_t buf[4];
    if (read(m_file, buf, 4) != 4) {
        qWarning() << "I2C read failed";
        emit errorOccurred(tr("I2C read failed"));
        closeDevice();
        return false;
    }
//    qWarning() << "read data:" << buf[0] << buf[1]<< buf[2] << buf[3];

    uint16_t tempRaw = (buf[0] << 8) | buf[1];
    m_temperature = (tempRaw >> 3) * 0.03125f;
    emit dataUpdated();
    return true;
}
