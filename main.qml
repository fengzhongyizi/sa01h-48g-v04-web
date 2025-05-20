import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import SerialPort 1.0
import NetManager 1.0
import TerminalManager 1.0
import FileManager 1.0
import WebSocketServer 1.0

Window {
    id: window
    visible: true
    minimumHeight: 1200
    maximumHeight: 1200
    minimumWidth: 1920
    maximumWidth: 1920
    //    color: "#000000"
    title: qsTr("SG01H-48G-V04")

    flags: Qt.FramelessWindowHint | Qt.Window

    property int typecmd:0
    property string command_header: "AA 00 00 "
    property string command_length: "06 00 "
    property string command_group_address: "00 "
    property string command_device_address: "00 "
    property string strcode: "61 00 "
    property string hexString: "61 00 "
    property alias virtualKeyboard: virtualKeyboard
    property TextField currentInputField: null
    property string syscmd: ""
    property string version: "0.1"
    
    // 当前选中的页面索引
    property int currentPage: 0

    BatteryIndicator {
        id: batteryIndicator
        batteryLevel: 30
        isCharging:true
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (virtualKeyboard.visible && !virtualKeyboard.contains(Qt.point(mouse.x, mouse.y))) {
                virtualKeyboard.visible = false;
            }
        }
    }

    VirtualKeyboard {
        id: virtualKeyboard
        width: window.width
        height: 400
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: false

        onKeyPressed: {
            if (currentInputField) {
                var text = currentInputField.text;
                var cursorPos = currentInputField.cursorPosition;
                if (key === "Backspace") {
                    if (currentInputField.cursorPosition > 0) {
                        currentInputField.text = text.slice(0, cursorPos - 1) + text.slice(cursorPos);
                        currentInputField.cursorPosition = cursorPos - 1;
                    }
                } else {
                    currentInputField.text = text.slice(0, cursorPos) + key + text.slice(cursorPos);
                    currentInputField.cursorPosition = cursorPos + 1;
                }
                currentInputField.forceActiveFocus();
            }
        }
    }

    TerminalManager {
        id: terminalManager
    }

    FileManager {
        id: fileManager
    }

    WebSocketServer {
        id: webSocketServer
        port: 80

        onRunningChanged: console.log("Server running:", isRunning)
        onNewClientConnected: console.log("New client connected")
        onClientDisconnected: console.log("Client disconnected")
        onMessageReceived: console.log("Message received:", message)
    }

    NetManager {
        id: netManager
    }

    SerialPortManager {
        id: serialPortManager
        onDataReceived: {
            var str = data.toString();
            var getdata = str.split(" ")
            var lengthlow = getdata[3];
            var lengthheight = getdata[4];
            var length = parseInt(getdata[4] + getdata[3],16);
            strcode = getdata[7] + getdata[8];
            var num = getdata.slice(9,length+4);
            
            // 只保留电池状态相关处理
            if(strcode == "9880"){
                var value = parseInt(getdata[9]+getdata[10],16);
                batteryIndicator.batteryLevel = (value-1.75)*200;
            }else if(strcode == "9980"){
                var batteryconnet = parseInt(getdata[9],16);
                var batterystatus = parseInt(getdata[10],16);
                if(batteryconnet===1){
                    batteryIndicator.isCharging = (batterystatus === 1) ? true : false;
                }
            }
            
            // 将数据传递给当前显示的SignalAnalyzer实例
            if (bar.currentIndex === 0) {
                monitorAnalyzer.processReceiveData(strcode, getdata);
            } else if (bar.currentIndex === 1) {
                signalInfoAnalyzer.processReceiveData(strcode, getdata);
            } else if (bar.currentIndex === 2) {
                edidAnalyzer.processReceiveData(strcode, getdata);
            } else if (bar.currentIndex === 3) {
                errorRateAnalyzer.processReceiveData(strcode, getdata);
            }
        }

        onDataReceivedASCALL:{
            // 将ASCII数据传递给当前显示的SignalAnalyzer实例
            if (bar.currentIndex === 0) {
                monitorAnalyzer.processReceiveAsciiData(data);
            } else if (bar.currentIndex === 1) {
                signalInfoAnalyzer.processReceiveAsciiData(data);
            } else if (bar.currentIndex === 2) {
                edidAnalyzer.processReceiveAsciiData(data);
            } else if (bar.currentIndex === 3) {
                errorRateAnalyzer.processReceiveAsciiData(data);
            }
        }
    }


    FontLoader {
        id:fontNimbusSanL
        source: "qrc:/fonts/BebasKai-Regular.otf"
    }
    FontLoader {
        id:myriadPro
        source: "qrc:/fonts/MyriadPro-Cond.ttf"
    }
    
    // 新的主页面设计
    Rectangle {
        id: mainContainer
        anchors.fill: parent
        color: "lightgray"

        // 顶部菜单栏
        TabBar {
            id: bar
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width
            contentHeight: 120
            currentIndex: 0 // 默认选择第一个"Monitor"选项

            TabButton {
                text: "Monitor"
                font.family: myriadPro.name
                font.pixelSize: 40
            }
            TabButton {
                text: "Signal Info"
                font.family: myriadPro.name
                font.pixelSize: 40
            }
            TabButton {
                text: "EDID"
                font.family: myriadPro.name
                font.pixelSize: 40
            }
            TabButton {
                text: "Error Rate"
                font.family: myriadPro.name
                font.pixelSize: 40
            }
        }

        // 内容区域 - 使用StackLayout和SignalAnalyzer
        StackLayout {
            width: parent.width
            height: parent.height - bar.height
            anchors.top: bar.bottom
            anchors.left: bar.left
            currentIndex: bar.currentIndex

            // 1: Monitor 页面
            Item {
                id: monitorPage
                SignalAnalyzer {
                    id: monitorAnalyzer
                    anchors.fill: parent
                    pageFlag: 1 // Monitor
                }
            }

            // 2: Signal Info 页面
            Item {
                id: signalInfoPage
                SignalAnalyzer {
                    id: signalInfoAnalyzer
                    anchors.fill: parent
                    pageFlag: 2 // Signal Info
                }
            }

            // 3: EDID 页面
            Item {
                id: edidPage
                SignalAnalyzer {
                    id: edidAnalyzer
                    anchors.fill: parent
                    pageFlag: 3 // EDID
                }
            }

            // 4: Error Rate 页面
            Item {
                id: errorRatePage
                SignalAnalyzer {
                    id: errorRateAnalyzer
                    anchors.fill: parent
                    pageFlag: 4 // Error Rate
                }
            }
        }
    }

    //init
    Component.onCompleted: {
        webSocketServer.startServer();
        // 不再需要之前的初始化代码，因为相关组件已被移除
    }

    //send commend
    // 我们不再需要之前的信号连接，因为相关组件已被移除
}

