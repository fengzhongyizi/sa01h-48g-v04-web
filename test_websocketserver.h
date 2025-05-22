/**
 * @file test_websocketserver.h
 * @brief WebSocketServer单元测试类
 * 
 * 使用Qt Test框架对WebSocketServer类进行单元测试，
 * 验证WebSocket服务器的创建、启动/停止、连接管理和消息传输等功能。
 */

#ifndef TEST_WEBSOCKETSERVER_H
#define TEST_WEBSOCKETSERVER_H

#include <QtTest/QtTest>               // Qt测试框架
#include <QtWebSockets/QWebSocketServer> // WebSocket服务器基类
#include <QtWebSockets/QWebSocket>     // WebSocket客户端
#include "websocketserver.h"           // 被测试类

/**
 * @class TestWebSocketServer
 * @brief WebSocketServer测试类
 * 
 * 通过一系列测试用例验证WebSocketServer类的功能正确性
 */
class TestWebSocketServer : public QObject
{
    Q_OBJECT

private slots:
    /** @brief 测试套件初始化 - 在所有测试用例执行前调用 */
    void initTestCase();
    /** @brief 测试套件清理 - 在所有测试用例执行后调用 */
    void cleanupTestCase();
    /** @brief 单个测试用例初始化 - 在每个测试用例执行前调用 */
    void init();
    /** @brief 单个测试用例清理 - 在每个测试用例执行后调用 */
    void cleanup();

    // 测试方法
    /** @brief 测试服务器创建 - 验证服务器对象初始化正确 */
    void testServerCreation();
    /** @brief 测试启动停止 - 验证服务器能正确启动和停止 */
    void testStartStop();
    /** @brief 测试端口属性 - 验证端口设置和信号正常工作 */
    void testPortProperty();
    /** @brief 测试运行状态属性 - 验证isRunning属性和信号正常工作 */
    void testIsRunningProperty();
    /** @brief 测试客户端连接 - 验证客户端能成功连接到服务器 */
    void testClientConnection();
    /** @brief 测试消息发送 - 验证服务器能向客户端发送消息 */
    void testMessageSending();
    /** @brief 测试消息接收 - 验证服务器能接收客户端消息 */
    void testMessageReceiving();
    /** @brief 测试客户端断开连接 - 验证断开连接的处理逻辑 */
    void testClientDisconnection();

private:
    WebSocketServer *m_server;        // 被测试的WebSocketServer实例
    QWebSocket *m_testClient;         // 测试用WebSocket客户端
    QSignalSpy *m_connectionSpy;      // 监听新客户端连接信号
    QSignalSpy *m_messageSpy;         // 监听消息接收信号
    QSignalSpy *m_disconnectionSpy;   // 监听客户端断开连接信号
    const int TEST_PORT = 8080;       // 测试用端口号
    const QString TEST_MESSAGE = "Hello WebSocket"; // 测试用消息内容
};

/**
 * @brief 测试套件初始化
 * 在所有测试用例执行前记录开始信息
 */
void TestWebSocketServer::initTestCase()
{
    qDebug() << "Starting WebSocketServer test suite";
}

/**
 * @brief 测试套件清理
 * 在所有测试用例执行后记录完成信息
 */
void TestWebSocketServer::cleanupTestCase()
{
    qDebug() << "Completed WebSocketServer test suite";
}

/**
 * @brief 测试用例初始化
 * 在每个测试用例执行前创建服务器对象和信号监听器
 */
void TestWebSocketServer::init()
{
    m_server = new WebSocketServer();           // 创建WebSocketServer实例
    m_server->setPort(TEST_PORT);               // 设置测试端口
    m_testClient = nullptr;                     // 初始化客户端为空
    m_connectionSpy = new QSignalSpy(m_server, &WebSocketServer::newClientConnected);    // 监听连接信号
    m_messageSpy = new QSignalSpy(m_server, &WebSocketServer::messageReceived);          // 监听消息信号
    m_disconnectionSpy = new QSignalSpy(m_server, &WebSocketServer::clientDisconnected); // 监听断开连接信号
}

/**
 * @brief 测试用例清理
 * 在每个测试用例执行后清理资源，确保测试环境隔离
 */
void TestWebSocketServer::cleanup()
{
    // 关闭并删除测试客户端
    if (m_testClient && m_testClient->isValid()) {
        m_testClient->close();
        delete m_testClient;
    }
    
    // 停止服务器
    if (m_server->isRunning()) {
        m_server->stopServer();
    }
    
    // 删除所有测试对象
    delete m_server;
    delete m_connectionSpy;
    delete m_messageSpy;
    delete m_disconnectionSpy;
}

/**
 * @brief 测试服务器创建
 * 验证服务器对象初始状态是否正确
 */
void TestWebSocketServer::testServerCreation()
{
    QVERIFY(m_server != nullptr);              // 验证服务器对象已创建
    QCOMPARE(m_server->isRunning(), false);    // 验证初始状态为未运行
    QCOMPARE(m_server->port(), TEST_PORT);     // 验证端口设置正确
}

/**
 * @brief 测试启动停止功能
 * 验证服务器能正确启动和停止
 */
void TestWebSocketServer::testStartStop()
{
    QVERIFY(m_server->startServer());          // 验证服务器能成功启动
    QVERIFY(m_server->isRunning());            // 验证启动后状态为运行中
    
    m_server->stopServer();                    // 停止服务器
    QVERIFY(!m_server->isRunning());           // 验证停止后状态为未运行
}

/**
 * @brief 测试端口属性
 * 验证端口设置和端口变更信号
 */
void TestWebSocketServer::testPortProperty()
{
    QSignalSpy portChangedSpy(m_server, &WebSocketServer::portChanged); // 监听端口变更信号
    
    m_server->setPort(TEST_PORT + 1);          // 修改端口
    QCOMPARE(m_server->port(), TEST_PORT + 1); // 验证端口已更新
    QCOMPARE(portChangedSpy.count(), 1);       // 验证端口变更信号已发出
}

/**
 * @brief 测试运行状态属性
 * 验证isRunning属性和状态变更信号
 */
void TestWebSocketServer::testIsRunningProperty()
{
    QSignalSpy runningSpy(m_server, &WebSocketServer::runningChanged); // 监听运行状态变更信号
    
    QVERIFY(!m_server->isRunning());           // 验证初始状态为未运行
    m_server->startServer();                   // 启动服务器
    QVERIFY(m_server->isRunning());            // 验证状态已更新为运行中
    QCOMPARE(runningSpy.count(), 1);           // 验证状态变更信号已发出
    
    m_server->stopServer();                    // 停止服务器
    QVERIFY(!m_server->isRunning());           // 验证状态已更新为未运行
    QCOMPARE(runningSpy.count(), 2);           // 验证状态再次变更的信号已发出
}

/**
 * @brief 测试客户端连接
 * 验证客户端能成功连接到服务器并触发连接信号
 */
void TestWebSocketServer::testClientConnection()
{
    m_server->startServer();                   // 启动服务器
    
    m_testClient = new QWebSocket();           // 创建测试客户端
    m_testClient->open(QUrl(QString("ws://localhost:%1").arg(TEST_PORT))); // 连接到服务器
    
    // 等待连接信号(最多3秒)
    QTRY_COMPARE_WITH_TIMEOUT(m_connectionSpy->count(), 1, 3000);
}

/**
 * @brief 测试消息发送
 * 验证服务器能向客户端发送消息
 */
void TestWebSocketServer::testMessageSending()
{
    m_server->startServer();                   // 启动服务器
    
    QWebSocket client;                         // 创建客户端
    QSignalSpy clientMessageSpy(&client, &QWebSocket::textMessageReceived); // 监听客户端收到的消息
    
    client.open(QUrl(QString("ws://localhost:%1").arg(TEST_PORT))); // 连接到服务器
    QTRY_VERIFY_WITH_TIMEOUT(client.isValid() && client.state() == QAbstractSocket::ConnectedState, 3000); // 等待连接建立
    
    m_server->sendMessageToAllClients(TEST_MESSAGE); // 服务器发送消息
    
    QTRY_COMPARE_WITH_TIMEOUT(clientMessageSpy.count(), 1, 3000); // 等待客户端收到消息
    QCOMPARE(clientMessageSpy.at(0).at(0).toString(), TEST_MESSAGE); // 验证收到的消息内容
}

/**
 * @brief 测试消息接收
 * 验证服务器能接收客户端发送的消息
 */
void TestWebSocketServer::testMessageReceiving()
{
    m_server->startServer();                   // 启动服务器
    
    m_testClient = new QWebSocket();           // 创建测试客户端
    m_testClient->open(QUrl(QString("ws://localhost:%1").arg(TEST_PORT))); // 连接到服务器
    
    QTRY_VERIFY_WITH_TIMEOUT(m_testClient->isValid() && m_testClient->state() == QAbstractSocket::ConnectedState, 3000); // 等待连接建立
    
    m_testClient->sendTextMessage(TEST_MESSAGE); // 客户端发送消息
    
    QTRY_COMPARE_WITH_TIMEOUT(m_messageSpy->count(), 1, 3000); // 等待服务器收到消息
    QCOMPARE(m_messageSpy->at(0).at(0).toString(), TEST_MESSAGE); // 验证服务器收到的消息内容
}

/**
 * @brief 测试客户端断开连接
 * 验证客户端断开连接时服务器能正确处理并发出信号
 */
void TestWebSocketServer::testClientDisconnection()
{
    m_server->startServer();                   // 启动服务器
    
    m_testClient = new QWebSocket();           // 创建测试客户端
    m_testClient->open(QUrl(QString("ws://localhost:%1").arg(TEST_PORT))); // 连接到服务器
    
    QTRY_VERIFY_WITH_TIMEOUT(m_testClient->isValid() && m_testClient->state() == QAbstractSocket::ConnectedState, 3000); // 等待连接建立
    
    m_testClient->close();                     // 客户端断开连接
    
    QTRY_COMPARE_WITH_TIMEOUT(m_disconnectionSpy->count(), 1, 3000); // 等待服务器收到断开连接信号
}

QTEST_MAIN(TestWebSocketServer)  // 创建主函数，运行测试类
//#include "test_websocketserver.moc" // 注释掉的moc包含

#endif // TEST_WEBSOCKETSERVER_H