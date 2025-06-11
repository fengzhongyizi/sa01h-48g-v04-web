# Qt模块依赖声明
QT += quick        # 引入Qt Quick模块，用于QML界面开发
QT += serialport   # 引入Qt串口模块，用于与硬件设备通信
QT += network      # 引入网络模块，提供TCP/IP通信功能  
QT += core websockets  # 引入核心功能和WebSocket支持
QT += charts       # 引入图表模块，用于数据可视化

# 编译配置
CONFIG += c++11   # 启用C++11标准特性

# 编译器警告设置
# 使编译器在使用被标记为废弃的Qt API时发出警告
# 具体警告取决于使用的编译器
DEFINES += QT_DEPRECATED_WARNINGS

# 可选的编译器配置
# 如果取消下面这行的注释，将导致使用已废弃API的代码无法编译
# 还可以选择只禁用特定Qt版本之前的废弃API
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # 禁用Qt 6.0.0之前所有废弃的API

# pcievideoreciver.cpp \       # PCIe视频接收器实现

SOURCES += \
        main.cpp \               # 主程序入口
    serialportmanager.cpp \      # 串口管理器实现
    netmanager.cpp \             # 网络管理器实现
    terminalmanager.cpp \        # 终端管理器实现
    filemanager.cpp \            # 文件管理器实现
    websocketserver.cpp \        # WebSocket服务器实现
    tcpserver.cpp \              # TCP服务器实现
    tcpclient.cpp \
    cht8310.cpp \
    parseedid.cpp \
    signalanalyzermanager.cpp  # 信号分析器管理器实现

# 项目资源文件
RESOURCES += qml.qrc            # 包含QML界面文件的资源文件

# 附加导入路径设置
# 用于解析Qt Creator代码模型中的QML模块
QML_IMPORT_PATH =

# 附加导入路径设置
# 仅用于Qt Quick Designer的QML模块解析
QML_DESIGNER_IMPORT_PATH =

# 默认部署规则
# 根据不同目标平台设置安装路径
qnx: target.path = /tmp/$${TARGET}/bin                  # QNX平台安装路径
else: unix:!android: target.path = /opt/$${TARGET}/bin  # 其他Unix系统(非Android)安装路径
!isEmpty(target.path): INSTALLS += target               # 如果目标路径非空，添加安装目标

# 额外文件列表(当前为空)
DISTFILES +=

# 项目头文件列表
HEADERS += \
    serialportmanager.h \
    netmanager.h \
    terminalmanager.h \
    filemanager.h \
    websocketserver.h \
    tcpserver.h \
    tcpclient.h \
    cht8310.h \
    parseedid.h \
    signalanalyzermanager.h

# 在SA01H-48G-V04.pro中添加
QMAKE_LFLAGS += -Wl,--allow-shlib-undefined
QMAKE_LFLAGS += -Wl,--no-as-needed