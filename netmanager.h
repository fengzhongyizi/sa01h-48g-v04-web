#ifndef NETMANAGER_H
#define NETMANAGER_H

#include <QObject>
#include <QNetworkInterface>
#include <QNetworkAddressEntry>

class NetManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ipAddress READ ipAddress NOTIFY ipAddressChanged)
    Q_PROPERTY(QString netmask READ netmask NOTIFY netmaskChanged)
    Q_PROPERTY(QString macAddress READ macAddress NOTIFY macAddressChanged)
    Q_PROPERTY(QString routerIpAddress READ routerIpAddress NOTIFY routerIpAddressChanged)
    Q_PROPERTY(QString tcpPorts READ tcpPorts NOTIFY tcpPortsChanged)

public:
    explicit NetManager(QObject* parent = nullptr);

    QString ipAddress() const;
    QString netmask() const;
    QString macAddress() const;
    QString routerIpAddress() const;
    QString tcpPorts() const;

    Q_INVOKABLE void setIpAddress(const QString& ipAddress, const QString& netmask,const QString& gateway,const QString& mode);

signals:
    void ipAddressChanged(const QString &data);
    void netmaskChanged(const QString &data);
    void macAddressChanged(const QString &data);
    void routerIpAddressChanged(const QString &data);
    void tcpPortsChanged(const QString &data);

public slots:
    void updateNetworkInfo();

private:
    QString m_ipAddress;
    QString m_netmask;
    QString m_macAddress;
    QString m_routerIpAddress;
    QString m_tcpPorts;
};

#endif // NETMANAGER_H
