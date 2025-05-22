// 防止头文件重复包含的宏定义保护
#ifndef NETMANAGER_H
#define NETMANAGER_H

// 引入必要的Qt头文件
#include <QObject>                  // 提供Qt对象系统的基础类
#include <QNetworkInterface>        // 提供网络接口信息访问功能
#include <QNetworkAddressEntry>     // 提供网络地址条目功能，用于访问IP地址和子网掩码等

// NetManager类定义
// 用于管理设备的网络配置，包括查询和设置IP地址、子网掩码等网络参数
class NetManager : public QObject {
    Q_OBJECT    // Qt元对象宏，启用信号槽机制

    // Qt属性定义，使这些网络属性在QML中可以直接访问
    // 所有属性只读(READ)，且当值变化时会发出对应的NOTIFY信号
    Q_PROPERTY(QString ipAddress READ ipAddress NOTIFY ipAddressChanged)            // IP地址属性
    Q_PROPERTY(QString netmask READ netmask NOTIFY netmaskChanged)                  // 子网掩码属性
    Q_PROPERTY(QString macAddress READ macAddress NOTIFY macAddressChanged)         // MAC地址属性
    Q_PROPERTY(QString routerIpAddress READ routerIpAddress NOTIFY routerIpAddressChanged) // 路由器/网关地址属性
    Q_PROPERTY(QString tcpPorts READ tcpPorts NOTIFY tcpPortsChanged)               // 监听的TCP端口属性

public:
    // 构造函数
    // parent: 父对象指针，用于Qt对象树管理
    explicit NetManager(QObject* parent = nullptr);

    // 获取当前IP地址
    // 返回值: 设备的IPv4地址
    QString ipAddress() const;
    
    // 获取当前子网掩码
    // 返回值: 网络的子网掩码
    QString netmask() const;
    
    // 获取网络接口的MAC地址
    // 返回值: 以冒号分隔的MAC地址字符串
    QString macAddress() const;
    
    // 获取默认路由器/网关的IP地址
    // 返回值: 默认网关IP地址
    QString routerIpAddress() const;
    
    // 获取当前监听的TCP端口
    // 返回值: 监听端口列表
    QString tcpPorts() const;

    // 设置网络配置
    // 可以从QML中直接调用(Q_INVOKABLE)
    // ipAddress: 要设置的IP地址
    // netmask: 要设置的子网掩码
    // gateway: 要设置的默认网关
    // mode: 网络配置模式，"dhcp"为动态获取IP，其他值为静态IP
    Q_INVOKABLE void setIpAddress(const QString& ipAddress, const QString& netmask,const QString& gateway,const QString& mode);

signals:
    // 当IP地址变化时发出的信号
    // data: 新的IP地址
    void ipAddressChanged(const QString &data);
    
    // 当子网掩码变化时发出的信号
    // data: 新的子网掩码
    void netmaskChanged(const QString &data);
    
    // 当MAC地址变化时发出的信号
    // data: 新的MAC地址
    void macAddressChanged(const QString &data);
    
    // 当路由器IP地址变化时发出的信号
    // data: 新的路由器IP地址
    void routerIpAddressChanged(const QString &data);
    
    // 当TCP端口列表变化时发出的信号
    // data: 新的TCP端口列表
    void tcpPortsChanged(const QString &data);

public slots:
    // 更新网络信息的槽函数
    // 从系统获取最新的网络配置信息并更新内部状态
    void updateNetworkInfo();

private:
    // 存储当前设备的IP地址
    QString m_ipAddress;
    
    // 存储当前网络的子网掩码
    QString m_netmask;
    
    // 存储网络接口的MAC地址
    QString m_macAddress;
    
    // 存储默认路由器/网关的IP地址
    QString m_routerIpAddress;
    
    // 存储当前监听的TCP端口列表
    QString m_tcpPorts;
};

#endif // NETMANAGER_H