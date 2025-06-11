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

    // 创建SignalAnalyzerManager实例
    SerialPortManager* spMgr = new SerialPortManager(&app);
    SignalAnalyzerManager* saMgr = new SignalAnalyzerManager(spMgr, &app);

    qmlRegisterType<SerialPortManager>("SerialPort", 1, 0, "SerialPortManager");
    qmlRegisterType<NetManager>("NetManager", 1, 0, "NetManager");
    qmlRegisterType<TerminalManager>("TerminalManager", 1, 0, "TerminalManager");
    qmlRegisterType<FileManager>("FileManager", 1, 0, "FileManager");
    qmlRegisterType<WebSocketServer>("WebSocketServer", 1, 0, "WebSocketServer");
    qmlRegisterType<CHT8310>("CHT8310", 1, 0, "CHT8310");
    TcpServer server;
    server.startServer(80);

    QQmlApplicationEngine engine;
    // 将SignalAnalyzerManager实例暴露给QML
    engine.rootContext()->setContextProperty("signalAnalyzerManager", saMgr);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
