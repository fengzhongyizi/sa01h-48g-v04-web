// test_websocketserver.h
#ifndef TEST_WEBSOCKETSERVER_H
#define TEST_WEBSOCKETSERVER_H

#include <QtTest/QtTest>
#include <QtWebSockets/QWebSocketServer>
#include <QtWebSockets/QWebSocket>
#include "websocketserver.h"

class TestWebSocketServer : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    // Test methods
    void testServerCreation();
    void testStartStop();
    void testPortProperty();
    void testIsRunningProperty();
    void testClientConnection();
    void testMessageSending();
    void testMessageReceiving();
    void testClientDisconnection();

private:
    WebSocketServer *m_server;
    QWebSocket *m_testClient;
    QSignalSpy *m_connectionSpy;
    QSignalSpy *m_messageSpy;
    QSignalSpy *m_disconnectionSpy;
    const int TEST_PORT = 8080;
    const QString TEST_MESSAGE = "Hello WebSocket";
};

void TestWebSocketServer::initTestCase()
{
    qDebug() << "Starting WebSocketServer test suite";
}

void TestWebSocketServer::cleanupTestCase()
{
    qDebug() << "Completed WebSocketServer test suite";
}

void TestWebSocketServer::init()
{
    m_server = new WebSocketServer();
    m_server->setPort(TEST_PORT);
    m_testClient = nullptr;
    m_connectionSpy = new QSignalSpy(m_server, &WebSocketServer::newClientConnected);
    m_messageSpy = new QSignalSpy(m_server, &WebSocketServer::messageReceived);
    m_disconnectionSpy = new QSignalSpy(m_server, &WebSocketServer::clientDisconnected);
}

void TestWebSocketServer::cleanup()
{
    if (m_testClient && m_testClient->isValid()) {
        m_testClient->close();
        delete m_testClient;
    }
    
    if (m_server->isRunning()) {
        m_server->stopServer();
    }
    
    delete m_server;
    delete m_connectionSpy;
    delete m_messageSpy;
    delete m_disconnectionSpy;
}

void TestWebSocketServer::testServerCreation()
{
    QVERIFY(m_server != nullptr);
    QCOMPARE(m_server->isRunning(), false);
    QCOMPARE(m_server->port(), TEST_PORT);
}

void TestWebSocketServer::testStartStop()
{
    QVERIFY(m_server->startServer());
    QVERIFY(m_server->isRunning());
    
    m_server->stopServer();
    QVERIFY(!m_server->isRunning());
}

void TestWebSocketServer::testPortProperty()
{
    QSignalSpy portChangedSpy(m_server, &WebSocketServer::portChanged);
    
    m_server->setPort(TEST_PORT + 1);
    QCOMPARE(m_server->port(), TEST_PORT + 1);
    QCOMPARE(portChangedSpy.count(), 1);
}

void TestWebSocketServer::testIsRunningProperty()
{
    QSignalSpy runningSpy(m_server, &WebSocketServer::runningChanged);
    
    QVERIFY(!m_server->isRunning());
    m_server->startServer();
    QVERIFY(m_server->isRunning());
    QCOMPARE(runningSpy.count(), 1);
    
    m_server->stopServer();
    QVERIFY(!m_server->isRunning());
    QCOMPARE(runningSpy.count(), 2);
}

void TestWebSocketServer::testClientConnection()
{
    m_server->startServer();
    
    m_testClient = new QWebSocket();
    m_testClient->open(QUrl(QString("ws://localhost:%1").arg(TEST_PORT)));
    
    // Wait for connection
    QTRY_COMPARE_WITH_TIMEOUT(m_connectionSpy->count(), 1, 3000);
}

void TestWebSocketServer::testMessageSending()
{
    m_server->startServer();
    
    QWebSocket client;
    QSignalSpy clientMessageSpy(&client, &QWebSocket::textMessageReceived);
    
    client.open(QUrl(QString("ws://localhost:%1").arg(TEST_PORT)));
    QTRY_VERIFY_WITH_TIMEOUT(client.isValid() && client.state() == QAbstractSocket::ConnectedState, 3000);
    
    m_server->sendMessageToAllClients(TEST_MESSAGE);
    
    QTRY_COMPARE_WITH_TIMEOUT(clientMessageSpy.count(), 1, 3000);
    QCOMPARE(clientMessageSpy.at(0).at(0).toString(), TEST_MESSAGE);
}

void TestWebSocketServer::testMessageReceiving()
{
    m_server->startServer();
    
    m_testClient = new QWebSocket();
    m_testClient->open(QUrl(QString("ws://localhost:%1").arg(TEST_PORT)));
    
    QTRY_VERIFY_WITH_TIMEOUT(m_testClient->isValid() && m_testClient->state() == QAbstractSocket::ConnectedState, 3000);
    
    m_testClient->sendTextMessage(TEST_MESSAGE);
    
    QTRY_COMPARE_WITH_TIMEOUT(m_messageSpy->count(), 1, 3000);
    QCOMPARE(m_messageSpy->at(0).at(0).toString(), TEST_MESSAGE);
}

void TestWebSocketServer::testClientDisconnection()
{
    m_server->startServer();
    
    m_testClient = new QWebSocket();
    m_testClient->open(QUrl(QString("ws://localhost:%1").arg(TEST_PORT)));
    
    QTRY_VERIFY_WITH_TIMEOUT(m_testClient->isValid() && m_testClient->state() == QAbstractSocket::ConnectedState, 3000);
    
    m_testClient->close();
    
    QTRY_COMPARE_WITH_TIMEOUT(m_disconnectionSpy->count(), 1, 3000);
}

QTEST_MAIN(TestWebSocketServer)
//#include "test_websocketserver.moc"

#endif // TEST_WEBSOCKETSERVER_H