#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <QTcpServer>
#include <QTcpSocket>
#include <QList>
#include <QObject>
#include <QFile>
#include <QTextStream>

class TcpServer : public QTcpServer
{
    Q_OBJECT

public:
    explicit TcpServer(QObject *parent = nullptr);
    ~TcpServer();

    bool startServer(int port);
    void stopServer();
    void sendMessageToAll(const QString &message);

signals:

    void newClientConnected(qintptr socketDescriptor);

    void clientDisconnected(qintptr socketDescriptor);

    void messageReceived(qintptr socketDescriptor, const QString &message);

protected:
    QString m_webRoot;
    void incomingConnection(qintptr socketDescriptor) override;
    void sendHttpResponse(QTcpSocket *client, const QString &path);
    QByteArray getMimeType(const QString &filePath);

private slots:
    void onReadyRead();
    void onDisconnected();

private:
    QList<QTcpSocket*> m_clients;

};

#endif // TCPSERVER_H
