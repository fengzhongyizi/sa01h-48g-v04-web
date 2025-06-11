#ifndef WEBSOCKETSERVER_H
#define WEBSOCKETSERVER_H

#include <QObject>
#include <QtWebSockets/QWebSocketServer>
#include <QtWebSockets/QWebSocket>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include "terminalmanager.h"
#include "tcpclient.h"

class WebSocketServer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
public:
    explicit WebSocketServer(QObject *parent = nullptr);
    virtual ~WebSocketServer();

    Q_INVOKABLE bool startServer();
    Q_INVOKABLE void stopServer();

    // TCPclient
    Q_INVOKABLE void connectToTcpServer(const QString &host, quint16 port);
    Q_INVOKABLE void sendTcpMessage(const QString &message);

    bool isRunning() const;
    int port() const;
    void setPort(int port);

signals:
    void runningChanged(bool isRunning);
    void portChanged();
    void closed();
    void newClientConnected();
    void clientDisconnected();
    void messageReceived(const QString &message,const QString &path);
    //tcp
    void tcpConnected();
    void tcpDisconnected();
    void tcpErrorOccurred(const QString &error);
    void tcpMessageReceived(const QString &message);

public slots:
    void sendMessageToAllClients(const QString &message);
    void sendMessageToUploadClients(const QString &message);

private slots:
    void onNewConnection();
    void processTextMessage(const QString &message);
    void processBinaryMessage(const QByteArray &message);
    void socketDisconnected();

private:
    QWebSocketServer *m_pWebSocketServer;
    QList<QWebSocket *> m_uploadClients;
    QList<QWebSocket *> m_clients;
    QMap<QWebSocket*, QFile*> m_activeFileUploads;
    TerminalManager m_terminalManager;
    TcpClient *m_tcpClient;

    int m_port;
    bool m_running;
};

#endif // WEBSOCKETSERVER_H
