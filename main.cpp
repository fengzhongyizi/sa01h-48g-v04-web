// #include <QGuiApplication>

#include <QQmlApplicationEngine>
#include <QQmlContext> // ← 必须加上这一行
#include <QApplication>

#include "serialportmanager.h"
#include "netmanager.h"
#include "terminalmanager.h"
#include "filemanager.h"
#include "websocketserver.h"
#include "signalanalyzermanager.h"

#include <signal.h>

#ifndef Q_OS_WIN
// SIGPIPE 信号处理函数
void sigpipeHandler(int)
{
    qDebug() << "SIGPIPE signal caught and ignored";
}
#endif

int main(int argc, char *argv[])
{
#ifndef Q_OS_WIN
    // 在 Linux/macOS 上忽略 SIGPIPE 信号
    signal(SIGPIPE, sigpipeHandler);
#endif
    // 设置应用属性，确保在创建QApplication前设置
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    // 确保设置正确的样式
    QCoreApplication::setAttribute(Qt::AA_UseStyleSheetPropagationInWidgetStyles, true);

    // 禁用不必要的功能
    QCoreApplication::setAttribute(Qt::AA_DisableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_DisableShaderDiskCache);

    // 创建应用
    QApplication app(argc, argv);

    // 使用标准样式
    QApplication::setStyle("fusion");

    // 使用try-catch捕获初始化过程中的异常
    try
    {
        // 实例化串口管理器
        auto spMgr = new SerialPortManager(&app);

        // 检查串口初始化状态
        if (!spMgr->isUart5Available() && !spMgr->isUart3Available())
        {
            qWarning() << "Warning: Serial ports unavailable, some features may not work";
        }

        auto saMgr = new SignalAnalyzerManager(spMgr, &app);

        QQmlApplicationEngine engine;
        engine.rootContext()->setContextProperty("serialPortManager", spMgr);
        engine.rootContext()->setContextProperty("signalAnalyzerManager", saMgr);

        qmlRegisterType<NetManager>("NetManager", 1, 0, "NetManager");
        qmlRegisterType<TerminalManager>("TerminalManager", 1, 0, "TerminalManager");
        qmlRegisterType<FileManager>("FileManager", 1, 0, "FileManager");
        qmlRegisterType<WebSocketServer>("WebSocketServer", 1, 0, "WebSocketServer");
        // 如果你还想在 QML 里直接 new SerialPortManager，可以保留下面这行
        qmlRegisterType<SerialPortManager>("SerialPort", 1, 0, "SerialPortManager");

        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
        if (engine.rootObjects().isEmpty())
            return -1;

        return app.exec();
    }
    catch (const std::exception &e)
    {
        qCritical() << "Fatal error during initialization:" << e.what();
        return -1;
    }
}
