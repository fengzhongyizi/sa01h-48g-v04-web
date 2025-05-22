/**
 * @file tcpserver.h
 * @brief TCP服务器类头文件
 * 
 * 定义了TcpServer类，它提供基本的HTTP服务器功能，
 * 可以处理客户端连接、HTTP请求、静态文件服务等。
 */

#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <QTcpServer>    // 提供TCP服务器基类
#include <QTcpSocket>    // 处理TCP套接字通信
#include <QList>         // 管理客户端连接列表
#include <QObject>       // Qt对象基类
#include <QFile>         // 用于文件操作
#include <QTextStream>   // 文本流处理

/**
 * @class TcpServer
 * @brief TCP服务器类，提供HTTP服务功能
 * 
 * 继承自QTcpServer，实现了简单的HTTP服务器功能，
 * 可以处理客户端连接、响应HTTP请求，以及提供静态文件服务。
 */
class TcpServer : public QTcpServer
{
    Q_OBJECT  // Qt元对象宏，用于信号槽机制

public:
    /**
     * @brief 构造函数
     * @param parent 父对象指针，用于Qt对象树管理
     * 
     * 创建TCP服务器实例，并初始化网站根目录
     */
    explicit TcpServer(QObject *parent = nullptr);
    
    /**
     * @brief 析构函数
     * 
     * 停止服务器并释放资源
     */
    ~TcpServer();

    /**
     * @brief 启动TCP服务器
     * @param port 服务器监听端口号
     * @return 成功返回true，失败返回false
     * 
     * 在指定端口上启动服务器，监听所有IPv4地址
     */
    bool startServer(int port);
    
    /**
     * @brief 停止TCP服务器
     * 
     * 断开所有客户端连接并关闭服务器
     */
    void stopServer();
    
    /**
     * @brief 向所有连接的客户端发送消息
     * @param message 要发送的消息内容
     * 
     * 将消息转换为UTF-8编码后发送给所有活动的客户端
     */
    void sendMessageToAll(const QString &message);

signals:
    /**
     * @brief 新客户端连接信号
     * @param socketDescriptor 新连接的套接字描述符
     * 
     * 当有新客户端连接时触发此信号
     */
    void newClientConnected(qintptr socketDescriptor);

    /**
     * @brief 客户端断开连接信号
     * @param socketDescriptor 断开连接的套接字描述符
     * 
     * 当客户端断开连接时触发此信号
     */
    void clientDisconnected(qintptr socketDescriptor);

    /**
     * @brief 接收到消息信号
     * @param socketDescriptor 发送消息的客户端套接字描述符
     * @param message 接收到的消息内容
     * 
     * 当从客户端接收到消息时触发此信号
     */
    void messageReceived(qintptr socketDescriptor, const QString &message);

protected:
    /**
     * @brief 网站根目录路径
     * 
     * 存储HTTP服务需要的静态文件根目录
     */
    QString m_webRoot;
    
    /**
     * @brief 处理新的客户端连接
     * @param socketDescriptor 新连接的套接字描述符
     * 
     * 重写QTcpServer的虚函数，当新客户端连接时被调用
     */
    void incomingConnection(qintptr socketDescriptor) override;
    
    /**
     * @brief 发送HTTP响应
     * @param client 客户端套接字指针
     * @param path 请求的路径
     * 
     * 根据请求的路径读取对应文件并发送HTTP响应
     */
    void sendHttpResponse(QTcpSocket *client, const QString &path);
    
    /**
     * @brief 获取文件的MIME类型
     * @param filePath 文件路径
     * @return 对应的MIME类型
     * 
     * 根据文件扩展名返回对应的MIME类型
     */
    QByteArray getMimeType(const QString &filePath);

private slots:
    /**
     * @brief 处理客户端数据就绪事件
     * 
     * 当客户端发送数据时被调用，处理HTTP请求
     */
    void onReadyRead();
    
    /**
     * @brief 处理客户端断开连接事件
     * 
     * 当客户端断开连接时被调用，清理资源
     */
    void onDisconnected();

private:
    /**
     * @brief 客户端连接列表
     * 
     * 存储所有已连接的客户端套接字指针
     */
    QList<QTcpSocket*> m_clients;

};

#endif // TCPSERVER_H