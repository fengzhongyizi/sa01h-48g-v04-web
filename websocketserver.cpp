/**
 * @file websocketserver.cpp
 * @brief WebSocket服务器类实现
 * 
 * 提供WebSocket服务器功能，包括客户端连接管理、消息收发和服务器控制
 */

#include "websocketserver.h"
#include <QtCore/QDebug>         // 用于调试输出
#include <QTimer>                 // 用于定时任务

// 全局定时器，用于定期发送ping消息保持连接活跃
QTimer *m_pingTimer;

/**
 * @brief 构造函数
 * @param parent 父对象指针
 * 
 * 初始化WebSocket服务器并设置30秒间隔的ping定时器，保持连接活跃
 */
WebSocketServer::WebSocketServer(QObject *parent) :
    QObject(parent),
    m_pWebSocketServer(nullptr)
{
    // 创建ping定时器并连接其timeout信号
    m_pingTimer = new QTimer(this);
    connect(m_pingTimer, &QTimer::timeout, this, [this]() {
        // 定时向所有连接的客户端发送ping消息
        for (QWebSocket *client : m_clients) {
            if (client->isValid()) {
                client->ping();
//              qDebug() << "?????????????";  // 注释掉的调试信息
            } else {
//              qDebug() << "/////////////////";  // 注释掉的调试信息
            }
        }
    });
    m_pingTimer->start(30000);  // 设置30秒的ping间隔
}

/**
 * @brief 析构函数
 * 
 * 停止服务器并清理资源
 */
WebSocketServer::~WebSocketServer()
{
    stopServer();          // 停止WebSocket服务器
    m_pingTimer->stop();   // 停止ping定时器
}

/**
 * @brief 处理新客户端连接
 * 
 * 当有新客户端连接时，设置信号连接并将客户端添加到管理列表
 */
void WebSocketServer::onNewConnection()
{
    // 获取下一个待处理的连接
    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();

    // 验证连接有效性
    if (!pSocket) {
        qDebug() << "Invalid new connection";
        return;
    }

    qDebug() << "New client connected:" << pSocket->peerAddress().toString();

    // 连接WebSocket信号到对应的处理槽函数
    connect(pSocket, &QWebSocket::textMessageReceived, this, &WebSocketServer::processTextMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived, this, &WebSocketServer::processBinaryMessage);
    connect(pSocket, &QWebSocket::disconnected, this, &WebSocketServer::socketDisconnected);

    // 添加到客户端列表
    m_clients << pSocket;
    // 发出新客户端连接信号
    emit newClientConnected();
}

/**
 * @brief 处理接收到的文本消息
 * @param message 接收到的文本消息
 * 
 * 接收客户端发来的文本消息并转发到应用程序
 */
void WebSocketServer::processTextMessage(const QString &message)
{
    // 注释掉的代码包含更详细的消息处理和回显逻辑
//    qDebug() << "processTextMessage called! Message:" << message;
//    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());
//    qDebug() << "Message from" << pSender->peerAddress().toString() << ":" << message;
//    QStringList messages = message.split("\r\n", Qt::SkipEmptyParts);

//    foreach (const QString &msg, messages) {
//        if (!msg.trimmed().isEmpty()) {
//            qDebug() << "Processing sub-message:" << msg;
//            emit messageReceived(msg);
//        }
//    }

    // 直接发出消息接收信号，将消息转发到关联的槽函数
    emit messageReceived(message);
    
//    if (pSender) {
//        pSender->sendTextMessage(QString("Server received: %1").arg(message));
//    }
}

/**
 * @brief 处理接收到的二进制消息
 * @param message 接收到的二进制消息
 * 
 * 接收并记录客户端发送的二进制消息
 */
void WebSocketServer::processBinaryMessage(const QByteArray &message)
{
    // 获取发送者WebSocket对象
    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());
    // 记录接收到的二进制消息（十六进制格式）
    qDebug() << "Binary Message from" << pSender->peerAddress().toString() << ":" << message.toHex();

    // 注释掉的回复消息功能
//    if (pSender) {
//        pSender->sendBinaryMessage(message);
//    }
}

/**
 * @brief 处理客户端断开连接
 * 
 * 当客户端断开连接时，清理资源并从列表中移除
 */
void WebSocketServer::socketDisconnected()
{
    // 获取断开连接的客户端
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
//    if (pClient) {  // 注释掉的条件检查
        qDebug() << "Client disconnected:" << pClient->peerAddress().toString();

        // 记录关闭代码和原因（用于调试）
        qDebug() << "Close code:" << pClient->closeCode();
        qDebug() << "Close reason:" << pClient->closeReason();
        
        // 从客户端列表中移除
        m_clients.removeAll(pClient);
        // 安排客户端对象稍后删除
        pClient->deleteLater();
        // 发出客户端断开连接信号
        emit clientDisconnected();
//    }
}

/**
 * @brief 发送消息给所有连接的客户端
 * @param message 要发送的文本消息
 * 
 * 将指定消息广播到所有有效的WebSocket客户端
 */
void WebSocketServer::sendMessageToAllClients(const QString &message)
{
    // 遍历所有客户端
    for (QWebSocket *pClient : qAsConst(m_clients)) {
        // 检查客户端是否有效
        if (pClient && pClient->isValid()) {
            // 发送文本消息
            pClient->sendTextMessage(message);
        }
    }
}

/**
 * 注释掉的关闭服务器方法
 * 被更完善的stopServer()替代
 */
//void WebSocketServer::closeServer()
//{
//    m_pWebSocketServer->close();
//    qDeleteAll(m_clients.begin(), m_clients.end());
//    m_clients.clear();
//    qDebug() << "WebSocket server closed";
//    emit closed();
//}

/**
 * @brief 启动WebSocket服务器
 * @return 成功返回true，失败返回false
 * 
 * 在指定端口上启动WebSocket服务器，开始监听连接
 */
bool WebSocketServer::startServer()
{
    // 如果服务器已在运行，直接返回成功
    if (m_running) {
        return true;
    }

    // 创建WebSocket服务器实例
    m_pWebSocketServer = new QWebSocketServer(
        QStringLiteral("Qt5 WebSocket Server"),  // 服务器名称
        QWebSocketServer::NonSecureMode,         // 非安全模式(ws://)
        this
    );

    // 尝试在指定端口上启动监听
    if (m_pWebSocketServer->listen(QHostAddress::Any, m_port)) {
        // 连接新连接信号
        connect(m_pWebSocketServer, &QWebSocketServer::newConnection,
                this, &WebSocketServer::onNewConnection);
        // 更新运行状态并发出状态变更信号
        m_running = true;
        emit runningChanged(m_running);
        qDebug() << "WebSocket server listening on port" << m_port;
        return true;
    } else {
        // 启动失败，输出错误信息
        qDebug() << "Failed to start WebSocket server:" << m_pWebSocketServer->errorString();
        delete m_pWebSocketServer;
        m_pWebSocketServer = nullptr;
        return false;
    }
}

/**
 * @brief 停止WebSocket服务器
 * 
 * 关闭所有连接，清理资源并停止服务器
 */
void WebSocketServer::stopServer()
{
    // 如果服务器未运行，直接返回
    if (!m_running) return;

    // 关闭服务器
    m_pWebSocketServer->close();
    // 删除所有客户端连接
    qDeleteAll(m_clients.begin(), m_clients.end());
    // 清空客户端列表
    m_clients.clear();
    // 删除服务器对象
    delete m_pWebSocketServer;
    m_pWebSocketServer = nullptr;

    // 更新运行状态
    m_running = false;
    // 发出状态变更信号
    emit runningChanged(m_running);
    // 发出关闭信号
    emit closed();
    qDebug() << "WebSocket server closed";
}

/**
 * @brief 获取服务器运行状态
 * @return 服务器是否正在运行
 */
bool WebSocketServer::isRunning() const
{
    return m_running;
}

/**
 * @brief 获取服务器端口
 * @return 当前设置的端口号
 */
int WebSocketServer::port() const
{
    return m_port;
}

/**
 * @brief 设置服务器端口
 * @param port 要设置的端口号
 * 
 * 更新服务器使用的端口号（仅在服务器未运行时有效）
 */
void WebSocketServer::setPort(int port)
{
    // 如果端口未变，直接返回
    if (m_port == port)
        return;

    // 更新端口并发出变更信号
    m_port = port;
    emit portChanged();
}