#include "tcpserver.h"
#include <QDebug>


TcpServer::TcpServer(QObject *parent) : QTcpServer(parent),
  m_webRoot("/userdata/www")
{

}

TcpServer::~TcpServer()
{
    stopServer();
}

bool TcpServer::startServer(int port)
{
    if (this->isListening()) {
        qWarning() << "Server is already running!";
        return true;
    }

    if (!this->listen(QHostAddress::AnyIPv4, port)) {
        qCritical() << "Failed to start server:" << this->errorString();
        return false;
    }

    qInfo() << "Server started on port" << port;
    return true;
}

void TcpServer::stopServer()
{
    if (!this->isListening()) return;

    for (QTcpSocket *client : qAsConst(m_clients)) {
        client->disconnectFromHost();
        if (client->state() != QAbstractSocket::UnconnectedState) {
            client->waitForDisconnected();
        }
        delete client;
    }
    m_clients.clear();

    this->close();
    qInfo() << "Server stopped.";
}

void TcpServer::sendMessageToAll(const QString &message)
{
    if (m_clients.isEmpty()) {
        qWarning() << "No clients connected!";
        return;
    }

    const QByteArray data = message.toUtf8();
    for (QTcpSocket *client : qAsConst(m_clients)) {
        if (client->state() == QAbstractSocket::ConnectedState) {
            client->write(data);
            client->flush();
        }
    }
}

void TcpServer::incomingConnection(qintptr socketDescriptor)
{
    QTcpSocket *client = new QTcpSocket(this);
    client->setSocketDescriptor(socketDescriptor);

    connect(client, &QTcpSocket::readyRead, this, &TcpServer::onReadyRead);
    connect(client, &QTcpSocket::disconnected, this, &TcpServer::onDisconnected);

    m_clients.append(client);
//    qInfo() << "New client connected:" << socketDescriptor;

    emit newClientConnected(socketDescriptor);
}

void TcpServer::sendHttpResponse(QTcpSocket *client, const QString &path) {
    QString filePath = m_webRoot + path;
    if (filePath.endsWith("/")) filePath += "index.html";

    QFile file(filePath);
    QByteArray response;

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file.readAll();
        file.close();

        response = "HTTP/1.1 200 OK\r\n";
        response += "Content-Type: " + getMimeType(filePath) + "\r\n";
        response += "Connection: keep-alive\r\n\r\n";
        response += fileData;
    } else {
        response = "HTTP/1.1 404 Not Found\r\n"
                   "Content-Type: text/html\r\n\r\n"
                   "<html><body><h1>404 Not Found</h1></body></html>";
    }

    client->write(response);
    client->disconnectFromHost();
}

QByteArray TcpServer::getMimeType(const QString &filePath) {
    static QMap<QString, QByteArray> mimeTypes = {
        {".html", "text/html"},
        {".css",  "text/css"},
        {".js",   "application/javascript"},
        {".png",  "image/png"},
        {".jpg",  "image/jpeg"},
        {".json", "application/json"}
    };

    foreach (const QString &ext, mimeTypes.keys()) {
        if (filePath.endsWith(ext)) return mimeTypes[ext];
    }
    return "application/octet-stream";
}

void TcpServer::onReadyRead() {
    QTcpSocket *client = qobject_cast<QTcpSocket*>(sender());
    if (!client) return;

    QByteArray request = client->readAll();

     if (request.contains("Upgrade: websocket")) {
//         qInfo() << "************websockettype*************";
//         qInfo() << "messsage:" << request;
     }
    if (request.startsWith("GET")) {
        QString path = QString::fromUtf8(request.split(' ')[1]);

        sendHttpResponse(client, path);
    } else {
        client->write("HTTP/1.1 400 Bad Request\r\n\r\n");
//        client->disconnectFromHost();
    }
}

void TcpServer::onDisconnected()
{
    QTcpSocket *client = qobject_cast<QTcpSocket*>(sender());
    if (!client) return;

    const qintptr socketDescriptor = client->socketDescriptor();

    m_clients.removeOne(client);
    client->deleteLater();

//    qInfo() << "Client disconnected:" << socketDescriptor;
    emit clientDisconnected(socketDescriptor);
}
