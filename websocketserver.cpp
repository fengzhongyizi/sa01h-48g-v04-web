#include "websocketserver.h"
#include <QtCore/QDebug>
#include <QTimer>
#include <QThread>
#include <QDir>
QTimer *m_pingTimer;
WebSocketServer::WebSocketServer(QObject *parent) :
    QObject(parent),
    m_pWebSocketServer(nullptr),
    m_tcpClient(new TcpClient(this))
{
   connect(m_tcpClient, &TcpClient::connected, this, &WebSocketServer::tcpConnected);
   connect(m_tcpClient, &TcpClient::disconnected, this, &WebSocketServer::tcpDisconnected);
   connect(m_tcpClient, &TcpClient::errorOccurred, this, &WebSocketServer::tcpErrorOccurred);
   connect(m_tcpClient, &TcpClient::messageReceived, this, &WebSocketServer::tcpMessageReceived);
    m_pingTimer = new QTimer(this);//
        connect(m_pingTimer, &QTimer::timeout, this, [this]() {
            for (QWebSocket *client : m_clients) {
                if (client->isValid()) {
                    client->ping();
//                    qDebug() << "?????????????";
                }else {
//                    qDebug() << "/////////////////";
                }
            }
        });
        m_pingTimer->start(30000);
}

void WebSocketServer::connectToTcpServer(const QString &host, quint16 port)
{
    m_tcpClient->connectToServer(host, port);
}

void WebSocketServer::sendTcpMessage(const QString &message)
{
    m_tcpClient->sendMessage(message);
}

WebSocketServer::~WebSocketServer()
{
    stopServer();
    m_pingTimer->stop();
}

void WebSocketServer::onNewConnection()
{
    // 固定写法，这是 Qt 网络编程中的标准写法，用于拿到连接对象。（从 WebSocket 服务器中取出排队的客户端连接（握手完成后的连接））
    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();

    if (!pSocket) {
        qDebug() << "Invalid new connection";
        return;
    }

    // WebSocket 协议允许路径（如：ws://host:port/ws/upload），这个 path 就是你在浏览器或客户端发起连接时写的路径
    QString path = pSocket->requestUrl().path();  // 固定写法，路径区分用途是标准设计思路（用于服务端路由）。
    qDebug() << "New client connected to path:" << path;

    // 这是一个 WebSocket 路由机制：你根据 path 来做“分流”处理，相当于 RESTful API 中的 URL 路径
    if (path == "/ws/upload") {
        m_uploadClients << pSocket;  // 表示此连接是用于文件上传，放进 m_uploadClients 列表
    } else if (path == "/ws/uart") {
        m_clients << pSocket;  // 表示用于 UART 串口通信，放进 m_clients 列表
    } else {
        qDebug() << "Unknown path, closing connection:" << path;
        pSocket->close();
        return;
    }

    // 绑定消息处理函数，固定写法，处理消息时必须绑定这些信号
    connect(pSocket, &QWebSocket::textMessageReceived,this, &WebSocketServer::processTextMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived,this, &WebSocketServer::processBinaryMessage);
    connect(pSocket, &QWebSocket::disconnected,this, &WebSocketServer::socketDisconnected);

//    m_clients << pSocket;
    emit newClientConnected();
}

void WebSocketServer::processTextMessage(const QString &message)
{

    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());
    QString path = m_uploadClients.contains(pSender) ? "/ws/upload" : "/ws/uart";
    if(path=="/ws/upload"){
        QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
       if (doc.isNull()) {
           qDebug() << "Invalid JSON message";
           emit messageReceived(message,path);
           return;
       }

       QJsonObject json = doc.object();
       int cmd = json["cmd"].toInt();
       QString filename = json["data"].toString();


       if (cmd % 10 == 0) {
           m_terminalManager.executeCommand("mkdir /tmp/update");
           m_terminalManager.executeCommand("rm -rf /tmp/update/*");
           QString filePath = "/tmp/update/update.zip";
           QFile *file = new QFile(filePath);
           if (!file->open(QIODevice::WriteOnly)) {
               qDebug() << "Failed to open file for writing:" << filePath;
               delete file;
               return;
           }
           m_activeFileUploads[pSender] = file;
           qDebug() << "Start receiving file:" << filePath;

       } else if (cmd % 10 == 1) {
           if (m_activeFileUploads.contains(pSender)) {

               m_terminalManager.executeDetachedCommand("/data/upgrademodule");
               QFile *file = m_activeFileUploads.take(pSender);
//               file->close();
               QFileInfo fileInfo(*file);
               qint64 fileSize = fileInfo.size();
               qDebug() << "File upload completed:" << filename << "Size:" << fileSize << "bytes";
               delete file;
               m_terminalManager.executeCommand("unzip -o /tmp/update/update.zip -d /tmp/update");
               m_terminalManager.executeCommand("rm -rf /userdata/spi");
               m_terminalManager.executeCommand("mv /tmp/update/spi /userdata/spi");
               m_terminalManager.executeCommand("chmod +x /userdata/spi");

               QDir updateDir("/tmp/update");
               if (!updateDir.exists()) {
                   qDebug() << "Directory /tmp/update does not exist";
                   return;
               }
               QString filenum = "";
               QFileInfoList entries = updateDir.entryInfoList(QDir::NoDotAndDotDot | QDir::AllEntries);
               for (const QFileInfo &entry : entries) {
                   qDebug() << (entry.isDir() ? "[DIR] " : "[FILE]") << entry.fileName()
                            << "Size:" << entry.size() << "bytes";
                   filenum += entry.fileName()+" ";
               }
               sendMessageToUploadClients("File upload completed\r\n");
               sendMessageToUploadClients("upgradenum:"+filenum.trimmed()+"\r\n");

               if(cmd==31){
                   qDebug() << "start unzip:" << filename;
//                   connectToTcpServer("127.0.0.1", 35353);
//                    m_terminalManager.executeDetachedCommand("/userdata/update.sh");
               }
           }
       }
    }else {
        emit messageReceived(message,path);
    }

}

void WebSocketServer::processBinaryMessage(const QByteArray &message)
{
    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());
//    qDebug() << "Binary Message from" << pSender->peerAddress().toString() << ":" << message.toHex();
    QString path = m_uploadClients.contains(pSender) ? "/ws/upload" : "/ws/uart";

    if(path == "/ws/upload"){
        if (m_activeFileUploads.contains(pSender)) {
            QFile *file = m_activeFileUploads[pSender];
            qDebug() << "Writing to file:" << file->fileName()
                                 << "Size:" << message.size() << "bytes";
            file->write(message);
            file->flush();
        }
    } else {
        emit messageReceived(message, path);
    }

}

void WebSocketServer::socketDisconnected()
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    qDebug() << "Client disconnected:" << pClient->peerAddress().toString();
    qDebug() << "Close code:" << pClient->closeCode();
    qDebug() << "Close reason:" << pClient->closeReason();
    m_clients.removeAll(pClient);
    m_uploadClients.removeAll(pClient);
    pClient->deleteLater();
    emit clientDisconnected();
}

void WebSocketServer::sendMessageToAllClients(const QString &message)
{
    for (QWebSocket *pClient : qAsConst(m_clients)) {
        if (pClient && pClient->isValid()) {
            pClient->sendTextMessage(message);
        }
    }
}

void WebSocketServer::sendMessageToUploadClients(const QString &message) {
    for (QWebSocket *client : qAsConst(m_uploadClients)) {
        if (client && client->isValid()) {
            client->sendTextMessage(message);
        }
    }
}

bool WebSocketServer::startServer()
{
    if (m_running) {
        return true;
    }
    
    m_pWebSocketServer = new QWebSocketServer(
        QStringLiteral("Qt5 WebSocket Server"),   // 实例名字，没太大实际影响。
        QWebSocketServer::NonSecureMode,          // 表示不使用 WSS（加密），如需支持 TLS 则用 SecureMode
        this                                      // this 为父对象，内存管理交由 Qt 完成。
    );
    
    // 固定写法，用 listen() 启动是 Qt 网络服务器共通模式(启动监听，绑定本地 m_port（比如 8081），接受所有网卡的连接)
    if (m_pWebSocketServer->listen(QHostAddress::Any, m_port)) {
        // 固定写法，Qt 中所有“有新连接”的服务端逻辑都必须监听 newConnection 信号。（注册信号槽：当有新连接到来时，触发 onNewConnection()）
        connect(m_pWebSocketServer, &QWebSocketServer::newConnection,
                this, &WebSocketServer::onNewConnection);
        m_running = true;
        emit runningChanged(m_running);
        qDebug() << "WebSocket server listening on port" << m_port;
        return true;
    } else {
        qDebug() << "Failed to start WebSocket server:" << m_pWebSocketServer->errorString();
        delete m_pWebSocketServer;
        m_pWebSocketServer = nullptr;
        return false;
    }
}

void WebSocketServer::stopServer()
{
    if (!m_running) return;

    m_pWebSocketServer->close();
    qDeleteAll(m_clients.begin(), m_clients.end());
    m_clients.clear();
    delete m_pWebSocketServer;
    m_pWebSocketServer = nullptr;

    m_running = false;
    emit runningChanged(m_running);
    emit closed();
    qDebug() << "WebSocket server closed";
}

bool WebSocketServer::isRunning() const
{
    return m_running;
}

int WebSocketServer::port() const
{
    return m_port;
}

void WebSocketServer::setPort(int port)
{
    if (m_port == port)
        return;

    m_port = port;
    emit portChanged();
}
