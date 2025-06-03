// SystemSetupPanel.qml
// 系统设置面板，包含IP管理、风扇控制、重置重启、设备状态等功能
// 适配当前应用的蓝色风格主题

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Rectangle {
    id: systemSetupPanel
    anchors.fill: parent
    color: "#585858"  // Unified blue background
    border.color: "black"
    border.width: 2
    radius: 4

    // Signal definition for communication with C++ backend
    signal confirmsignal(string str, var num)

    // Add property aliases for backward compatibility
    property alias hostIpText: hostIpField.text
    property alias ipMaskText: ipMaskField.text
    property alias routerIpText: routerIpField.text

    // Or provide more direct text access
    function getHostIp() { return hostIpField.text; }
    function getIpMask() { return ipMaskField.text; }
    function getRouterIp() { return routerIpField.text; }

    // Property definitions
    property bool isDhcpMode: true
    property int fanControlMode: 0
    property int currentSection: 0  // Current display section: 0=IP, 1=Fan, 2=FPGA, 3=Reset, 4=Vitals

    // 主布局
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // 标题
        Text {
            text: qsTr("System Setup")
            font.bold: true
            font.pixelSize: 36
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        // 功能导航按钮区
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            spacing: 10

            Repeater {
                model: [
                    { name: "IP Management", index: 0 },
                    { name: "Fan Control", index: 1 },
                    { name: "FPGA Control", index: 2 },
                    { name: "Reset & Reboot", index: 3 },
                    { name: "Vitals", index: 4 }
                ]
                
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    text: modelData.name
                    font.pixelSize: 16
                    
                    background: Rectangle {
                        color: currentSection === modelData.index ? "#ffffff" : "#888888"
                        border.color: "black"
                        border.width: 2
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: currentSection === modelData.index ? "black" : "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        currentSection = modelData.index
                        // 如果切换到Vitals页面，请求设备状态
                        if (modelData.index === 4) {
                            requestVitalsData()
                        }
                    }
                }
            }
        }

        // 内容区域
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // IP管理面板
            Rectangle {
                visible: currentSection === 0
                width: parent.parent.width - 40
                height: Math.max(600, ipColumn.implicitHeight + 40)
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                Column {
                    id: ipColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20

                    // 在IP表单上方添加实时状态显示
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 40
                        height: 100
                        color: "transparent"
                        border.color: "yellow"
                        border.width: 2
                        radius: 4
                        
                        Column {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 5
                            
                            Text {
                                text: "当前网络状态"
                                font.pixelSize: 18
                                font.bold: true
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            
                            Text {
                                text: "IP: " + (netManager.ipAddress || "未检测到")
                                font.pixelSize: 16
                                color: "white"
                            }
                            
                            Text {
                                text: "网关: " + (netManager.routerIpAddress || "未检测到")
                                font.pixelSize: 16
                                color: "white"
                            }
                            
                            Text {
                                text: "MAC: " + (netManager.macAddress || "未检测到")
                                font.pixelSize: 16
                                color: "white"
                            }
                        }
                    }

                    // IP设置表单
                    Grid {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 15
                        anchors.horizontalCenter: parent.horizontalCenter

                        // HOST IP
                        Text {
                            text: "HOST IP:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "white"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            TextField {
                                id: hostIpField
                                anchors.fill: parent
                                anchors.margins: 2
                                text: netManager.ipAddress || "192.168.1.199"
                                font.pixelSize: 20
                                horizontalAlignment: TextInput.AlignHCenter
                                background: Rectangle { color: "transparent" }
                                
                                onPressed: {
                                    currentInputField = hostIpField;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }

                        // ROUTER IP
                        Text {
                            text: "ROUTER IP:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "white"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            TextField {
                                id: routerIpField
                                anchors.fill: parent
                                anchors.margins: 2
                                text: netManager.routerIpAddress || "192.168.1.254"
                                font.pixelSize: 20
                                horizontalAlignment: TextInput.AlignHCenter
                                background: Rectangle { color: "transparent" }
                                
                                onPressed: {
                                    currentInputField = routerIpField;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }

                        // IP MASK
                        Text {
                            text: "IP MASK:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "white"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            TextField {
                                id: ipMaskField
                                anchors.fill: parent
                                anchors.margins: 2
                                text: netManager.netmask || "255.255.255.0"
                                font.pixelSize: 20
                                horizontalAlignment: TextInput.AlignHCenter
                                background: Rectangle { color: "transparent" }
                                
                                onPressed: {
                                    currentInputField = ipMaskField;
                                    virtualKeyboard.visible = true
                                }
                            }
                        }

                        // MAC ADDRESS (只读)
                        Text {
                            text: "MAC ADDRESS:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "#eeeeee"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            Text {
                                id: macAddressText
                                anchors.centerIn: parent
                                text: netManager.macAddress || "00:00:00:00:00:00"
                                font.pixelSize: 20
                                color: "#666666"
                            }
                        }

                        // TCP PORT (只读)
                        Text {
                            text: "TCP PORT:"
                            font.pixelSize: 24
                            color: "white"
                            width: 200
                            verticalAlignment: Text.AlignVCenter
                        }
                        Rectangle {
                            width: 300
                            height: 50
                            color: "#eeeeee"
                            border.color: "#888888"
                            border.width: 1
                            radius: 4
                            
                            Text {
                                id: tcpPortText
                                anchors.centerIn: parent
                                text: "8080"
                                font.pixelSize: 20
                                color: "#666666"
                            }
                        }
                    }

                    // DHCP/Static 切换按钮
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 20
                        
                        Button {
                            text: "DHCP"
                            font.pixelSize: 20
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 60
                            
                            background: Rectangle {
                                color: isDhcpMode ? "#ffffff" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: isDhcpMode ? "black" : "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                if (!isDhcpMode) {  // 只有在未启用DHCP时才执行
                                    console.log("Switching to DHCP mode");
                                    isDhcpMode = true;
                                    confirmsignal("DHCP", true);  // 发送true启用DHCP
                                }
                            }
                        }
                        
                        Button {
                            text: "Static"
                            font.pixelSize: 20
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 60
                            
                            background: Rectangle {
                                color: !isDhcpMode ? "#ffffff" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: !isDhcpMode ? "black" : "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                isDhcpMode = false
                                confirmsignal("DHCP", false)
                            }
                        }
                    }

                    // 在DHCP/Static按钮下方添加Apply按钮
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 20
                        visible: !isDhcpMode  // 只在静态IP模式下显示
                        
                        Button {
                            text: "Apply Static IP"
                            font.pixelSize: 18
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 50
                            
                            background: Rectangle {
                                color: "#4CAF50"  // 绿色
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                // 强制刷新输入框的值
                                hostIpField.focus = false;
                                routerIpField.focus = false;
                                ipMaskField.focus = false;
                                
                                // 等待一帧后读取值
                                Qt.callLater(function() {
                                    console.log("Applying static IP configuration");
                                    console.log("- Host IP:", hostIpField.text);
                                    console.log("- Router IP:", routerIpField.text);
                                    console.log("- IP Mask:", ipMaskField.text);
                                    
                                    // 使用实际的文本值而不是属性绑定
                                    var actualHostIp = hostIpField.text;
                                    var actualRouterIp = routerIpField.text;
                                    var actualIpMask = ipMaskField.text;
                                    
                                    console.log("Actual values to apply:");
                                    console.log("- Host IP:", actualHostIp);
                                    console.log("- Router IP:", actualRouterIp);
                                    console.log("- IP Mask:", actualIpMask);
                                    
                                    // 直接调用netManager设置，不依赖confirmsignal
                                    netManager.setIpAddress(actualHostIp, actualIpMask, actualRouterIp, "static");
                                });
                            }
                        }
                    }
                }
            }

            // 风扇控制面板
            Rectangle {
                visible: currentSection === 1
                width: parent.parent.width - 40
                height: 400
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                GridLayout {
                    anchors.centerIn: parent
                    columns: 3
                    rowSpacing: 20
                    columnSpacing: 20

                    Repeater {
                        model: [
                            { name: "OFF", value: 0x00 },
                            { name: "LOW SPEED", value: 0x01 },
                            { name: "MIDDLE SPEED", value: 0x02 },
                            { name: "HIGH SPEED", value: 0x03 },
                            { name: "AUTO", value: 0x04 }
                        ]
                        
                        Button {
                            text: modelData.name
                            font.pixelSize: 18
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 80
                            
                            background: Rectangle {
                                color: fanControlMode === modelData.value ? "#ffffff" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: fanControlMode === modelData.value ? "black" : "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                fanControlMode = modelData.value
                                confirmsignal("FanControl", modelData.value)
                            }
                        }
                    }
                }
            }

            // FPGA控制面板
            Rectangle {
                visible: currentSection === 2
                width: parent.parent.width - 40
                height: 500
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 30

                    // 标题
                    Text {
                        text: "FPGA Flash升级控制"
                        font.pixelSize: 28
                        font.bold: true
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 状态显示
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 40
                        height: 100
                        color: "transparent"
                        border.color: gpioController.fpgaFlashMode ? "#ff6666" : "#66ff66"
                        border.width: 2
                        radius: 4
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: "当前状态："
                                font.pixelSize: 20
                                font.bold: true
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            
                            Text {
                                text: gpioController.fpgaFlashMode ? "FPGA Flash升级模式" : "正常工作模式"
                                font.pixelSize: 18
                                color: gpioController.fpgaFlashMode ? "#ff6666" : "#66ff66"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            
                            Text {
                                text: gpioController.fpgaFlashMode ? 
                                      "A21: HIGH | U3: LOW | AF2: LOW" : 
                                      "A21: LOW | U3: HIGH | AF2: HIGH-Z"
                                font.pixelSize: 16
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // 控制按钮
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 50
                        
                        Button {
                            text: "进入升级模式"
                            font.pixelSize: 20
                            Layout.preferredWidth: 250
                            Layout.preferredHeight: 100
                            enabled: !gpioController.fpgaFlashMode
                            
                            background: Rectangle {
                                color: parent.enabled ? "#ff6666" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                gpioController.enterFpgaFlashMode()
                            }
                        }
                        
                        Button {
                            text: "退出升级模式"
                            font.pixelSize: 20
                            Layout.preferredWidth: 250
                            Layout.preferredHeight: 100
                            enabled: gpioController.fpgaFlashMode
                            
                            background: Rectangle {
                                color: parent.enabled ? "#66ff66" : "#888888"
                                border.color: "black"
                                border.width: 2
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font: parent.font
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                gpioController.exitFpgaFlashMode()
                            }
                        }
                    }

                    // 说明文本
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 40
                        height: 120
                        color: "transparent"
                        border.color: "yellow"
                        border.width: 1
                        radius: 4
                        
                        Column {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 8
                            
                            Text {
                                text: "使用说明："
                                font.pixelSize: 18
                                font.bold: true
                                color: "yellow"
                            }
                            
                            Text {
                                text: "• 进入升级模式：A21拉高，U3拉低，AF2设为低电平"
                                font.pixelSize: 14
                                color: "white"
                                wrapMode: Text.WordWrap
                                width: parent.width - 10
                            }
                            
                            Text {
                                text: "• 退出升级模式：A21拉低，U3拉高，AF2恢复高阻状态"
                                font.pixelSize: 14
                                color: "white"
                                wrapMode: Text.WordWrap
                                width: parent.width - 10
                            }
                            
                            Text {
                                text: "• 升级完成后请务必退出升级模式，恢复正常工作状态"
                                font.pixelSize: 14
                                color: "#ffaa00"
                                wrapMode: Text.WordWrap
                                width: parent.width - 10
                            }
                        }
                    }
                }
            }

            // 重置重启面板
            Rectangle {
                visible: currentSection === 3
                width: parent.parent.width - 40
                height: 300
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 50
                    
                    Button {
                        text: "Reset Default"
                        font.pixelSize: 20
                        Layout.preferredWidth: 250
                        Layout.preferredHeight: 100
                        
                        background: Rectangle {
                            color: "#ff6666"
                            border.color: "black"
                            border.width: 2
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            confirmsignal("ResetDefault", true)
                        }
                    }
                    
                    Button {
                        text: "Reboot"
                        font.pixelSize: 20
                        Layout.preferredWidth: 250
                        Layout.preferredHeight: 100
                        
                        background: Rectangle {
                            color: "#ffaa00"
                            border.color: "black"
                            border.width: 2
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            confirmsignal("Reboot", true)
                        }
                    }
                }
            }

            // 设备状态面板
            Rectangle {
                visible: currentSection === 4
                width: parent.parent.width - 40
                height: Math.max(800, vitalsColumn.implicitHeight + 40)
                color: "transparent"
                border.color: "white"
                border.width: 2
                radius: 8

                Column {
                    id: vitalsColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 30

                    // 固件版本信息
                    Column {
                        width: parent.width
                        spacing: 15

                        Text {
                            text: "FIRMWARE VERSION"
                            font.pixelSize: 28
                            font.bold: true
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Grid {
                            columns: 2
                            columnSpacing: 20
                            rowSpacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            // Main MCU
                            Text {
                                text: "Main MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: mainMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // TX MCU
                            Text {
                                text: "TX MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: txMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // Key MCU
                            Text {
                                text: "Key MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: keyMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // LAN MCU
                            Text {
                                text: "LAN MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: lanMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // AV MCU
                            Text {
                                text: "AV MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: avMcuText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // Main FPGA
                            Text {
                                text: "Main FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: mainFpgaText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // AUX FPGA
                            Text {
                                text: "AUX FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: auxFpgaText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // AUX2 FPGA
                            Text {
                                text: "AUX2 FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: aux2FpgaText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // DSP Module
                            Text {
                                text: "DSP Module:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: dspModuleText
                                    anchors.centerIn: parent
                                    text: "v1.0.0"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }
                        }
                    }

                    // 芯片温度信息
                    Column {
                        width: parent.width
                        spacing: 15

                        Text {
                            text: "MAIN CHIP TEMPERATURE"
                            font.pixelSize: 28
                            font.bold: true
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Grid {
                            columns: 2
                            columnSpacing: 20
                            rowSpacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            // Main MCU Temperature
                            Text {
                                text: "Main MCU:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: mainMcuTempText
                                    anchors.centerIn: parent
                                    text: "25°C"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // Main FPGA Temperature
                            Text {
                                text: "Main FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: mainFpgaTempText
                                    anchors.centerIn: parent
                                    text: "25°C"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }

                            // AUX FPGA Temperature
                            Text {
                                text: "AUX FPGA:"
                                font.pixelSize: 20
                                color: "white"
                                width: 150
                                verticalAlignment: Text.AlignVCenter
                            }
                            Rectangle {
                                width: 200
                                height: 35
                                color: "white"
                                border.color: "#888888"
                                border.width: 1
                                radius: 4
                                Text {
                                    id: auxFpgaTempText
                                    anchors.centerIn: parent
                                    text: "25°C"
                                    font.pixelSize: 18
                                    color: "black"
                                }
                            }
                        }
                    }
                }
            }

        }
    }

    // 请求设备状态信息
    function requestVitalsData() {
        // 发送请求获取各组件状态
        confirmsignal("vitals", 0x00); // KEY MCU
        confirmsignal("vitals", 0x01); // MAIN MCU
        confirmsignal("vitals", 0x02); // TX MCU
        confirmsignal("vitals", 0x10); // MAIN FPGA
        confirmsignal("vitals", 0x11); // AUX FPGA
        confirmsignal("vitals", 0x12); // AUX2 FPGA
        confirmsignal("vitals", 0x20); // LAN MCU
        confirmsignal("vitals", 0x21); // AV MCU
        confirmsignal("vitals", 0x22); // DSP Module
        confirmsignal("vitals", 0x30); // Power Management
        confirmsignal("vitals", 0xff); // all component
    }

    // 添加用于更新版本信息的函数
    function updateVersionInfo(componentId, version) {
        var textComponent = systemSetupPanel[componentId + "Text"]
        if (textComponent) {
            textComponent.text = version
        }
    }
    
    // 添加用于更新温度信息的函数
    function updateTemperatureInfo(componentId, temperature) {
        var textComponent = systemSetupPanel[componentId + "Text"]
        if (textComponent) {
            textComponent.text = temperature
        }
    }

    // 添加网络信息更新函数
    function updateNetworkDisplay() {
        console.log("Updating SystemSetup network display");
        console.log("- IP from netManager:", netManager.ipAddress);
        console.log("- MAC from netManager:", netManager.macAddress);
        
        // 强制更新显示（如果绑定没有自动更新）
        if (netManager.ipAddress) {
            hostIpField.text = netManager.ipAddress;
        }
        if (netManager.macAddress) {
            macAddressText.text = netManager.macAddress;
        }
        if (netManager.netmask) {
            ipMaskField.text = netManager.netmask;
        }
        if (netManager.routerIpAddress) {
            routerIpField.text = netManager.routerIpAddress;
        }
    }

    // 在SystemSetupPanel中添加DHCP状态显示和错误处理
    Rectangle {
        id: dhcpStatusRect
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 40
        height: 60
        color: "transparent"
        border.color: dhcpStatusText.text.includes("faile") ? "red" : "yellow"
        border.width: 2
        radius: 4
        visible: isDhcpMode
        
        Text {
            id: dhcpStatusText
            anchors.centerIn: parent
            text: "DHCP status: requiring IP..."
            font.pixelSize: 16
            color: "white"
            font.bold: true
        }
        
        // DHCP状态更新定时器
        Timer {
            id: dhcpStatusTimer
            interval: 30000  // 30秒超时
            repeat: false
            onTriggered: {
                dhcpStatusText.text = "DHCP timeout: There may be no DHCP server in the network. It is recommended to use a static IP."
                dhcpStatusRect.border.color = "red"
            }
        }
    }

    // 添加建议切换到静态IP的按钮
    Button {
        text: "change to static IP"
        visible: isDhcpMode && dhcpStatusText.text.includes("faile")
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.preferredWidth: 200
        Layout.preferredHeight: 50
        
        background: Rectangle {
            color: "#FF9800"
            border.color: "black"
            border.width: 2
            radius: 4
        }
        
        contentItem: Text {
            text: parent.text
            font: parent.font
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        
        onClicked: {
            console.log("Switching back to static IP mode");
            isDhcpMode = false;
            dhcpStatusRect.visible = false;
        }
    }

    // 添加网络测试函数
    function testNetworkConnectivity() {
        // 执行ping测试
        terminalManager.executeCommand("ping -c 3 8.8.8.8");
        
        // 显示测试结果
        console.log("Network connectivity test initiated");
    }

    // 添加DHCP错误显示函数
    function showDhcpError(error) {
        dhcpStatusText.text = "DHCP faile: " + error;
        dhcpStatusRect.border.color = "red";
        dhcpStatusRect.visible = true;
    }

    // GPIO控制器信号连接
    Connections {
        target: gpioController
        
        function onGpioOperationResult(success, message) {
            console.log("GPIO操作结果:", success, message);
            
            // 可以在这里添加消息提示框或状态更新
            if (success) {
                console.log("GPIO操作成功:", message);
            } else {
                console.log("GPIO操作失败:", message);
            }
        }
        
        function onFpgaFlashModeChanged() {
            console.log("FPGA Flash模式状态改变:", gpioController.fpgaFlashMode);
        }
    }
} 