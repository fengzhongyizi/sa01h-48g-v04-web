/**
 * @file websocketserver.h
 * @brief WebSocket服务器类的头文件
 * 
 * 定义了WebSocketServer类，该类封装了QWebSocketServer功能，
 * 提供了一个易于使用的WebSocket服务器实现，支持客户端连接管理、
 * 消息传输和服务器控制。
 */

#ifndef WEBSOCKETSERVER_H
#define WEBSOCKETSERVER_H

#include <QObject>                      // 提供QObject基类
#include <QtWebSockets/QWebSocketServer> // WebSocket服务器基类
#include <QtWebSockets/QWebSocket>       // WebSocket客户端类

/**
 * @class WebSocketServer
 * @brief WebSocket服务器类
 * 
 * 提供WebSocket服务器功能，可从QML和C++中使用，
 * 支持启动/停止服务器、发送广播消息和客户端连接管理。
 */
class WebSocketServer : public QObject
{
    Q_OBJECT  // 启用Qt元对象系统

    /**
     * @property isRunning
     * @brief 服务器运行状态属性
     * 
     * 表示WebSocket服务器是否正在运行
     * @accessors isRunning(), runningChanged(bool)
     */
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY runningChanged)

    /**
     * @property port
     * @brief 服务器端口属性
     * 
     * 设置和获取WebSocket服务器监听的端口号
     * @accessors port(), setPort(int), portChanged()
     */
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
public:
    /**
     * @brief 构造函数
     * @param parent 父对象指针
     * 
     * 创建一个WebSocketServer实例
     */
    explicit WebSocketServer(QObject *parent = nullptr);
    
    /**
     * @brief 析构函数
     * 
     * 释放资源并停止服务器
     */
    virtual ~WebSocketServer();

    /**
     * @brief 启动WebSocket服务器
     * @return 成功返回true，失败返回false
     * 
     * 在指定端口上启动服务器，开始接受WebSocket连接
     * 可从QML中调用
     */
    Q_INVOKABLE bool startServer();
    
    /**
     * @brief 停止WebSocket服务器
     * 
     * 关闭所有连接并停止服务器
     * 可从QML中调用
     */
    Q_INVOKABLE void stopServer();

    /**
     * @brief 获取服务器运行状态
     * @return 服务器是否正在运行
     * 
     * 用于isRunning属性的读取器
     */
    bool isRunning() const;
    
    /**
     * @brief 获取当前端口号
     * @return 服务器使用的端口号
     * 
     * 用于port属性的读取器
     */
    int port() const;
    
    /**
     * @brief 设置服务器端口
     * @param port 要使用的端口号
     * 
     * 设置WebSocket服务器要监听的端口
     * 用于port属性的写入器
     */
    void setPort(int port);

signals:
    /**
     * @brief 运行状态变更信号
     * @param isRunning 当前运行状态
     * 
     * 当服务器开始运行或停止时发出
     */
    void runningChanged(bool isRunning);
    
    /**
     * @brief 端口变更信号
     * 
     * 当服务器端口被修改时发出
     */
    void portChanged();
    
    /**
     * @brief 服务器关闭信号
     * 
     * 当服务器完全关闭时发出
     */
    void closed();
    
    /**
     * @brief 新客户端连接信号
     * 
     * 当有新客户端连接到服务器时发出
     */
    void newClientConnected();
    
    /**
     * @brief 客户端断开连接信号
     * 
     * 当客户端断开连接时发出
     */
    void clientDisconnected();
    
    /**
     * @brief 收到消息信号
     * @param message 收到的文本消息
     * 
     * 当从任何客户端接收到WebSocket消息时发出
     */
    void messageReceived(const QString &message);

public slots:
    /**
     * @brief 向所有客户端发送消息
     * @param message 要发送的文本消息
     * 
     * 将指定消息广播给所有已连接的客户端
     */
    void sendMessageToAllClients(const QString &message);

private slots:
    /**
     * @brief 处理新连接
     * 
     * 当有新的WebSocket客户端连接时被调用
     */
    void onNewConnection();
    
    /**
     * @brief 处理文本消息
     * @param message 接收到的文本消息
     * 
     * 处理从客户端接收到的WebSocket文本消息
     */
    void processTextMessage(const QString &message);
    
    /**
     * @brief 处理二进制消息
     * @param message 接收到的二进制消息
     * 
     * 处理从客户端接收到的WebSocket二进制消息
     */
    void processBinaryMessage(const QByteArray &message);
    
    /**
     * @brief 处理客户端断开连接
     * 
     * 当WebSocket客户端断开连接时清理资源
     */
    void socketDisconnected();

private:
    QWebSocketServer *m_pWebSocketServer;  ///< WebSocket服务器实例
    QList<QWebSocket *> m_clients;         ///< 已连接客户端列表
    int m_port;                            ///< 服务器端口
    bool m_running;                        ///< 服务器运行状态
};

#endif // WEBSOCKETSERVER_H