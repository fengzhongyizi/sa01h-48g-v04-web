// tcpserver.cpp
// TCP服务器实现文件 - 提供HTTP服务功能，处理客户端连接及数据传输

#include "tcpserver.h"
#include <QDebug>

/**
 * @brief 构造函数 - 创建TCP服务器实例
 * @param parent 父对象指针，用于Qt对象树管理
 * 初始化网站根目录为/userdata/www
 */
TcpServer::TcpServer(QObject *parent) : QTcpServer(parent),
  m_webRoot("/userdata/www")
{

}

/**
 * @brief 析构函数 - 清理服务器资源
 * 停止服务器并释放资源
 */
TcpServer::~TcpServer()
{
    stopServer();
}

/**
 * @brief 启动TCP服务器
 * @param port 服务器监听端口号
 * @return 成功返回true，失败返回false
 * 在指定端口上启动服务器，监听任何IPv4地址
 */
bool TcpServer::startServer(int port)
{
    // 检查服务器是否已经在运行
    if (this->isListening()) {
        qWarning() << "Server is already running!";
        return true;
    }

    // 尝试在指定端口上启动服务器
    if (!this->listen(QHostAddress::AnyIPv4, port)) {
        qCritical() << "Failed to start server:" << this->errorString();
        return false;
    }

    qInfo() << "Server started on port" << port;
    return true;
}

/**
 * @brief 停止TCP服务器
 * 断开所有客户端连接并关闭服务器
 */
void TcpServer::stopServer()
{
    // 如果服务器未运行，直接返回
    if (!this->isListening()) return;

    // 断开并删除所有客户端连接
    for (QTcpSocket *client : qAsConst(m_clients)) {
        client->disconnectFromHost();
        if (client->state() != QAbstractSocket::UnconnectedState) {
            client->waitForDisconnected();
        }
        delete client;
    }
    m_clients.clear();

    // 关闭服务器
    this->close();
    qInfo() << "Server stopped.";
}

/**
 * @brief 向所有连接的客户端发送消息
 * @param message 要发送的消息内容
 * 将消息转换为UTF-8编码后发送给所有活动的客户端
 */
void TcpServer::sendMessageToAll(const QString &message)
{
    // 检查是否有连接的客户端
    if (m_clients.isEmpty()) {
        qWarning() << "No clients connected!";
        return;
    }

    // 将消息转换为UTF-8编码
    const QByteArray data = message.toUtf8();
    // 遍历所有客户端并发送消息
    for (QTcpSocket *client : qAsConst(m_clients)) {
        if (client->state() == QAbstractSocket::ConnectedState) {
            client->write(data);
            client->flush();
        }
    }
}

/**
 * @brief 处理新的客户端连接
 * @param socketDescriptor 新连接的套接字描述符
 * 重写QTcpServer的虚函数，当新客户端连接时被调用
 */
void TcpServer::incomingConnection(qintptr socketDescriptor)
{
    // 创建新的客户端套接字对象
    QTcpSocket *client = new QTcpSocket(this);
    client->setSocketDescriptor(socketDescriptor);

    // 连接信号和槽
    connect(client, &QTcpSocket::readyRead, this, &TcpServer::onReadyRead);
    connect(client, &QTcpSocket::disconnected, this, &TcpServer::onDisconnected);

    // 添加到客户端列表
    m_clients.append(client);
//    qInfo() << "New client connected:" << socketDescriptor;

    // 发送新客户端连接信号
    emit newClientConnected(socketDescriptor);
}

/**
 * @brief 发送HTTP响应
 * @param client 客户端套接字指针
 * @param path 请求的路径
 * 根据请求的路径读取对应文件并发送HTTP响应
 */
void TcpServer::sendHttpResponse(QTcpSocket *client, const QString &path) {
    // 构建完整的文件路径
    QString filePath = m_webRoot + path;
    if (filePath.endsWith("/")) filePath += "index.html";  // 处理目录请求，默认为index.html

    QFile file(filePath);
    QByteArray response;

    // 检查文件是否存在并可读
    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        // 读取文件内容
        QByteArray fileData = file.readAll();
        file.close();

        // 构建成功响应
        response = "HTTP/1.1 200 OK\r\n";
        response += "Content-Type: " + getMimeType(filePath) + "\r\n";
        response += "Connection: keep-alive\r\n\r\n";
        response += fileData;
    } else {
        // 构建404错误响应
        response = "HTTP/1.1 404 Not Found\r\n"
                   "Content-Type: text/html\r\n\r\n"
                   "<html><body><h1>404 Not Found</h1></body></html>";
    }

    // 发送响应并断开连接
    client->write(response);
    client->disconnectFromHost();
}

/**
 * @brief 获取文件的MIME类型
 * @param filePath 文件路径
 * @return 对应的MIME类型
 * 根据文件扩展名返回对应的MIME类型
 */
QByteArray TcpServer::getMimeType(const QString &filePath) {
    // 定义静态MIME类型映射表
    static QMap<QString, QByteArray> mimeTypes = {
        {".html", "text/html"},
        {".css",  "text/css"},
        {".js",   "application/javascript"},
        {".png",  "image/png"},
        {".jpg",  "image/jpeg"},
        {".json", "application/json"}
    };

    // 根据文件扩展名查找MIME类型
    foreach (const QString &ext, mimeTypes.keys()) {
        if (filePath.endsWith(ext)) return mimeTypes[ext];
    }
    // 默认MIME类型
    return "application/octet-stream";
}

/**
 * @brief 处理客户端数据就绪事件
 * 当客户端发送数据时被调用，处理HTTP请求
 */
void TcpServer::onReadyRead() {
    // 获取发送数据的客户端
    QTcpSocket *client = qobject_cast<QTcpSocket*>(sender());
    if (!client) return;

    // 读取请求数据
    QByteArray request = client->readAll();

    // 检测WebSocket升级请求（当前仅做标记，未实际处理）
    if (request.contains("Upgrade: websocket")) {
//         qInfo() << "************websockettype*************";
//         qInfo() << "messsage:" << request;
    }
    
    // 处理HTTP GET请求
    if (request.startsWith("GET")) {
        // 提取请求路径
        QString path = QString::fromUtf8(request.split(' ')[1]);

        // 发送HTTP响应
        sendHttpResponse(client, path);
    } else {
        // 发送400错误响应
        client->write("HTTP/1.1 400 Bad Request\r\n\r\n");
//        client->disconnectFromHost();
    }
}

/**
 * @brief 处理客户端断开连接事件
 * 当客户端断开连接时被调用，清理资源
 */
void TcpServer::onDisconnected()
{
    // 获取断开连接的客户端
    QTcpSocket *client = qobject_cast<QTcpSocket*>(sender());
    if (!client) return;

    // 获取套接字描述符
    const qintptr socketDescriptor = client->socketDescriptor();

    // 从客户端列表中移除并删除客户端对象
    m_clients.removeOne(client);
    client->deleteLater();

//    qInfo() << "Client disconnected:" << socketDescriptor;
    // 发送客户端断开连接信号
    emit clientDisconnected(socketDescriptor);
}