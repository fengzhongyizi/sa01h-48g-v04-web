#include "websocketserver.h"
#include <QtCore/QDebug>
#include <QTimer>
//WebSocketServer::WebSocketServer( QObject *parent) :
//    QObject(parent),
//    m_pWebSocketServer(new QWebSocketServer(QStringLiteral("Qt5 WebSocket Server"),
//                                          QWebSocketServer::NonSecureMode,
//                                          this))
//{
//    if (m_pWebSocketServer->listen(QHostAddress::Any, 80)) {
//        qDebug() << "WebSocket server listening on port:" << 80;
//        connect(m_pWebSocketServer, &QWebSocketServer::newConnection,
//                this, &WebSocketServer::onNewConnection);
//    } else {
//        qDebug() << "Failed to start WebSocket server:" << m_pWebSocketServer->errorString();
//    }
//}
QTimer *m_pingTimer;
WebSocketServer::WebSocketServer(QObject *parent) :
    QObject(parent),
    m_pWebSocketServer(nullptr),
    m_port(0),
    m_running(false)
{
    m_pingTimer = new QTimer(this);
        connect(m_pingTimer, &QTimer::timeout, this, [this]() {
            for (QWebSocket *client : m_clients) {
                if (client->isValid()) {
                    client->ping();
                    qDebug() << "?????????????";
                }
            }
        });
        m_pingTimer->start(10000);
}

WebSocketServer::~WebSocketServer()
{
    stopServer();
    m_pingTimer->stop();
}

void WebSocketServer::onNewConnection()
{
    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();

    if (!pSocket) {
        qDebug() << "Invalid new connection";
        return;
    }

    qDebug() << "New client connected:" << pSocket->peerAddress().toString();

    connect(pSocket, &QWebSocket::textMessageReceived,this, &WebSocketServer::processTextMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived,this, &WebSocketServer::processBinaryMessage);
    connect(pSocket, &QWebSocket::disconnected,this, &WebSocketServer::socketDisconnected);

    m_clients << pSocket;
    emit newClientConnected();
}

void WebSocketServer::processTextMessage(const QString &message)
{
    qDebug() << "[DEBUG] processTextMessage called! Message:" << message;
    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());
    qDebug() << "Message from" << pSender->peerAddress().toString() << ":" << message;

    emit messageReceived(message);

    if (pSender) {
        pSender->sendTextMessage(QString("Server received: %1").arg(message));
    }
}

void WebSocketServer::processBinaryMessage(const QByteArray &message)
{
    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());
    qDebug() << "Binary Message from" << pSender->peerAddress().toString() << ":" << message.toHex();

    if (pSender) {
        pSender->sendBinaryMessage(message);
    }
}

void WebSocketServer::socketDisconnected()
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
//    if (pClient) {
        qDebug() << "Client disconnected:" << pClient->peerAddress().toString();

       qDebug() << "Close code:" << pClient->closeCode(); // 打印关闭代码
       qDebug() << "Close reason:" << pClient->closeReason(); // 打印关闭原因
        m_clients.removeAll(pClient);
        pClient->deleteLater();
        emit clientDisconnected();
//    }
}

void WebSocketServer::sendMessageToAllClients(const QString &message)
{
    for (QWebSocket *pClient : qAsConst(m_clients)) {
        if (pClient && pClient->isValid()) {
            pClient->sendTextMessage(message);
        }
    }
}

//void WebSocketServer::closeServer()
//{
//    m_pWebSocketServer->close();
//    qDeleteAll(m_clients.begin(), m_clients.end());
//    m_clients.clear();
//    qDebug() << "WebSocket server closed";
//    emit closed();
//}


bool WebSocketServer::startServer()
{
    if (m_running) {
        return true;
    }

    m_pWebSocketServer = new QWebSocketServer(
        QStringLiteral("Qt5 WebSocket Server"),
        QWebSocketServer::NonSecureMode,
        this
    );

    if (m_pWebSocketServer->listen(QHostAddress::Any, m_port)) {
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
