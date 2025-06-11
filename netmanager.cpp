#include "netmanager.h"
#include <QProcess>
#include <QTimer>
NetManager::NetManager(QObject* parent)
    : QObject(parent) {
//    setIpAddress("192.168.1.239", "255.255.255.0","192.168.1.1","static");
    updateNetworkInfo();
    qDebug() << "net.....";
}

QString NetManager::ipAddress() const {
    return m_ipAddress;
}

QString NetManager::netmask() const {
    return m_netmask;
}

QString NetManager::macAddress() const {
    return m_macAddress;
}

QString NetManager::routerIpAddress() const {
    return m_routerIpAddress;
}

QString NetManager::tcpPorts() const {
    return m_tcpPorts;
}

void NetManager::updateNetworkInfo() {
    foreach (const QNetworkInterface& networkInterface, QNetworkInterface::allInterfaces()) {
        if (networkInterface.name() == "eth0") {
            m_macAddress = networkInterface.hardwareAddress();
            emit macAddressChanged(m_macAddress);

            foreach (const QNetworkAddressEntry& addressEntry, networkInterface.addressEntries()) {
                if (addressEntry.ip().protocol() == QAbstractSocket::IPv4Protocol) {
                    m_ipAddress = addressEntry.ip().toString();
                    m_netmask = addressEntry.netmask().toString();
                    emit ipAddressChanged(m_ipAddress);
                    emit netmaskChanged(m_netmask);
                    qDebug() << "m_ipAddress="<<m_ipAddress;
                    qDebug() << "m_netmask="<<m_netmask;
                }
            }
        }
    }

    QProcess process;
    process.start("sh", QStringList() << "-c" << "ip route | grep default");
    process.waitForFinished();
    QString output = process.readAllStandardOutput();

    QStringList outputList = output.split(" ");
    if (outputList.size()>=2) {
        m_routerIpAddress = outputList[2];
        qDebug() << "m_routerIpAddress="<<m_routerIpAddress;
    } else {
//        m_routerIpAddress = "0.0.0.0";
    }
    emit routerIpAddressChanged(m_routerIpAddress);

    process.start("sh", QStringList() << "-c" << "netstat -tln | grep LISTEN");
    process.waitForFinished();
    output = process.readAllStandardOutput();
    QStringList outputList1 = output.split(" ");
    QString token = outputList1.value(15);
    QString port  = token.split(":").value(1);
    m_tcpPorts = port;
}

//void NetManager::setIpAddress(const QString& ipAddress, const QString& netmask, const QString& gateway, const QString& mode) {
//    QProcess process;
//    QString configCommand;

//    process.start("sh", QStringList() << "-c" << "mount -o remount,rw / ");
//    process.waitForFinished();

//    if (mode == "dhcp") {
//        configCommand = QString("echo -e 'auto eth0\\niface eth0 inet dhcp' > /etc/network/interfaces");
//    } else {
//        configCommand = QString("echo -e 'auto eth0\\niface eth0 inet static\\n"
//                              "address %1\\n"
//                              "netmask %2\\n"
//                              "gateway %3' > /etc/network/interfaces")
//                      .arg(ipAddress).arg(netmask).arg(gateway);
//    }

//    process.start("sh", QStringList() << "-c" << configCommand);
//    process.waitForFinished();

//    if (process.exitStatus() == QProcess::NormalExit && process.exitCode() == 0) {
//        qDebug() << "Network configuration saved successfully.";

//        process.start("sh", QStringList() << "-c" << "/etc/init.d/S40network restart");
//        process.waitForFinished();

//        if (process.exitStatus() == QProcess::NormalExit && process.exitCode() == 0) {
//            qDebug() << "Network restarted successfully.";
//            QTimer::singleShot(2000, this, &NetManager::updateNetworkInfo);
//        } else {
//            qWarning() << "Failed to restart network:" << process.readAllStandardError();
//        }
//    } else {
//        qWarning() << "Failed to save network configuration:" << process.readAllStandardError();
//    }
//}


//void NetManager::setIpAddress(const QString& ipAddress, const QString& netmask, const QString& gateway, const QString& mode) {
//    QProcess process;
//    QString command;

//    process.start("ip", QStringList() << "addr" << "flush" << "dev" << "eth0");
//    process.waitForFinished();

//    process.start("ip", QStringList() << "route" << "del" << "default");
//    process.waitForFinished();

//    if (mode == "dhcp") {
//        command = "udhcpc -i eth0";
//    } else {
//        command = QString("ip addr flush eth0 && ifconfig eth0 %1 netmask %2 up && route add default gw %3")
//                     .arg(ipAddress).arg(netmask).arg(gateway);
//    }

//    process.start("sh", QStringList() << "-c" << command);
//    process.waitForFinished();

//    if (process.exitStatus() == QProcess::NormalExit && process.exitCode() == 0) {
//        qDebug() << "Network configured successfully (temporary).";
//        QTimer::singleShot(2000, [this]() {
//          qDebug() << "2 seconds later...";
//          updateNetworkInfo();
//      });
//    } else {
//        qWarning() << "Failed to configure network:" << process.readAllStandardError();
//    }
//}


void NetManager::setIpAddress(const QString& ipAddress, const QString& netmask,const QString& gateway,const QString& mode) {
    if(mode == "dhcp"){
        QProcess dhcpprocess;
        QString dhcpCommand = QString("ifconfig eth0 0.0.0.0 up && dhcpcd --waitip=4 --persistent");
        dhcpprocess.start("sh", QStringList() << "-c" << dhcpCommand);
        dhcpprocess.waitForFinished();
        if (dhcpprocess.exitStatus() == QProcess::NormalExit && dhcpprocess.exitCode() == 0) {
           qDebug() << "set dhcp successfully.";

           QTimer::singleShot(2000, [this]() {
                  qDebug() << "2 seconds later...";
                  updateNetworkInfo();
              });

        } else {
           qWarning() << "Failed to set dhcp:" << dhcpprocess.readAllStandardError();
        }
    }else {
        QString command = QString("ifconfig eth0 %1 netmask %2 up").arg(ipAddress).arg(netmask);
        QProcess process;
        process.start("sh", QStringList() << "-c" << command);
        process.waitForFinished();
        if (process.exitStatus() == QProcess::NormalExit && process.exitCode() == 0) {
            qDebug() << "IP address set successfully.";
        } else {
            qWarning() << "Failed to set IP address:" << process.readAllStandardError();
        }

        QString routeCommand = QString("route add default gw %1 eth0").arg(gateway);
        QProcess routeProcess;
        routeProcess.start("sh", QStringList() << "-c" << routeCommand);
        routeProcess.waitForFinished();

        if (routeProcess.exitStatus() == QProcess::NormalExit && routeProcess.exitCode() == 0) {
           qDebug() << "Default gateway set successfully.";

        } else {
           qWarning() << "Failed to set default gateway:" << routeProcess.readAllStandardError();
        }
        updateNetworkInfo();
    }
}
