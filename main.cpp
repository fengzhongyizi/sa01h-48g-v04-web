// 注释掉的QGuiApplication头文件
// #include <QGuiApplication>

// 引入必要的Qt头文件
#include <QQmlApplicationEngine>   // 提供QML引擎，用于加载和运行QML应用
#include <QQmlContext>             // 提供QML上下文，用于将C++对象暴露给QML
#include <QApplication>            // 提供Qt应用程序类，支持GUI组件

// 引入自定义组件头文件
#include "serialportmanager.h"     // 串口通信管理类
#include "netmanager.h"            // 网络管理类
#include "terminalmanager.h"       // 终端管理类
#include "filemanager.h"           // 文件管理类
#include "websocketserver.h"       // WebSocket服务器类
#include "signalanalyzermanager.h" // 信号分析器管理类
#include "tcpserver.h"             // TCP服务器类
#include "gpiocontroller.h"        // GPIO控制器类

#include <signal.h>                // 引入信号处理功能，用于处理系统信号

// 在非Windows平台上定义SIGPIPE信号处理
#ifndef Q_OS_WIN
// SIGPIPE信号处理函数 - 当写入到已关闭的管道或套接字时会触发此信号
// 通过捕获并忽略它，可以防止程序意外终止
void sigpipeHandler(int)
{
    qDebug() << "SIGPIPE signal caught and ignored";
}
#endif

// 应用程序入口点
int main(int argc, char *argv[])
{
#ifndef Q_OS_WIN
    // 在Linux/macOS平台上注册SIGPIPE信号处理器
    // 防止写入断开连接的套接字时程序崩溃
    signal(SIGPIPE, sigpipeHandler);
#endif
    // 设置Qt应用程序属性
    // 启用高DPI缩放，支持高分辨率显示
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    // 确保样式表可以正确传播到子部件
    QCoreApplication::setAttribute(Qt::AA_UseStyleSheetPropagationInWidgetStyles, true);

    // 禁用一些功能以提高性能
    QCoreApplication::setAttribute(Qt::AA_DisableHighDpiScaling);   // 禁用高DPI缩放(注意：与上面的EnableHighDpiScaling冲突，可能是错误)
    QCoreApplication::setAttribute(Qt::AA_DisableShaderDiskCache);  // 禁用着色器磁盘缓存，减少I/O操作

    // 创建Qt应用程序实例
    // 使用QApplication而不是QGuiApplication，支持完整的Qt Widget功能
    QApplication app(argc, argv);

    // 设置应用程序使用Fusion样式
    // Fusion是一种跨平台的现代风格，在不同OS上保持一致的外观
    QApplication::setStyle("fusion");

    TcpServer server;
    server.startServer(80);

    // 使用try-catch块捕获初始化过程中可能出现的异常
    try
    {
        // 创建串口管理器实例
        // 负责与硬件设备的串口通信
        auto spMgr = new SerialPortManager(&app);

        // 检查串口是否可用
        // 如果两个关键串口都不可用，发出警告但继续运行
        if (!spMgr->isUart5Available() && !spMgr->isUart3Available())
        {
            qWarning() << "Warning: Serial ports unavailable, some features may not work";
        }

        // 创建信号分析器管理器实例
        // 依赖串口管理器进行通信
        auto saMgr = new SignalAnalyzerManager(spMgr, &app);

        // 创建GPIO控制器实例
        // 用于控制RK3568的GPIO引脚，特别是FPGA Flash升级控制
        auto gpioCtrl = new GpioController(&app);

        // 创建QML应用引擎
        // 用于加载和运行QML用户界面
        QQmlApplicationEngine engine;
        
        // 将C++对象暴露给QML环境
        // 使QML代码可以直接访问这些对象的属性和方法
        engine.rootContext()->setContextProperty("serialPortManager", spMgr);
        engine.rootContext()->setContextProperty("signalAnalyzerManager", saMgr);
        engine.rootContext()->setContextProperty("gpioController", gpioCtrl);

        // 注册C++类型到QML类型系统
        // 允许在QML中创建这些类型的实例
        qmlRegisterType<NetManager>("NetManager", 1, 0, "NetManager");             // 网络管理器
        qmlRegisterType<TerminalManager>("TerminalManager", 1, 0, "TerminalManager"); // 终端管理器
        qmlRegisterType<FileManager>("FileManager", 1, 0, "FileManager");           // 文件管理器
        qmlRegisterType<WebSocketServer>("WebSocketServer", 1, 0, "WebSocketServer"); // WebSocket服务器
        // 注册串口管理器类型，允许在QML中直接创建实例
        qmlRegisterType<SerialPortManager>("SerialPort", 1, 0, "SerialPortManager");
        // 注册GPIO控制器类型，允许在QML中直接创建实例
        qmlRegisterType<GpioController>("GpioController", 1, 0, "GpioController");
        
        // 连接SerialPortManager的PCIe视频信号到SignalAnalyzerManager
        QObject::connect(spMgr, &SerialPortManager::pcieFrameReceived, 
                        saMgr, &SignalAnalyzerManager::updateFrame);
        QObject::connect(spMgr, &SerialPortManager::pcieVideoError,
                        [](const QString &error) {
                            qWarning() << "PCIe Video Error:" << error;
                        });

        // 初始化GPIO控制器
        gpioCtrl->initializeGpio();

        // 加载主QML文件
        // 这是UI的入口点
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
        
        // 检查QML是否成功加载
        // 如果没有根对象，表示加载失败
        if (engine.rootObjects().isEmpty())
            return -1;

        // 启动应用程序事件循环
        // 程序将在此处阻塞，直到应用程序退出
        return app.exec();
    }
    catch (const std::exception &e)
    {
        // 捕获并记录初始化过程中的任何标准异常
        // 提供有意义的错误信息并优雅地退出
        qCritical() << "Fatal error during initialization:" << e.what();
        return -1;
    }
}
