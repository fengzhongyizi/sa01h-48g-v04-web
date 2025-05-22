// 包含头文件
#include "netmanager.h"      // 网络管理器的声明
#include <QProcess>          // 提供执行外部程序的功能
#include <QTimer>            // 提供定时器功能

// 构造函数
// 创建网络管理器并初始化网络信息
// parent: 父对象指针，用于Qt对象树管理
NetManager::NetManager(QObject* parent)
    : QObject(parent) {
//    setIpAddress("192.168.1.239", "255.255.255.0","192.168.1.1","static"); // 已注释的硬编码IP设置
    updateNetworkInfo();  // 初始化时更新网络信息
}

// 获取IP地址
// 返回值: 当前设备的IP地址
QString NetManager::ipAddress() const {
    return m_ipAddress;
}

// 获取子网掩码
// 返回值: 当前网络的子网掩码
QString NetManager::netmask() const {
    return m_netmask;
}

// 获取MAC地址
// 返回值: 设备eth0接口的MAC地址
QString NetManager::macAddress() const {
    return m_macAddress;
}

// 获取路由器IP地址
// 返回值: 默认网关IP地址
QString NetManager::routerIpAddress() const {
    return m_routerIpAddress;
}

// 获取TCP端口列表
// 返回值: 当前监听的TCP端口
QString NetManager::tcpPorts() const {
    return m_tcpPorts;
}

// 更新网络信息
// 从系统中获取最新的网络配置信息并更新内部状态
void NetManager::updateNetworkInfo() {
    // 遍历所有网络接口
    foreach (const QNetworkInterface& networkInterface, QNetworkInterface::allInterfaces()) {
        // 只处理eth0接口
        if (networkInterface.name() == "eth0") {
            // 获取MAC地址
            m_macAddress = networkInterface.hardwareAddress();
            emit macAddressChanged(m_macAddress);  // 发送MAC地址变化信号

            // 遍历接口上的所有地址
            foreach (const QNetworkAddressEntry& addressEntry, networkInterface.addressEntries()) {
                // 只处理IPv4地址
                if (addressEntry.ip().protocol() == QAbstractSocket::IPv4Protocol) {
                    m_ipAddress = addressEntry.ip().toString();     // 获取IP地址
                    m_netmask = addressEntry.netmask().toString();  // 获取子网掩码
                    emit ipAddressChanged(m_ipAddress);     // 发送IP地址变化信号
                    emit netmaskChanged(m_netmask);         // 发送子网掩码变化信号
                    qDebug() << "m_ipAddress="<<m_ipAddress;
                    qDebug() << "m_netmask="<<m_netmask;
                }
            }
        }
    }

    // 使用shell命令获取默认网关
    QProcess process;
    process.start("sh", QStringList() << "-c" << "ip route | grep default");
    process.waitForFinished();
    QString output = process.readAllStandardOutput();

    // 解析命令输出以获取默认网关
    QStringList outputList = output.split(" ");
    if (outputList.size()>=2) {
        m_routerIpAddress = outputList[2];  // 默认网关通常是第三个字段
        qDebug() << "m_routerIpAddress="<<m_routerIpAddress;
    } else {
//        m_routerIpAddress = "0.0.0.0";  // 已注释的默认值
    }
    emit routerIpAddressChanged(m_routerIpAddress);  // 发送路由器IP地址变化信号

    // 获取当前监听的TCP端口
    process.start("sh", QStringList() << "-c" << "netstat -tln | grep LISTEN");
    process.waitForFinished();
    output = process.readAllStandardOutput();
    // QStringList outputList1 = output.split(" ");
    //m_tcpPorts = outputList1[15].split(":")[1];  // 已注释的旧代码

    // 解析netstat输出以获取TCP端口
    QStringList outputList1 = output.split(" ");
    QString token = outputList1.value(15);       // 获取包含端口信息的字段
    QString port  = token.split(":").value(1);   // 提取端口号
    m_tcpPorts = port;

    emit tcpPortsChanged(m_tcpPorts);  // 发送TCP端口变化信号
}

// 以下是已注释掉的两个setIpAddress函数实现版本
// 这些版本使用不同的方法配置网络，但已被弃用

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


// 设置IP地址和网络配置
// ipAddress: 要设置的IP地址
// netmask: 要设置的子网掩码
// gateway: 要设置的默认网关
// mode: 网络模式，"dhcp"为动态获取，其他值为静态IP
void NetManager::setIpAddress(const QString& ipAddress, const QString& netmask,const QString& gateway,const QString& mode) {
    if(mode == "dhcp"){
        // DHCP模式配置
        QProcess dhcpprocess;
        // 先重置IP，然后使用dhcpcd客户端获取IP
        QString dhcpCommand = QString("ifconfig eth0 0.0.0.0 up && dhcpcd --waitip=4 --persistent");
        dhcpprocess.start("sh", QStringList() << "-c" << dhcpCommand);
        dhcpprocess.waitForFinished();
        if (dhcpprocess.exitStatus() == QProcess::NormalExit && dhcpprocess.exitCode() == 0) {
           qDebug() << "set dhcp successfully.";

           // 延迟2秒后更新网络信息，确保DHCP有足够时间获取地址
           QTimer::singleShot(2000, [this]() {
                  qDebug() << "2 seconds later...";
                  updateNetworkInfo();
              });

        } else {
           qWarning() << "Failed to set dhcp:" << dhcpprocess.readAllStandardError();
        }
    }else {
        // 静态IP模式配置
        // 步骤1: 设置IP地址和子网掩码
        QString command = QString("ifconfig eth0 %1 netmask %2 up").arg(ipAddress).arg(netmask);
        QProcess process;
        process.start("sh", QStringList() << "-c" << command);
        process.waitForFinished();
        if (process.exitStatus() == QProcess::NormalExit && process.exitCode() == 0) {
            qDebug() << "IP address set successfully.";
        } else {
            qWarning() << "Failed to set IP address:" << process.readAllStandardError();
        }

        // 步骤2: 设置默认网关
        QString routeCommand = QString("route add default gw %1 eth0").arg(gateway);
        QProcess routeProcess;
        routeProcess.start("sh", QStringList() << "-c" << routeCommand);
        routeProcess.waitForFinished();

        if (routeProcess.exitStatus() == QProcess::NormalExit && routeProcess.exitCode() == 0) {
           qDebug() << "Default gateway set successfully.";

        } else {
           qWarning() << "Failed to set default gateway:" << routeProcess.readAllStandardError();
        }
        // 立即更新网络信息，不需要延迟
        updateNetworkInfo();
    }
}