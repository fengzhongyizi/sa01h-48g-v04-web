#include "tcpclient.h"
#include <QDebug>
#include <QTimer>

TcpClient::TcpClient(QObject *parent) : QObject(parent)
{
    m_socket = new QTcpSocket(this);

    connect(m_socket, &QTcpSocket::connected, this, &TcpClient::onConnected);
    connect(m_socket, &QTcpSocket::disconnected, this, &TcpClient::onDisconnected);
//    connect(m_socket, QOverload<QAbstractSocket::SocketError>::of(&QTcpSocket::errorOccurred),
//            this, &TcpClient::onErrorOccurred);
    connect(m_socket, &QTcpSocket::readyRead, this, &TcpClient::onReadyRead);
}

void TcpClient::connectToServer(const QString &host, quint16 port)
{
    m_socket->connectToHost(host, port);
}

//void TcpClient::sendInitialMessages()
//{
//    sendMessage("\r\nGET FIRMWARELIST\r\n");
//    sendMessage("\r\nUPGRADEMODE||5\r\n");
//    sendMessage("\r\nSETCOMPORT||ttyS5\r\n");
//    sendMessage("\r\nUPGRADE||Main,0,0\r\n");
//}

void TcpClient::sendMessage(const QString &message)
{
    qDebug() << "Send to tcpserver...";
    if (m_socket->state() == QAbstractSocket::ConnectedState) {
        m_socket->write(message.toUtf8());
        qDebug() << "Send to tcpserver"<<message.toUtf8();
    }
}

void TcpClient::onConnected()
{
    qDebug() << "Connected to server";
//    sendInitialMessages();
//    sendMessage("\r\nGET FIRMWARELIST\r\n");
//    sendMessage("\r\nUPGRADEMODE||5\r\n");
//    sendMessage("\r\nSETCOMPORT||ttyS5\r\n");
//    sendMessage("\r\nUPGRADE||Main,0,0\r\n");
    emit connected();
}

void TcpClient::onDisconnected()
{
    qDebug() << "Disconnected from server";
    emit disconnected();
}

void TcpClient::onErrorOccurred(QAbstractSocket::SocketError error)
{
    Q_UNUSED(error)
    qDebug() << "ERROR:"<<m_socket->errorString();
    emit errorOccurred(m_socket->errorString());
}

void TcpClient::onReadyRead()
{
    QByteArray data = m_socket->readAll();
    QString message = QString::fromUtf8(data);
    qDebug() << "receive:"<<message;
    emit messageReceived(message);
}
