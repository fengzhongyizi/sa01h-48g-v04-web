// 导入必要的Qt模块
import QtQuick 2.12             // Qt Quick核心模块，提供QML基本元素
import QtQuick.Window 2.12      // 提供Window元素用于创建应用窗口
import QtQuick.Controls.Material 2.3  // Material风格的控件
import QtQuick.Controls 2.3     // 提供Button等控件
import QtQuick.Layouts 1.3      // 提供布局管理器如RowLayout
import QtGraphicalEffects 1.12  // 提供图形特效
//import SerialPort 1.0           // 自定义C++模块，处理串口通信
import NetManager 1.0           // 自定义C++模块，处理网络通信
import TerminalManager 1.0      // 自定义C++模块，处理终端命令
import FileManager 1.0          // 自定义C++模块，处理文件操作
import WebSocketServer 1.0      // 自定义C++模块，提供WebSocket服务

// 主窗口定义
Window {
    id: window
    visible: true               // 窗口可见
    minimumHeight: 1200         // 最小高度
    maximumHeight: 1200         // 最大高度
    minimumWidth: 1920          // 最小宽度
    maximumWidth: 1920          // 最大宽度
    title: qsTr("SG01H-48G-V04")  // 窗口标题
    
    flags: Qt.FramelessWindowHint | Qt.Window  // 无边框窗口

    // 全局属性和变量
    property int typecmd: 0                    // 命令类型
    property string command_header: "AA 00 00 " // 命令头部
    property string command_length: "06 00 "    // 命令长度
    property string command_group_address: "00 " // 组地址
    property string command_device_address: "00 " // 设备地址
    property string strcode: "61 00 "          // 状态码
    property string hexString: "61 00 "        // 十六进制字符串
    property alias virtualKeyboard: virtualKeyboard  // 虚拟键盘别名
    property TextField currentInputField: null  // 当前输入框
    property string syscmd: ""                 // 系统命令
    property string version: "0.1"             // 应用版本
    
    // 当前选中的页面索引
    property int currentPage: 0                // 页面标识

    // 电池状态指示器组件
    BatteryIndicator {
        id: batteryIndicator
        batteryLevel: 100               // Default to 100% when powered directly
        isCharging: false               // Not charging when powered directly
        anchors.right: parent.right     
        anchors.top: parent.top         
        anchors.margins: 10             
        z: 1000 // Ensure on top layer
    }

    // 全局鼠标区域，用于隐藏虚拟键盘
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // 如果点击区域不在虚拟键盘内，则隐藏键盘
            if (virtualKeyboard.visible && !virtualKeyboard.contains(Qt.point(mouse.x, mouse.y))) {
                virtualKeyboard.visible = false;
            }
        }
    }

    // 虚拟键盘组件
    VirtualKeyboard {
        id: virtualKeyboard
        width: window.width
        height: 400
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: false                  // 初始状态隐藏

        // 键盘按键事件处理
        onKeyPressed: {
            if (currentInputField) {
                var text = currentInputField.text;
                var cursorPos = currentInputField.cursorPosition;
                if (key === "Backspace") {
                    // 处理退格键
                    if (currentInputField.cursorPosition > 0) {
                        currentInputField.text = text.slice(0, cursorPos - 1) + text.slice(cursorPos);
                        currentInputField.cursorPosition = cursorPos - 1;
                    }
                } else {
                    // 处理普通按键
                    currentInputField.text = text.slice(0, cursorPos) + key + text.slice(cursorPos);
                    currentInputField.cursorPosition = cursorPos + 1;
                }
                currentInputField.forceActiveFocus();
            }
        }
    }

    // 终端管理器 - 用于执行系统命令
    TerminalManager {
        id: terminalManager
    }

    // 文件管理器 - 用于文件操作
    FileManager {
        id: fileManager
    }

    // WebSocket服务器 - 用于远程通信
    WebSocketServer {
        id: webSocketServer
        port: 8081                        // WebSocket端口

        // WebSocket事件处理
        onRunningChanged: console.log("Server running:", isRunning)
        onNewClientConnected: console.log("New client connected")
        onClientDisconnected: console.log("Client disconnected")
        onMessageReceived: console.log("Message received:", message)
    }

    // 网络管理器 - 处理网络通信
    NetManager {
        id: netManager
        
        // 添加网络信息变化的连接
        onIpAddressChanged: {
            console.log("IP address updated:", ipAddress);
            // 如果当前在System Setup页面，可以触发UI更新
            if (customTabBar.currentIndex === 4) {
                systemSetupPanel.updateNetworkDisplay();
            }
        }
        
        onMacAddressChanged: {
            console.log("MAC address updated:", macAddress);
        }
        
        // 添加DHCP失败处理
        onDhcpConfigurationFailed: {
            console.log("DHCP configuration failed:", error);
            // 可以显示错误对话框或通知用户
            if (customTabBar.currentIndex === 4) {
                systemSetupPanel.showDhcpError(error);
            }
        }
        
        Component.onCompleted: {
            console.log("NetManager initialized");
            // 延迟初始化，确保系统准备就绪
            initTimer.start();
        }
    }

    // 添加初始化定时器
    Timer {
        id: initTimer
        interval: 1000  // 1秒后初始化
        repeat: false
        onTriggered: {
            console.log("Initializing network info...");
            netManager.updateNetworkInfo();
        }
    }

    // 字体加载器 - 加载自定义字体
    FontLoader {
        id: fontNimbusSanL
        source: "qrc:/fonts/BebasKai-Regular.otf"  // 字体文件路径
    }
    
    FontLoader {
        id: myriadPro
        source: "qrc:/fonts/MyriadPro-Cond.ttf"    // 字体文件路径
    }
    
    // 主页面设计 - 应用的主UI容器
    Rectangle {
        id: mainContainer
        anchors.fill: parent       // 填充整个父容器
        color: "lightgray"         // 背景色

        // 自定义标签栏 - 顶部导航
        Row {
            id: customTabBar
            property int currentIndex: 0   // 当前选中标签索引
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 120                    // 标签栏高度

            // 使用重复器创建标签按钮
            Repeater {
                model: ["Monitor", "Signal Info", "EDID", "Error Rate", "System Setup"]  // 添加第5个标签
                delegate: Rectangle {
                    width: customTabBar.width / 5   // 改为5等分宽度
                    height: customTabBar.height
                    // 当前选中项为蓝色，其他为深灰色
                    color: customTabBar.currentIndex === index ? "#336699" : "#444444"
                    
                    // 底部白色指示条 - 仅在选中时显示
                    Rectangle {
                        visible: customTabBar.currentIndex === index
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 5
                        color: "white"
                    }

                    // 标签文本
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.family: myriadPro.name
                        font.pixelSize: 32  // 稍微减小字体以适应5个标签
                        color: "white"
                        font.bold: customTabBar.currentIndex === index  // 选中项加粗
                    }

                    // 鼠标事件处理 - 切换标签
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (customTabBar.currentIndex !== index) {
                                customTabBar.currentIndex = index
                            }
                        }
                    }
                }
            }
        }

        // 内容区域 - 显示选中页面
        Item {
            id: contentArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: customTabBar.bottom
            anchors.bottom: parent.bottom
            
            clip: true    // 裁剪超出边界的内容

            // 监听标签切换事件，强制更新页面可见性
            Connections {
                target: customTabBar
                function onCurrentIndexChanged() {
                    // 记录当前监测状态
                    var wasMonitoring = false;
                    if (customTabBar.currentIndex === 3 || errorRateAnalyzer.isMonitoring) {
                        wasMonitoring = errorRateAnalyzer.isMonitoring;
                    }
                    
                    // 遍历所有子项，更新可见性
                    for(var i = 0; i < contentArea.children.length; i++) {
                        var child = contentArea.children[i];
                        if(child.hasOwnProperty("visible")) {
                            child.opacity = 0;  // 先设为透明
                            child.visible = (i === customTabBar.currentIndex);  // 设置可见性
                            child.opacity = 1;  // 再立即设为不透明
                        }
                    }

                    // 当切换到Signal Info页(index=1)时请求信号信息
                    if (customTabBar.currentIndex === 1) {
                        signalAnalyzerManager.refreshSignalInfo();
                    }
                    // 当切换到EDID页(index=2)时请求当前EDID状态
                    else if (customTabBar.currentIndex === 2) {
                        // 自动获取当前选中的EDID状态（指令待确认）
                        // 可能的指令格式：
                        // serialPortManager.writeDataUart5("GET IN1 CURRENT EDID\r\n", 1);
                        // 或者：
                        // serialPortManager.writeDataUart5("GET IN1 EDID STATUS\r\n", 1);
                        
                        console.log("Switched to EDID page - ready to get current EDID status");
                        // 当MCU指令确认后，取消注释相应的指令
                    }
                    
                    // 即使切换离开Error Rate页面，也保持监测状态
                    if (wasMonitoring) {
                        console.log("保持监测状态不中断");
                        // 无需执行任何操作，让后台继续监测
                    }
                    
                    // 当切换回Error Rate页面时，更新显示
                    if (customTabBar.currentIndex === 3 && wasMonitoring) {
                        console.log("切换回Error Rate页面，更新监测数据显示");
                        errorRateAnalyzer.updateMonitorDisplay();
                    }

                    // 当切换到System Setup页(index=4)时的处理
                    else if (customTabBar.currentIndex === 4) {
                        console.log("Switched to System Setup page");
                        netManager.updateNetworkInfo();
                        
                        // 额外的调试信息
                        console.log("Current network info:");
                        console.log("- IP:", netManager.ipAddress);
                        console.log("- MAC:", netManager.macAddress);
                        console.log("- Netmask:", netManager.netmask);
                        console.log("- Gateway:", netManager.routerIpAddress);
                    }
                }
            }

            // Monitor页面
            Item {
                id: monitorPage
                anchors.fill: parent
                visible: customTabBar.currentIndex === 0  // 仅当选中时可见
                
                // 使用SignalAnalyzer组件显示监视器内容
                SignalAnalyzer {
                    id: monitorAnalyzer
                    anchors.fill: parent
                    pageFlag: 1   // 设置为Monitor页面模式
                }
            }

            // Signal Info页面
            Item {
                id: signalInfoPage
                anchors.fill: parent
                visible: customTabBar.currentIndex === 1
                
                SignalAnalyzer {
                    id: signalInfoAnalyzer
                    anchors.fill: parent
                    pageFlag: 2   // 设置为Signal Info页面模式
                }
            }

            // EDID页面
            Item {
                id: edidPage
                anchors.fill: parent
                visible: customTabBar.currentIndex === 2
                
                SignalAnalyzer {
                    id: edidAnalyzer
                    anchors.fill: parent
                    pageFlag: 3   // 设置为EDID页面模式
                }
            }

            // Error Rate页面
            Item {
                id: errorRatePage
                anchors.fill: parent
                visible: customTabBar.currentIndex === 3
                
                SignalAnalyzer {
                    id: errorRateAnalyzer
                    anchors.fill: parent
                    pageFlag: 4   // 设置为Error Rate页面模式
                }
            }

            // System Setup页面
            Item {
                id: systemSetupPage
                anchors.fill: parent
                visible: customTabBar.currentIndex === 4
                
                SystemSetupPanel {
                    id: systemSetupPanel
                    anchors.fill: parent
                }
            }
        }
    }

    // 连接C++导出的serialPortManager信号
    Connections {
        target: serialPortManager
        
        function onDataReceived(data) {
            // 解析接收的数据
            var str = data.toString();
            var getdata = str.split(" ")         // 按空格分割数据
            var lengthlow = getdata[3];          // 数据长度低位
            var lengthheight = getdata[4];       // 数据长度高位
            var length = parseInt(getdata[4] + getdata[3], 16);  // 计算总长度
            strcode = getdata[7] + getdata[8];   // 提取状态码
            var num = getdata.slice(9, length+4); // 提取数据部分
            
            // Process battery status related data - component will auto-update based on SerialPortManager received data
            if(strcode == "9880"){
                // Battery level processing
                var value = parseInt(getdata[9]+getdata[10], 16);
                var calculatedLevel = (value-1.75)*200;
                // Only update if we get valid battery data
                if (calculatedLevel >= 0 && calculatedLevel <= 100) {
                    batteryIndicator.batteryLevel = calculatedLevel;
                    batteryIndicator.isCharging = false; // Will be updated by next packet if charging
                }
            } else if(strcode == "9980"){
                // Battery charging status processing
                var batteryconnet = parseInt(getdata[9], 16);
                var batterystatus = parseInt(getdata[10], 16);
                if(batteryconnet===1){
                    batteryIndicator.isCharging = (batterystatus === 1) ? true : false;
                }
            }
            
            // 将数据转发给当前显示的SignalAnalyzer实例
            if (customTabBar.currentIndex === 0) {
                monitorAnalyzer.processReceiveData(strcode, getdata);
            } else if (customTabBar.currentIndex === 1) {
                signalInfoAnalyzer.processReceiveData(strcode, getdata);
            } else if (customTabBar.currentIndex === 2) {
                edidAnalyzer.processReceiveData(strcode, getdata);
            } else if (customTabBar.currentIndex === 3) {
                errorRateAnalyzer.processReceiveData(strcode, getdata);
            }
        }
        
        function onDataReceivedASCALL(data){
            // Similar to binary data, forward data based on current selected tab
            if (customTabBar.currentIndex === 0) {
                monitorAnalyzer.processReceiveAsciiData(data);
            } else if (customTabBar.currentIndex === 1) {
                signalInfoAnalyzer.processReceiveAsciiData(data);
            } else if (customTabBar.currentIndex === 2) {
                edidAnalyzer.processReceiveAsciiData(data);
            } else if (customTabBar.currentIndex === 3) {
                errorRateAnalyzer.processReceiveAsciiData(data);
            }
        }
    }

    // SystemSetup confirmsignal信号处理连接
    Connections {
        target: systemSetupPanel

        function onConfirmsignal(str, num) {
            console.log("SystemSetup confirmsignal:", str, num)
            hexString = num.toString(16);
            
            // 确保十六进制字符串为偶数长度
            if (hexString.length % 2 !== 0) {
                hexString = "0" + hexString;
            }
            
            // 格式化十六进制字符串，每两位加空格
            var formattedHexString = "";
            for (var i = 0; i < hexString.length; i += 2) {
                formattedHexString += hexString.substr(i, 2) + " ";
            }
            hexString = formattedHexString.trim();

            // 默认命令参数
            strcode = "61 00 ";
            command_length = "06 00 "
            
            // 根据不同的设置类型处理
            if (str === "DHCP") {
                if (num === true) {
                    console.log("Enabling DHCP mode");
                    netManager.setIpAddress("", "", "", "dhcp");  // 清空静态参数
                    fileManager.updateData("ipmode", "dhcp");
                } else {
                    console.log("Enabling static IP mode with values:");
                    
                    // 直接从组件获取当前值，不使用别名
                    var hostIp = systemSetupPanel.children[2].children[0].children[1].children[1].children[0].text;
                    var ipMask = systemSetupPanel.children[2].children[0].children[1].children[5].children[0].text;
                    var routerIp = systemSetupPanel.children[2].children[0].children[1].children[3].children[0].text;
                    
                    // 更安全的方式：添加findChild函数
                    function findTextFieldById(parent, id) {
                        for (var i = 0; i < parent.children.length; i++) {
                            var child = parent.children[i];
                            if (child.objectName === id) {
                                return child;
                            }
                            var found = findTextFieldById(child, id);
                            if (found) return found;
                        }
                        return null;
                    }
                    
                    // 或者直接使用更可靠的方式
                    netManager.setIpAddress(
                        systemSetupPanel.hostIpText,
                        systemSetupPanel.ipMaskText,
                        systemSetupPanel.routerIpText,
                        "static"
                    );
                    
                    fileManager.updateData("ipmode", "static");
                    fileManager.updateData("iphost", systemSetupPanel.hostIpText);
                    fileManager.updateData("ipmask", systemSetupPanel.ipMaskText);
                    fileManager.updateData("iprouter", systemSetupPanel.routerIpText);
                }
            } else if (str === "ARC/eARC_OUT") {
                strcode = "83 00 ";
                command_length = "06 00 ";
                fileManager.updateData("ARC/eARC_OUT", hexString);
                serialPortManager.writeDataUart5("SET IN1 EARC" + num + "\r\n", 1);
            } else if (str === "FanControl") {
                strcode = "03 78 ";
                command_length = "06 00 ";
                fileManager.updateData("FanControl", hexString);
                serialPortManager.writeDataUart5("SET FAN SPEED " + num + "\r\n", 1);
                return  // 直接返回，不发送串口命令
            } else if (str === "ResetDefault") {
                // 执行重置默认设置操作
                // reset();  // 如果有reset函数的话
                console.log("Reset to default settings requested");
            } else if (str === "Reboot") {
                syscmd = "reboot";
                terminalManager.executeCommand(syscmd);
            } else if (str === "PowerOut") {
                strcode = "AB 00 ";
                command_length = "06 00 ";
            } else if (str === "vitals") {
                strcode = "F8 58 ";
                command_length = "06 00 ";
            } else if (str === "LinkTrainForce") {
                strcode = "C0 00 ";
                command_length = "07 00 ";
                if (num === 0) {
                    hexString = "00 00";
                }
            } else if (str === "LinkTrain") {
                strcode = "C1 00 ";
                command_length = "07 00 ";
            } else if (str === "AudioInfoframeRead") {
                strcode = "01 FE ";
                command_length = "05 00 ";
            } else if (str === "AudioInfoframeWrite") {
                strcode = "01 7E ";
                command_length = "07 00 ";
            }

            // 构建完整的串口命令并发送
            var completeString = command_header + command_length + command_group_address + command_device_address + strcode + hexString;
            serialPortManager.writeData(completeString, typecmd);
        }
    }

    // 初始化函数 - 应用启动时执行
    Component.onCompleted: {
        webSocketServer.startServer();  // 启动WebSocket服务器
    }
}
