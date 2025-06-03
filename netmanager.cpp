// 包含头文件
#include "netmanager.h"      // 网络管理器的声明
#include <QProcess>          // 提供执行外部程序的功能
#include <QTimer>            // 提供定时器功能
#include <QThread>

// 构造函数
// 创建网络管理器并初始化网络信息
// parent: 父对象指针，用于Qt对象树管理
NetManager::NetManager(QObject* parent)
    : QObject(parent) {
    checkNetworkTools();  // 检查可用的网络工具
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
void NetManager::setIpAddress(const QString& ipAddress, const QString& netmask, const QString& gateway, const QString& mode)
{
    qDebug() << "Setting IP configuration:";
    qDebug() << "- IP:" << ipAddress;
    qDebug() << "- Netmask:" << netmask;
    qDebug() << "- Gateway:" << gateway;
    qDebug() << "- Mode:" << mode;
    
    QProcess process;
    
    if (mode == "dhcp") {
        // DHCP mode using udhcpc
        QStringList udhcpcArgs;
        udhcpcArgs << "-i" << "eth0"    
                   << "-n"               
                   << "-q"              
                   << "-A" << "3"        
                   << "-T" << "5"        
                   << "-t" << "10";      

        process.start("udhcpc", udhcpcArgs);
        
        if (!process.waitForFinished(30000)) {  // 30 second timeout
            process.kill();
            qWarning() << "DHCP timeout - no server available";
            emit dhcpConfigurationFailed("No DHCP server found");
            return;
        }

        if (process.exitCode() == 0) {
            // Wait for DHCP to take effect
            QThread::msleep(2000);
            updateNetworkInfo();
        } else {
            emit dhcpConfigurationFailed("No DHCP server found");
        }
    } else {
        // 静态IP模式
        qDebug() << "Configuring static IP mode";
        
        // 1. 设置IP地址和子网掩码
        QStringList ifconfigArgs;
        ifconfigArgs << "eth0" << ipAddress << "netmask" << netmask << "up";
        
        process.start("ifconfig", ifconfigArgs);
        process.waitForFinished(3000);
        
        if (process.exitCode() == 0) {
            qDebug() << "IP address set successfully.";
            
            // 2. 删除现有默认路由（避免"File exists"错误）
            process.start("route", QStringList() << "del" << "default");
            process.waitForFinished(2000);
            qDebug() << "Removed existing default route";
            
            // 3. 添加新的默认网关
            QStringList routeArgs;
            routeArgs << "add" << "default" << "gw" << gateway;
            
            process.start("route", routeArgs);
            process.waitForFinished(3000);
            
            if (process.exitCode() == 0) {
                qDebug() << "Default gateway set successfully.";
            } else {
                QString error = process.readAllStandardError();
                qWarning() << "Failed to set default gateway:" << error;
            }
            
            // 4. 更新网络信息
            QTimer::singleShot(1000, this, [this]() {
                updateNetworkInfo();
            });
            
        } else {
            QString error = process.readAllStandardError();
            qWarning() << "Failed to set IP address:" << error;
        }
    }
}

// 添加专门的DHCP重新获取方法
void NetManager::renewDhcpLease()
{
    QProcess process;
    
    // Kill existing udhcpc process
    process.start("killall", QStringList() << "udhcpc");
    process.waitForFinished(2000);
    
    // Start new DHCP request
    QStringList args;
    args << "-i" << "eth0" << "-n" << "-q" << "-A" << "3";
    
    process.start("udhcpc", args);
    if (process.waitForFinished(20000) && process.exitCode() == 0) {
        QThread::msleep(1000);
        updateNetworkInfo();
    } else {
        qWarning() << "Failed to renew DHCP lease";
    }
}

// 添加网络工具检查方法
void NetManager::checkNetworkTools()
{
    QProcess process;
    
    // Check udhcpc availability
    process.start("which", QStringList() << "udhcpc");
    process.waitForFinished(1000);
    
    if (process.exitCode() == 0) {
        qDebug() << "Network tools: udhcpc available";
    } else {
        qWarning() << "Network tools: udhcpc not found";
    }
}

// 添加网络状态检查方法
void NetManager::checkNetworkStatus()
{
    QProcess process;
    
    qDebug() << "=== Network Status Check ===";
    
    // 检查接口状态
    process.start("ifconfig", QStringList() << "eth0");
    process.waitForFinished(2000);
    qDebug() << "Interface status:" << process.readAllStandardOutput();
    
    // 检查路由表
    process.start("route", QStringList() << "-n");
    process.waitForFinished(2000);
    qDebug() << "Routing table:" << process.readAllStandardOutput();
    
    // 尝试ping网关（如果有的话）
    process.start("sh", QStringList() << "-c" << "ip route | grep default | awk '{print $3}'");
    process.waitForFinished(1000);
    QString gateway = process.readAllStandardOutput().trimmed();
    
    if (!gateway.isEmpty()) {
        qDebug() << "Found gateway:" << gateway;
        process.start("ping", QStringList() << "-c" << "1" << "-W" << "2" << gateway);
        process.waitForFinished(3000);
        if (process.exitCode() == 0) {
            qDebug() << "Gateway is reachable";
        } else {
            qDebug() << "Gateway is not reachable";
        }
    } else {
        qDebug() << "No default gateway found";
    }
    
    qDebug() << "=== Network Status Check Complete ===";
}
