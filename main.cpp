#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "serialportmanager.h"
#include "netmanager.h"
#include "terminalmanager.h"
#include "filemanager.h"
#include "websocketserver.h"
#include "tcpserver.h"
#include "cht8310.h"
#include "signalanalyzermanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    // 先创建SerialPortManager实例，让QML和SignalAnalyzerManager共享
    SerialPortManager* spMgr = new SerialPortManager(&app);
    SignalAnalyzerManager* saMgr = new SignalAnalyzerManager(spMgr, &app);

    // 注册类型但不让QML创建新实例，而是使用现有实例
    qmlRegisterType<SerialPortManager>("SerialPort", 1, 0, "SerialPortManager");
    qmlRegisterType<NetManager>("NetManager", 1, 0, "NetManager");
    qmlRegisterType<TerminalManager>("TerminalManager", 1, 0, "TerminalManager");
    qmlRegisterType<FileManager>("FileManager", 1, 0, "FileManager");
    qmlRegisterType<WebSocketServer>("WebSocketServer", 1, 0, "WebSocketServer");
    qmlRegisterType<CHT8310>("CHT8310", 1, 0, "CHT8310");
    TcpServer server;
    server.startServer(80);

    QQmlApplicationEngine engine;
    
    // 创建并注册内存图像提供器 - 革命性性能优化
    MemoryImageProvider* imageProvider = new MemoryImageProvider();
    SignalAnalyzerManager::setImageProvider(imageProvider);
    engine.addImageProvider("memory", imageProvider);
    
    // 将SignalAnalyzerManager和SerialPortManager实例暴露给QML
    engine.rootContext()->setContextProperty("signalAnalyzerManager", saMgr);
    engine.rootContext()->setContextProperty("serialPortManager", spMgr);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
